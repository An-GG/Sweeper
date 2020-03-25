//
//  LiveFFAGameView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

class LiveFFAGameView : View, LiveGameDelegate, LiveMinefieldViewDelegate {
    
    let sweeperLiveLogo = UIImageView()
    let lobbyView = LobbyView()
    let gameOptionsView = GameOptionsView()
    let gameInstructionsView = GameInstructionsView()
    let readyButton = ReadyButtonView()
    let minefieldView = LiveMinefieldView()
    
    let generator = FieldModel()
    var topField : String = ""
    
    let LIVE_LOGO_PADDING : CGFloat = 30
    
    var chanceNumber = 0
    var nPlayersLastUpdate = 0
    var currentGameRef : DatabaseReference?
    var playerRef : DatabaseReference?
    var id : String?
    
    override func initialize() {
        
        readyButton.delegate = self
        
        sweeperLiveLogo.image = UIImage(named: "LiveLogoClear")
        sweeperLiveLogo.contentMode = .scaleAspectFit
        
        minefieldView.delegate = self
        minefieldView.isHidden = true

        // Options: Time Limit, Partners or Solo, Enemy Mines (Hidden or Shown)

        let ops = [GameOptionView(name: "TIME LIMIT", bigLabelText: "5:00", image: nil), GameOptionView(name: "MODE", bigLabelText: "SOLO", image: nil), GameOptionView(name: "ENEMY MINES", bigLabelText: "SHOWN", image: nil)]
        gameOptionsView.set(options: ops)
        
        self.addSubview(gameInstructionsView)
        self.addSubview(lobbyView)
        self.addSubview(readyButton)
        self.addSubview(sweeperLiveLogo)
        self.addSubview(gameOptionsView)
        self.addSubview(minefieldView)
    }
    
    override func layout() {
        sweeperLiveLogo.frame = CGRect(x: LIVE_LOGO_PADDING, y: 15, width: bounds.width - 2*LIVE_LOGO_PADDING, height: 100)
        gameOptionsView.frame = CGRect(x: 0, y: 130, width: bounds.width, height: gameOptionsView.SUGGESTED_HEIGHT)
        lobbyView.frame = CGRect(x: 0, y: 220, width: bounds.width, height: lobbyView.SUGGESTED_HEIGHT)
        readyButton.frame = CGRect(x: (bounds.width - readyButton.SUGGESTED_WIDTH) / 2, y: 350, width: readyButton.SUGGESTED_WIDTH, height: readyButton.SUGGESTED_HEIGHT)
        gameInstructionsView.frame = CGRect(x: 0, y: bounds.height - 130, width: bounds.width, height: bounds.height)
        minefieldView.frame = bounds
    }
    
    // Internal Methods
    func liveUpdate(snap : DataSnapshot) {
        
        // Connection Update
        GlobalLiveGameView?.connectionStatusBar.set(status: .connected)
        
        if let _ = snap.value as? [String:Any] {} else {
            return
        }
        
        let val = snap.value as! [String:Any]
        
        // Lobby Update
        var lobby : [LobbyPlayer] = []
        if let players = val["PLAYERS"] as? [String:[String:String]] {
            let playerKeys = players.keys.sorted()
            for key in playerKeys {
                let player = players[key]!
                let lobbyPlayer = LobbyPlayer(name: player["NAME"]!, imageName: player["IMAGENAME"]!, displayLetters: player["DISPLAYLETTERS"]!, color: player["COLOR"]!, id: player["ID"]!, ready: player["READY"]!)
                lobbyPlayer.chance = player["CHANCE"]
                lobbyPlayer.key = key
                lobby.append(lobbyPlayer)
            }
            lobbyView.set(players: lobby)
        }
        
        // Assign Colors
        var colorForId : [String:UIColor] = [:]
        var playerKeyForChance : [String:String] = [:]
        for player in lobby {
            playerKeyForChance[player.chance!] = player.id
        }
        var counter = 0
        for playerKey in playerKeyForChance.keys.sorted() {
            colorForId[playerKeyForChance[playerKey]!] = UIColor(hex: PlayerColors[counter])!
            if counter < 7 {
                counter += 1
            } else {
                counter = 0
            }
        }
        
        // Check Ready Condition
        var somePlayerNotReady = false
        for player in lobby {
            if player.ready == "NO" {
                somePlayerNotReady = true
            }
        }
        if !somePlayerNotReady {
            readyConditionMet()
        }
        
        // Minefield Events
        if let log = val["EVENTLOG"] as? [String:[String:Any]] {
            minefieldView.field.renderGrid()
            let events = log.keys.sorted()
            for event in events {
                let x = log[event]?["CELL_X"] as! String
                let y = log[event]?["CELL_Y"] as! String
                let type = log[event]?["TYPE"] as! String
                let id = log[event]?["PLAYER"] as! String
                let color = colorForId[id]
                if type == "OPENED" {
                    minefieldView.setCell(x: Int(x)!, y: Int(y)!, status: .opened)
                }
            }
        } else {
            print("Log not found in snapshot.")
        }
        
        // Propose Minefield
        if nPlayersLastUpdate != lobby.count {
            nPlayersLastUpdate = lobby.count
            generator.generateGrid(X: 16, Y: 30, nMines: 99)
            let encodedField = globalComms.encode(fieldModel: generator)
            currentGameRef?.child("FIELD").child(String(chanceNumber)).setValue(encodedField)
        }
        
        
        
    }
    
    var readyConditionAlreadyMet = false
    func readyConditionMet() {
        if !readyConditionAlreadyMet {
            readyConditionAlreadyMet = true
            // Freeze UI
            
            // Delay to Make Sure
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.currentGameRef?.child("FIELD").observeSingleEvent(of: .value, with: { (snap) in
                    if let val = snap.value {
                        if let fields = val as? [String:String] {
                            let topKey = fields.keys.sorted().first!
                            self.topField = fields[topKey]!
                            let decoded = globalComms.decode(fieldString: self.topField)
                            self.minefieldView.setField(field: decoded)
                            self.minefieldView.isHidden = false
                        }
                    } else {
                        print("ERROR: FIELD directory not found in database.")
                    }
                })
            }
        }
    }
    
    // Delegate Interaction
    func becameReady() {
        playerRef?.child("READY").setValue("YES")
    }
    
    func becameUnready() {
        playerRef?.child("READY").setValue("NO")
    }
    
    
    
    func cellUpdate(x: Int, y: Int, status: CellUpdateType) {
        let event : [String:String] = [
            "CELL_X" : String(x),
            "CELL_Y" : String(y),
            "TYPE" : status.rawValue,
            "PLAYER" : id!
        ]
        currentGameRef?.child("EVENTLOG").childByAutoId().setValue(event)
    }
    
    // Controller Interaction
    func startGame(UGID : String) {
        currentGameRef = globalDatabseRef.child(UGID)
        playerRef = currentGameRef?.child("PLAYERS").childByAutoId()
        id = convo?.localParticipantIdentifier.uuidString
        chanceNumber = randomNumber()
        
        // List User As Participant on DB
        var playerDict = LobbyPlayer(name: "Ankush", imageName: "", displayLetters: "AG", color: "Green", id: id!, ready: "NO").getDictionary()
        playerDict["CHANCE"] = String(chanceNumber)
        playerRef?.setValue(playerDict)
        
        // Listen for All Updates
        currentGameRef?.observe(.value) { (snap) in
            self.liveUpdate(snap: snap)
        }
    }
    
}


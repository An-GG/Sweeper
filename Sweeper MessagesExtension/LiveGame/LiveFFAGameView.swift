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
    
    let LIVE_LOGO_PADDING : CGFloat = 30
    
    var chanceNumber = 0
    var nPlayersLastUpdate = 0
    var currentGameRef : DatabaseReference?
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
    
    // Internal Functions
    func liveUpdate(snap : DataSnapshot) {
        
        let val = snap.value as! [String:Any]
        
        // Lobby Update
        var lobby : [LobbyPlayer] = []
        if let players = val["PLAYERS"] as? [String:[String:String]] {
            let playerKeys = players.keys.sorted()
            for key in playerKeys {
                let player = players[key]!
                print(player)
                let lobbyPlayer = LobbyPlayer(name: player["NAME"]!, imageName: player["IMAGENAME"]!, displayLetters: player["DISPLAYLETTERS"]!, color: player["COLOR"]!, id: player["ID"]!)
                lobby.append(lobbyPlayer)
            }
            lobbyView.set(players: lobby)
        }
        
        // Minefield Events
        if let log = val["EVENTLOG"] as? [String:[String:Any]] {
            minefieldView.field.renderGrid()
            let events = log.keys.sorted()
            for event in events {
                let x = log[event]?["CELL_X"] as! String
                let y = log[event]?["CELL_Y"] as! String
                let type = log[event]?["TYPE"] as! String
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
    
    
    // Delegate Interaction
    func becameReady() {
        startGame(UGID: "ASAelkjyffe")
        //minefieldView.isHidden = false
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
        id = convo?.localParticipantIdentifier.uuidString
        chanceNumber = randomNumber()
        
        // List User As Participant on DB
        let playerDict = LobbyPlayer(name: "Ankush", imageName: "", displayLetters: "AG", color: "Green", id: id!).getDictionary()
        currentGameRef?.child("PLAYERS").childByAutoId().setValue(playerDict)
        
        // Listen for All Updates
        currentGameRef?.observe(.value) { (snap) in
            self.liveUpdate(snap: snap)
        }
    }
    
}


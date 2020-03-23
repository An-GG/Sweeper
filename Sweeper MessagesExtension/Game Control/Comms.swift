//
//  Comms.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/26/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import Messages

class Comms {
    
    var loadedGame : Game?
    
    func decode(fieldString : String) -> FieldModel {
        var cellArr : [[CellModel]] = []
        
        var workingRow : [CellModel] = []
        var nextIsMine = false
        for x in fieldString {
            let mine = CellModel()
            
            if x == "R" {
                cellArr.append(workingRow)
                workingRow = []
                continue
            }
            
            if x == "M" {
                nextIsMine = true
                continue
            }
            
            if nextIsMine {
                nextIsMine = false
                mine.setValue(isMine: true, surroundingMines: Int(String(x))!)
                workingRow.append(mine)
                continue
            }
            
            mine.setValue(isMine: false, surroundingMines: Int(String(x))!)
            workingRow.append(mine)
        }
        
        let model = FieldModel()
        model.grid = cellArr
        model.setX = cellArr.count
        model.setY = cellArr[0].count
        return model
    }
    
    func encode(fieldModel : FieldModel?) -> String {
        var encodedRepresentation = ""
        if let _ = fieldModel {
            for y in fieldModel!.grid {
                for x in y {
                    if x.isMine {
                        encodedRepresentation += "M"
                    }
                    encodedRepresentation += String(x.surroundingMines)
                }
                encodedRepresentation += "R"
            }
        }
        return encodedRepresentation
    }
    
    func checkURLValid(url : URL?) {
        
    }
    
    func send(game : Game) {
        
        // Create URL To Encode Data
        guard var components = URLComponents(string: "scraperprivate.comms") else {
            fatalError("Invalid base url")
        }
        var gamemodeString = ""
        switch game.gamemode {
        case .FFA:
            gamemodeString = "FFA"
        case .timed:
            gamemodeString = "timed"
        case .live:
            gamemodeString = "live"
        case .swap:
            gamemodeString = "swap"
        default:
            gamemodeString = "UNKNOWN GAMEMODE"
        }
        
        let uniqueGameID = randomString(length: 20)
        
        let field = URLQueryItem(name: "field", value: encode(fieldModel: game.fieldModel))
        let gamemode = URLQueryItem(name: "gamemode", value: gamemodeString)
        let isInstigator = URLQueryItem(name: "isInstigator", value: String(game.isInstigator))
        let timeInst = URLQueryItem(name: "timeInstigator", value: String(game.instigatorTime))
        let instFail = URLQueryItem(name: "instigatorFail", value: String(game.instigatorFail))
        let UGID = URLQueryItem(name: "UGID", value: uniqueGameID)
        components.queryItems = [field, gamemode, isInstigator, timeInst, instFail, UGID]
        
        guard let url = components.url else {
            fatalError("Invalid URL Components")
        }
        
        // Create MSMessage Object
        let message = MSMessage()
        message.url = url
        
        let layout = MSMessageTemplateLayout()
        // Layout Content Based On: isInstigator, Gamemode, and Failure
        layout.subcaption = "Sweeper: Multiplayer Mines Puzzle"
        
        // BUILD LAYOUT FOR FFA
        if game.gamemode == .FFA {
            layout.caption = "Play Sweeper LIVE: Free For All!"
            layout.image = UIImage(named: "TimedGameInstigatorSend")
        }
        
        // BUILD LAYOUT FOR TIMED
        if game.gamemode == .timed {
            if game.isInstigator {
                if game.instigatorFail {
                    
                } else {
                    
                }
                layout.image = UIImage(named: "TimedGameInstigatorSend")
                layout.caption = "Can you beat my time?"
                layout.imageTitle = String(game.instigatorTime) + " Minutes."
                
            }
        }
        
        message.layout = layout
        
        globalController?.requestPresentationStyle(.compact)
        convo!.send(message, completionHandler: nil)
        
    }
    
    func sendLoadedGame() {
        if let game = loadedGame {
            send(game: game)
        } else {
            print("Error: No Game Loaded. Comms Send Failed")
        }
    }
    
    func launchGame(url : URL) {
        
        
        
        // Error Checking and Translation
        var componentDictionary : [String:String] = [:]
        if let components = URLComponents(string: url.absoluteString) {
            if let items = components.queryItems {
                for item in items {
                    if let result = item.value {
                        componentDictionary[item.name] = result
                    }
                }
            } else {
                print("URL Data Did Not Contain Query Items")
            }
        } else {
            print("URL Data Could Not Be Parsed")
        }
        
        
        // Game Launch
        if componentDictionary["gamemode"] == "timed" {
            // Check If User Sent
            if convo?.selectedMessage?.senderParticipantIdentifier == convo?.localParticipantIdentifier {
                return
            }
            let fieldString = componentDictionary["field"]!
            let field = decode(fieldString: fieldString)
            globalController!.dismiss(animated: true, completion: nil)
            GlobalTimedGameController!.model = field
            GlobalTimedGameController!.resetAllViews()
            GlobalTimedGameController!.setupFieldFromModel()
            GlobalTimedGameController!.presentGame()
        }
        
        if componentDictionary["gamemode"] == "FFA" {
            globalController?.startLiveGame(UGID: componentDictionary["UGID"]!, gamemode: .FFA)
        }
        
    }
    
    
    
}

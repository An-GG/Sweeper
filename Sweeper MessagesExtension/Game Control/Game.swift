//
//  Game.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/26/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation

class Game {
    
    var gamemode:Gamemode
    var fieldModel:FieldModel?
    
    //For Timed Game
    var isInstigator = false
    var instigatorTime:Double = 0
    var instigatorFail = false
    var responderTime:Double = 0
    var responderFail = false
    
    convenience init(gamemode : Gamemode) {
        self.init(gamemode: gamemode, fieldModel: nil)
    }
    
    required init(gamemode : Gamemode, fieldModel : FieldModel?) {
        self.gamemode = gamemode
        self.fieldModel = fieldModel
    }
}

enum Gamemode {
    case timed
    case FFA
    case swap
    case live
}

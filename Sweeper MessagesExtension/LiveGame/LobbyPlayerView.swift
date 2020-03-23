//
//  LobbyPlayerView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/23/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LobbyPlayerView : View {
    
    var player : LobbyPlayer? {
        didSet {
            updatePlayer()
        }
    }
    
    override func initialize() {
        
    }
    
    override func layout() {
        
    }
    
    // Internal Methods
    
    private func updatePlayer() {
        
    }
    
    // Controller Interaction
    
}


class LobbyPlayer {
    var name : String
    var imageName : String
    var displayLetters : String
    var color : String
    var id : String
    
    required init(name: String, imageName: String, displayLetters: String, color: String, id : String) {
        self.name = name
        self.imageName = imageName
        self.displayLetters = displayLetters
        self.color = color
        self.id = id
    }
}

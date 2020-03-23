//
//  LiveFFAGameView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LiveFFAGameView : View {
    
    let sweeperLiveLogo = UIImageView()
    let lobbyView = LobbyView()
    let gameOptionsView = GameOptionsView()
    let gameInstructionsView = GameInstructionsView()
    let readyButton = ReadyButtonView()
    
    let LIVE_LOGO_PADDING : CGFloat = 30
    
    override func initialize() {
        
        sweeperLiveLogo.image = #imageLiteral(resourceName: "LiveLogo.png")
        sweeperLiveLogo.contentMode = .scaleAspectFit
        
        self.addSubview(gameInstructionsView)
        self.addSubview(lobbyView)
        self.addSubview(readyButton)
        self.addSubview(sweeperLiveLogo)
        self.addSubview(gameOptionsView)
        
    }
    
    override func layout() {
        sweeperLiveLogo.frame = CGRect(x: LIVE_LOGO_PADDING, y: 25, width: bounds.width - 2*LIVE_LOGO_PADDING, height: 100)
        gameOptionsView.frame = CGRect(x: 0, y: 140, width: bounds.width, height: gameOptionsView.SUGGESTED_HEIGHT)
        lobbyView.frame = CGRect(x: 0, y: 230, width: bounds.width, height: lobbyView.SUGGESTED_HEIGHT)
        readyButton.frame = CGRect(x: (bounds.width - readyButton.SUGGESTED_WIDTH) / 2, y: 350, width: readyButton.SUGGESTED_WIDTH, height: readyButton.SUGGESTED_HEIGHT)
        gameInstructionsView.frame = CGRect(x: 0, y: bounds.height - 130, width: bounds.width, height: bounds.height)
    }
    
    // Controller Interaction
    func startGame(UGID : String) {
        
    }
    
}

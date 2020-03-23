//
//  LiveGameView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LiveGameView : View {
    
    let FFAGameView = LiveFFAGameView()
    var allGameViews : [View] = []
    
    let connectionStatusBar = ConnectionStatusBarView()
    
    let endButtonBackground = UIVisualEffectView()
    let endButton = UIButton()
    let bottomBar = UIVisualEffectView()
    
    let END_BUTTON_SIZE = CGSize(width: 80, height: 40)
    let END_BUTTON_PADDING : CGFloat = 10
    let BOTTOM_BAR_HEIGHT : CGFloat = 60
    
    override func initialize() {
        allGameViews = [FFAGameView]
        
        for view in allGameViews {
            self.addSubview(view)
        }
        
        backgroundColor = .black
        bottomBar.effect = UIBlurEffect(style: .light)
        
        endButtonBackground.effect = UIBlurEffect(style: .dark)
        endButtonBackground.layer.cornerRadius = 20
        endButtonBackground.clipsToBounds = true
        
        endButton.setTitle("End", for: .normal)
        endButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        endButton.titleLabel?.textAlignment = .center
        endButton.setTitleColor(.white, for: .normal)
        endButton.addTarget(self, action: #selector(endClicked), for: .touchUpInside)
        
        self.addSubview(bottomBar)
        self.addSubview(connectionStatusBar)
        self.addSubview(endButtonBackground)
        self.addSubview(endButton)
        
        
    }
    
    override func layout() {
        for view in allGameViews {
            view.frame = self.bounds
        }
        endButtonBackground.frame = CGRect(x: self.bounds.width - END_BUTTON_SIZE.width - END_BUTTON_PADDING, y: self.bounds.height - END_BUTTON_SIZE.height - END_BUTTON_PADDING, width: END_BUTTON_SIZE.width, height: END_BUTTON_SIZE.height)
        endButton.frame = endButtonBackground.frame
        connectionStatusBar.frame = CGRect(x: 0, y: self.bounds.height - 10 - connectionStatusBar.SUGGESTED_HEIGHT, width: self.bounds.width - 90, height: connectionStatusBar.SUGGESTED_HEIGHT)
        bottomBar.frame = CGRect(x: 0, y: bounds.height - BOTTOM_BAR_HEIGHT, width: bounds.width, height: BOTTOM_BAR_HEIGHT + 100)
    }
    
    // Internal Methods
    func startGame(UGID : String, game : LiveGameMode) {
        for view in allGameViews {
            view.isHidden = true
        }
        switch game {
        case .FFA:
            FFAGameView.isHidden = false
            FFAGameView.startGame(UGID: UGID)
        }
    }
    
    @objc func endClicked() {
        self.isHidden = true
    }
    
    
    // Controller Interactions
    func startGame(UGID : String, gamemode : Gamemode) {
        switch gamemode {
        case .FFA:
            startGame(UGID : UGID, game: .FFA)
        default:
            print("Gamemode not recognized by LiveGameView", gamemode)
        }
    }
    
}

enum LiveGameMode {
    case FFA
}

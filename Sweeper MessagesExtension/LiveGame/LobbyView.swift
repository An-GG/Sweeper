//
//  LobbyView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/22/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LobbyView : View {
    
    let mainBackground = UIView()
    let titleLabel = UILabel()
    let scrollView = UIScrollView()
    
    let gLayer1 = CAGradientLayer()
    let gLayer2 = CAGradientLayer()
    
    let SUGGESTED_HEIGHT : CGFloat = 110
    let BACKGROUND_PADDING : CGFloat = 10
    
    let PLAYERVIEW_WIDTH : CGFloat = 80
    let PLAYERVIEW_PADDING : CGFloat = 0
    let PLAYERVIEW_LEFT_OFFSET : CGFloat = 10
    let PLAYERVIEW_TOP_PADDING : CGFloat = 30
    
    let GRADIENT_WIDTH : CGFloat = 30
    
    var playerViews  : [LobbyPlayerView] = []
    
    override func initialize() {
        mainBackground.backgroundColor = .white
        mainBackground.layer.cornerRadius = 10
        mainBackground.clipsToBounds = true
        
        titleLabel.font = UIFont.init(name: "DINCondensed-Bold", size: 20)
        titleLabel.textColor = .lightGray
        titleLabel.text = "LOBBY"
        titleLabel.textAlignment = .center
        
        scrollView.showsHorizontalScrollIndicator = false
        
        mainBackground.addSubview(scrollView)
        mainBackground.addSubview(titleLabel)
        addGradientToBackground()
        addSubview(mainBackground)
    }
    
    override func layout() {
        mainBackground.frame = CGRect(x: BACKGROUND_PADDING, y: 0, width: bounds.width - (2*BACKGROUND_PADDING), height: bounds.height)
        scrollView.frame = mainBackground.bounds
        titleLabel.frame = CGRect(x: 10, y: 6, width: mainBackground.bounds.width - 20, height: 30)
        gLayer1.frame = CGRect(x: 0, y: 0, width: GRADIENT_WIDTH, height: SUGGESTED_HEIGHT*2)
        gLayer2.frame = CGRect(x: mainBackground.bounds.width - GRADIENT_WIDTH - 30, y: 0, width: GRADIENT_WIDTH + 30, height: SUGGESTED_HEIGHT*2)
    }
    
    // Internal Methods
    func addGradientToBackground() {
        gLayer1.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gLayer1.startPoint = CGPoint(x: 0.2, y: 0)
        gLayer1.endPoint = CGPoint(x: 1, y: 0)
        mainBackground.layer.addSublayer(gLayer1)
        
        gLayer2.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gLayer2.startPoint = CGPoint(x: 0, y: 0)
        gLayer2.endPoint = CGPoint(x: 0.6, y: 0)
        mainBackground.layer.addSublayer(gLayer2)
    }
    
    // Controller Interaction
    func set(players: [LobbyPlayer]) {
        clearPlayers()
        
        var totalWidth : CGFloat = PLAYERVIEW_LEFT_OFFSET * 2 + 20
        var n : CGFloat = 0
        for player in players {
            let playerView = LobbyPlayerView()
            playerView.player = player
            playerView.frame = CGRect(x: PLAYERVIEW_LEFT_OFFSET + (n * (PLAYERVIEW_WIDTH + PLAYERVIEW_PADDING)), y: PLAYERVIEW_TOP_PADDING, width: PLAYERVIEW_WIDTH, height: scrollView.bounds.height - PLAYERVIEW_TOP_PADDING)
            
            totalWidth += PLAYERVIEW_WIDTH + PLAYERVIEW_PADDING
            n += 1
            scrollView.contentSize = CGSize(width: totalWidth, height: scrollView.bounds.height)
            scrollView.addSubview(playerView)
            
            playerViews.append(playerView)
        }
    }
    
    func clearPlayers() {
        for player in playerViews {
            player.removeFromSuperview()
        }
        playerViews = []
    }
    
}



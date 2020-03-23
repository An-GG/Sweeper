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
    
    let SUGGESTED_HEIGHT : CGFloat = 100
    let BACKGROUND_PADDING : CGFloat = 10
    
    override func initialize() {
        mainBackground.backgroundColor = .white
        mainBackground.layer.cornerRadius = 10
        
        titleLabel.font = UIFont.init(name: "DINCondensed-Bold", size: 20)
        titleLabel.textColor = .lightGray
        titleLabel.text = "LOBBY"
        titleLabel.textAlignment = .center
        
        mainBackground.addSubview(scrollView)
        mainBackground.addSubview(titleLabel)
        addSubview(mainBackground)
    }
    
    override func layout() {
        mainBackground.frame = CGRect(x: BACKGROUND_PADDING, y: 0, width: bounds.width - (2*BACKGROUND_PADDING), height: bounds.height)
        scrollView.frame = mainBackground.bounds
        titleLabel.frame = CGRect(x: 10, y: 6, width: mainBackground.bounds.width - 20, height: 30)
    }
    
    // Controller Interaction
    func set(players: [LobbyPlayer]) {
        
    }
    
}



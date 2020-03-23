//
//  GameInstructionsView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/22/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class GameInstructionsView : View {
    
    let mainBackground = UIView()
    let titleLabel = UILabel()
    let pullUpArrow = UIImageView()
    
    let BACKGROUND_PADDING : CGFloat = 20
    
    override func initialize() {
        mainBackground.backgroundColor = get(color: .purple)
        mainBackground.layer.cornerRadius = 10
        
        titleLabel.font = UIFont.init(name: "DINCondensed-Bold", size: 22)
        titleLabel.textColor = .white
        titleLabel.alpha = 0.7
        titleLabel.text = "HOW TO PLAY"
        titleLabel.textAlignment = .center
        
        pullUpArrow.image = UIImage(named: "PullUpArrow")
        pullUpArrow.contentMode = .scaleAspectFit
        
        mainBackground.addSubview(titleLabel)
        mainBackground.addSubview(pullUpArrow)
        addSubview(mainBackground)
        
    }
    
    override func layout() {
        mainBackground.frame = CGRect(x: BACKGROUND_PADDING, y: 0, width: bounds.width - (2*BACKGROUND_PADDING), height: bounds.height)
        titleLabel.frame = CGRect(x: 10, y: 35, width: mainBackground.bounds.width - 20, height: 30)
        pullUpArrow.frame = CGRect(x: 0, y: 5, width: mainBackground.bounds.width, height: 30)
    }
    
}


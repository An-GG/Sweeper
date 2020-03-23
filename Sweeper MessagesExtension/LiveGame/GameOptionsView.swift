//
//  GameOptionsView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/22/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class GameOptionsView : View {
    
    let mainBackground = UIView()
    let titleLabel = UILabel()
    
    let SUGGESTED_HEIGHT : CGFloat = 80
    let BACKGROUND_PADDING : CGFloat = 10
    
    override func initialize() {
        mainBackground.backgroundColor = .white
        mainBackground.layer.cornerRadius = 10
        
        titleLabel.font = UIFont.init(name: "DINCondensed-Bold", size: 20)
        titleLabel.textColor = .lightGray
        titleLabel.text = "GAME OPTIONS"
        titleLabel.textAlignment = .center
        
        mainBackground.addSubview(titleLabel)
        addSubview(mainBackground)
    }
    
    override func layout() {
        mainBackground.frame = CGRect(x: BACKGROUND_PADDING, y: 0, width: bounds.width - (2*BACKGROUND_PADDING), height: bounds.height)
        titleLabel.frame = CGRect(x: 10, y: 6, width: mainBackground.bounds.width - 20, height: 30)
    }
    
}


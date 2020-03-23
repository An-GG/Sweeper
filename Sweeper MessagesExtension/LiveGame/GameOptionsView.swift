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
    let OPTIONS_WIDTH : CGFloat = 80
    let OPTION_TOP_PADDING : CGFloat = 30
    
    var currentOptions : [GameOptionView] = []
    
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
        var n : CGFloat = 1
        let distance = mainBackground.bounds.width / CGFloat(1 + currentOptions.count)
        for op in currentOptions {
            op.frame = CGRect(x: (distance * n) - (OPTIONS_WIDTH / 2), y: OPTION_TOP_PADDING, width: OPTIONS_WIDTH, height: mainBackground.bounds.height - OPTION_TOP_PADDING)
            n += 1
        }
    }
    
    // Controller Interaction
    func set(options : [GameOptionView]) {
        
        for op in options {
            mainBackground.addSubview(op)
        }
        currentOptions = options
    }
    
    func clearOptions() {
        for op in currentOptions {
            op.removeFromSuperview()
        }
        currentOptions = []
    }
    
}


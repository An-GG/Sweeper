//
//  ConnectionStatusBarView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class ConnectionStatusBarView : View {
    
    let backColoredView = UIView()
    
    var gameString = ""
    let SUGGESTED_HEIGHT : CGFloat = 40
    
    let BACK_COLOR_VIEW_PADDING : CGFloat = 10
    
    override func initialize() {
        backColoredView.backgroundColor = get(color: .gGreen)
        backColoredView.layer.cornerRadius = 20
        
        self.addSubview(backColoredView)
    }
    
    override func layout() {
        backColoredView.frame = CGRect(x: BACK_COLOR_VIEW_PADDING, y: 0, width: bounds.width - 2 * BACK_COLOR_VIEW_PADDING, height: bounds.height)
    }
    
    // Controller Interaction
    func set() {
        
    }
}

enum ConnectionStatus {
    case connecting
    case connected
    case failed
}


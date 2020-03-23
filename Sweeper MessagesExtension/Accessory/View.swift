//
//  View.swift
//  EchelonApp
//
//  Created by Ankush Girotra on 7/8/19.
//  Copyright © 2019 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class View: UIView {
    
    var IS_ANIMATING = false
    
    override var frame: CGRect {
        didSet {
            if !IS_ANIMATING {
                layout()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
        self.layout()
    }
    func initialize() {
        
    }
    func layout() {
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

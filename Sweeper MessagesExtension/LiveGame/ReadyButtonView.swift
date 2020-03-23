//
//  ReadyButtonView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/22/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class ReadyButtonView : View {
    
    var delegate : LiveGameDelegate?
    
    let background = UIView()
    let background2 = UIView()
    let button = UIButton()
    let title = UILabel()
    
    let bg2Padding : CGFloat = 7
    let bg2Radius : CGFloat = 20
    
    var SUGGESTED_HEIGHT : CGFloat = 1 // Is 2x bg2Radius+padding
    var SUGGESTED_WIDTH : CGFloat = 180
    
    var isReady = false
    
    override func initialize() {
        let bgRadius = bg2Radius + bg2Padding
        SUGGESTED_HEIGHT = 2 * bgRadius
        
        background.backgroundColor = .white
        background2.backgroundColor = get(color: .gGreen)
        
        background.layer.cornerRadius = bgRadius
        background2.layer.cornerRadius = bg2Radius
        
        title.text = "I'M READY!"
        title.textColor = .white
        title.font = UIFont.init(name: "DINCondensed-Bold", size: 20)
        title.textAlignment = .center
        
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
        addSubview(background)
        addSubview(background2)
        addSubview(title)
        addSubview(button)
    }
    
    override func layout() {
        title.frame = CGRect(x: 0, y: 5, width: bounds.width, height: bounds.height - 5)
        button.frame = bounds
        background.frame = bounds
        background2.frame = CGRect(x: bg2Padding, y: bg2Padding, width: bounds.width - (2*bg2Padding), height: bounds.height - (2*bg2Padding))
    }
    
    @objc func clicked() {
        isReady = !isReady
        UIView.animate(withDuration: 0.2) {
            if self.isReady {
                self.background.backgroundColor = get(color: .gGreen)
            } else {
                self.background.backgroundColor = .white
            }
        }
        
        if isReady {
            self.title.text = "NOT READY"
            delegate?.becameReady?()
        } else {
            self.title.text = "I'M READY!"
            delegate?.becameUnready?()
        }
    }
    
}


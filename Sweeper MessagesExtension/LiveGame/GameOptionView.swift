//
//  GameOptionView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/23/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class GameOptionView : View {
    
    let optionNameLabel = UILabel()
    let image = UIImageView()
    let bigLabel = UILabel()
    
    let NAME_LABEL_HEIGHT : CGFloat = 20
    
    override func initialize() {
        optionNameLabel.font = UIFont(name: "DINCondensed-Bold", size: 10)
        optionNameLabel.textColor = .black
        optionNameLabel.textAlignment = .center
        
        bigLabel.font = UIFont(name: "DINCondensed-Bold", size: 25)
        bigLabel.textColor = .black
        bigLabel.textAlignment = .center
        
        image.contentMode = .scaleAspectFit
        
        addSubview(optionNameLabel)
        addSubview(bigLabel)
        addSubview(image)
    }
    
    override func layout() {
        optionNameLabel.frame = CGRect(x: 0, y: bounds.height - NAME_LABEL_HEIGHT, width: bounds.width, height: NAME_LABEL_HEIGHT)
        bigLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - NAME_LABEL_HEIGHT)
        image.frame = bigLabel.frame
    }
    
    convenience init(name : String, bigLabelText : String, image : UIImage?) {
        self.init()
        optionNameLabel.text = name
        bigLabel.text = bigLabelText
        self.image.image = image
    }
    
}

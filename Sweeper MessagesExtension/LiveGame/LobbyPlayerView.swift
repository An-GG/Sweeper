//
//  LobbyPlayerView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/23/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LobbyPlayerView : View {
    
    let outline = UIView()
    let innerCircle = UIView()
    let shortDisplayLabel = UILabel()
    let imageView = UIImageView()
    let fullDisplayLabel = UILabel()
    
    let CIRCLE_DIAMETER : CGFloat = 55
    let OUTLINE_WIDTH : CGFloat = 4
    
    var player : LobbyPlayer? {
        didSet {
            updatePlayer()
        }
    }
    
    override func initialize() {
        outline.backgroundColor = .white
        outline.layer.cornerRadius = CIRCLE_DIAMETER / 2
        outline.dropShadow(color: .black, opacity: 0.25, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        
        innerCircle.backgroundColor = .lightGray
        innerCircle.layer.cornerRadius = (CIRCLE_DIAMETER / 2) - OUTLINE_WIDTH
        
        shortDisplayLabel.textColor = .white
        shortDisplayLabel.textAlignment = .center
        shortDisplayLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        fullDisplayLabel.textColor = .gray
        fullDisplayLabel.textAlignment = .center
        fullDisplayLabel.font = .systemFont(ofSize: 10, weight: .medium)
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = innerCircle.layer.cornerRadius
        imageView.clipsToBounds = true
        
        outline.addSubview(innerCircle)
        outline.addSubview(shortDisplayLabel)
        outline.addSubview(imageView)
        addSubview(fullDisplayLabel)
        addSubview(outline)
    }
    
    override func layout() {
        outline.frame = CGRect(x: (bounds.width - CIRCLE_DIAMETER) / 2, y: 4, width: CIRCLE_DIAMETER, height: CIRCLE_DIAMETER)
        innerCircle.frame = CGRect(x: OUTLINE_WIDTH, y: OUTLINE_WIDTH, width: CIRCLE_DIAMETER - (2*OUTLINE_WIDTH), height: CIRCLE_DIAMETER - (2*OUTLINE_WIDTH))
        shortDisplayLabel.frame = outline.bounds
        fullDisplayLabel.frame = CGRect(x: 0, y: outline.frame.maxY, width: bounds.width, height: bounds.height - outline.frame.maxY)
        imageView.frame = innerCircle.frame
    }
    
    // Internal Methods
    
    private func updatePlayer() {
        shortDisplayLabel.text = player?.displayLetters
        fullDisplayLabel.text = player?.name
        if let img = UIImage(named: player!.name) {
            imageView.image = img
        }
        if player?.ready == "YES" {
            outline.backgroundColor = get(color: .gGreen)
        }
    }
    
}


class LobbyPlayer {
    var name : String
    var imageName : String
    var displayLetters : String
    var color : String
    var id : String
    var ready : String
    var chance : String?
    var key : String?
    
    required init(name: String, imageName: String, displayLetters: String, color: String, id : String, ready : String) {
        self.name = name
        self.imageName = imageName
        self.displayLetters = displayLetters
        self.color = color
        self.id = id
        self.ready = ready
    }
    
    func getDictionary() -> [String:String] {
        return [
            "NAME" : name,
            "IMAGENAME" : imageName,
            "DISPLAYLETTERS" : displayLetters,
            "COLOR" : color,
            "ID" : id,
            "READY" : ready
        ]
    }
}

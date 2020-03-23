//
//  MineCell.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 12/16/19.
//  Copyright © 2019 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class MineCell : View {
    
    let image  = UIImageView()
    let numLabel = UILabel()
    let cover = UIButton()
    
    var controller : Minefield?
    var loc : (x: Int, y: Int)?
    var isMine = false
    
    var padding : CGFloat = 2.5
    
    override func initialize() {
        self.backgroundColor = .clear
        image.image = UIImage(named: "NewMineCellBack")
        numLabel.font = .systemFont(ofSize: 10, weight: .bold)
        numLabel.textColor = .red
        numLabel.textAlignment = .center
        
        cover.setBackgroundImage(UIImage(named: "NewMineCellCover"), for: .normal)
        cover.addTarget(self, action: #selector(cellClicked), for: .touchUpInside)
        cover.showsTouchWhenHighlighted = false
        cover.addTarget(self, action: #selector(cellTouchDown), for: .touchDown)
        
        self.addSubview(image)
        self.addSubview(numLabel)
        self.addSubview(cover)
    }
    
    override func layout() {
        self.image.frame = CGRect(x: padding, y: padding, width: self.bounds.width - 2*(padding), height: self.bounds.height - 2*(padding))
        self.numLabel.frame = self.image.frame
        self.cover.frame = self.image.frame
    }
    
    func openCell() {
        cover.isHidden = true
    }
    func closeCell() {
        cover.isHidden = false
    }
    func flagCell() {
        
    }
    
    var holdWaiting = false
    
    func externalUserCellClick() {
        controller!.cellClicked(x: loc!.x, y: loc!.y)
    }
    
    @objc func cellClicked() {
        if holdWaiting {
            controller!.cellClicked(x: loc!.x, y: loc!.y)
            controller!.liveMinefieldController?.cellClicked(x: loc!.x, y: loc!.y)
            holdWaiting = false
        }
    }
    @objc func cellTouchDown() {
        var feedback = UIImpactFeedbackGenerator()
        feedback.prepare()
        holdWaiting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.holdWaiting {
                self.cover.setImage(UIImage(named: "NewMineCellFlag"), for: .normal)
                self.holdWaiting = false
                feedback.impactOccurred()
            }
        }
    }
    
    
    func setFromModel(model :  CellModel) {
        self.isMine = model.isMine
        if model.isMine {
            image.image = UIImage(named: "NewMineCellExplosion")
        } else {
            numLabel.text = String(model.surroundingMines)
            if numLabel.text == "0" {
                numLabel.text = ""
            }
        }
    }
    
    func setStyle(style : cellStyle) {
        
    }
    
    func getImage(style : cellStyle) {
        var view = UIView()
        if style == .new {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Cell")
            
        }
    }
    
}

enum cellStyle {
    case basic
    case new
    case retro
}

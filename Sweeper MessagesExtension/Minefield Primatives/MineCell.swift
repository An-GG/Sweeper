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

    let tintingView = UIImageView()
    let tintingColorView = UIView()
    var currentTintColor : UIColor?
    
    var controller : Minefield?
    var loc : (x: Int, y: Int)?
    var isMine = false
    
    var padding : CGFloat = 2.5
    var allTintableImageViews : [UIImageView] = []
    
    var settingAnimates = false
    
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
        
        tintingColorView.clipsToBounds = true
        
        self.addSubview(image)
        self.addSubview(numLabel)
        self.addSubview(tintingView)
        self.addSubview(tintingColorView)
        self.addSubview(cover)
    }
    
    override func layout() {
        self.image.frame = CGRect(x: padding, y: padding, width: self.bounds.width - 2*(padding), height: self.bounds.height - 2*(padding))
        self.numLabel.frame = self.image.frame
        self.cover.frame = self.image.frame
        self.tintingView.frame = self.image.frame
        
        let tintingColorLeftOffsetRatio : CGFloat = 3/25
        let cornerRadiusRatio : CGFloat = 1.3/10
        self.tintingColorView.frame = CGRect(x: tintingColorLeftOffsetRatio * self.image.frame.width + self.image.frame.minX, y: tintingColorLeftOffsetRatio * self.image.frame.height + self.image.frame.minY, width: self.image.frame.width * (1 - (2*tintingColorLeftOffsetRatio)), height: self.image.frame.height * (1 - (2*tintingColorLeftOffsetRatio)))
        self.tintingColorView.layer.cornerRadius = self.tintingColorView.frame.width * cornerRadiusRatio
    }
    
    func openCell() {
        cover.isHidden = true
    }
    func closeCell() {
        cover.isHidden = false
    }
    func flagCell() {
        self.cover.setImage(UIImage(named: "NewMineCellFlag"), for: .normal)
    }
    func resetCell() {
        cover.setBackgroundImage(UIImage(named: "NewMineCellCover"), for: .normal)
        closeCell()
        tintingView.image = nil
        tintingColorView.backgroundColor = .clear
        currentTintColor = nil
    }
    
    var holdWaiting = false
    
    func externalUserCellClick() {
        controller!.cellClicked(x: loc!.x, y: loc!.y)
    }
    func localUserCellClick() {
        controller!.newCellsTint = controller!.localCellsTint
        controller!.cellClicked(x: loc!.x, y: loc!.y)
    }
    
    @objc func cellClicked() {
        if holdWaiting {
            localUserCellClick()
            controller!.liveMinefieldController?.cellClicked(x: loc!.x, y: loc!.y)
            holdWaiting = false
        }
    }
    @objc func cellTouchDown() {
        let feedback = UIImpactFeedbackGenerator()
        feedback.prepare()
        holdWaiting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if self.holdWaiting {
                self.flagCell()
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
    
    func set(color : UIColor? = nil, open : Bool? = nil) {
        resetCell()
        if let isOpen = open {
            if settingAnimates {
                if isOpen {
                    openCell()
                }
            } else {
                if isOpen {
                    openCell()
                }
            }
        }
        if let c = color {
            currentTintColor = c
            tintingView.image = UIImage(named: "NewMineCellCover")
            tintingColorView.backgroundColor = c
            if settingAnimates {
                tintingColorView.alpha = 0.3
                tintingColorView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: 0.2) {
                    self.tintingColorView.alpha = 1
                    self.tintingColorView.transform = .identity
                }
            }
        }
    }
    
    
    
}

enum cellStyle {
    case basic
    case new
    case retro
}

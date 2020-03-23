//
//  LiveMinefieldView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/23/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class LiveMinefieldView: View {
    
    var delegate : LiveMinefieldViewDelegate?
    
    let shadow = UIView()
    let background = UIView()
    let bgLining = UIView()
    let field = Minefield()
    
    let FIELD_SIDE_PADDING : CGFloat = 5
    let FIELD_TOP_PADDING : CGFloat = 5
    
    let BG_SIDE_PADDING : CGFloat = 20
    let BG_TOP_PADDING : CGFloat = 60
    let BG_BOTTOM_PADDING : CGFloat = 80
    let BG_RADIUS : CGFloat = 15
    let LINING_THICKNESS : CGFloat = 5
    
    override func initialize() {
        shadow.backgroundColor = .black
        
        bgLining.backgroundColor = .white
        bgLining.layer.cornerRadius = BG_RADIUS + LINING_THICKNESS
        
        background.backgroundColor = .black
        background.layer.cornerRadius = BG_RADIUS
        background.clipsToBounds = true
        
        field.liveMinefieldController = self
        field.renderGrid()
        field.clipsToBounds = false
        field.scroll.clipsToBounds = false
        
        background.addSubview(field)
        addSubview(shadow)
        addSubview(bgLining)
        addSubview(background)
    }
    
    override func layout() {
        shadow.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + 200)
        bgLining.frame = CGRect(x: BG_SIDE_PADDING - LINING_THICKNESS, y: BG_TOP_PADDING - LINING_THICKNESS, width: bounds.width - (2*(BG_SIDE_PADDING - LINING_THICKNESS)), height: bounds.height - BG_TOP_PADDING - BG_BOTTOM_PADDING + (2*LINING_THICKNESS))
        background.frame = CGRect(x: BG_SIDE_PADDING, y: BG_TOP_PADDING, width: bounds.width - (2*BG_SIDE_PADDING), height: bounds.height - BG_TOP_PADDING - BG_BOTTOM_PADDING)
        field.frame = CGRect(x: FIELD_SIDE_PADDING, y: FIELD_TOP_PADDING, width: background.bounds.width - (2*FIELD_SIDE_PADDING), height:  background.bounds.height - FIELD_TOP_PADDING)
    }
    
    // Delegate Interaction
    func cellClicked(x: Int, y: Int) {
        delegate?.cellUpdate(x: x, y: y, status: .opened)
    }
    
    // Controller Interaction
    func setCell(x: Int, y: Int, status: CellUpdateType) {
        let cell = field.field.getMine(xPos: x, yPos: y)?.cellView
        switch status {
        case .opened:
            cell?.externalUserCellClick()
        }
    }
    
}

protocol LiveMinefieldViewDelegate {
    func cellUpdate(x: Int, y: Int, status: CellUpdateType)
}

enum CellUpdateType : String {
    case opened = "OPENED"
}

//
//  Minefield.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 12/16/19.
//  Copyright © 2019 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit


class Minefield : View, UIScrollViewDelegate {
    
    var currentCells : [MineCell] = []
    
    var lastX = 12
    var lastY = 10
    var X_COUNT = 12 {
        didSet {
            updateFieldFrames()
        }
    }
    var Y_COUNT = 10 {
        didSet {
            updateFieldFrames()
        }
    }
    
    var CELL_DIM : CGFloat = 30
    var field = FieldModel()
    
    let scroll = UIScrollView()
    let zoomableView = UIView()
    
    var liveMinefieldController : LiveMinefieldView?
    var controller : GameControllerDelegate?
    
    var status : gameStatusType = .inProgress
    
    var localCellsTint : UIColor? = nil
    var newCellsTint : UIColor? = nil
    
    override func initialize() {
        scroll.backgroundColor = .clear
        scroll.delegate = self
        scroll.maximumZoomScale = 5
        scroll.minimumZoomScale = 0.7
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.bounces = false
        self.addSubview(scroll)
        scroll.addSubview(zoomableView)
        field.generateGrid(X: X_COUNT, Y: Y_COUNT, nMines: 8)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        zoomableView
    }
    
    func clearField() {
        for cell in currentCells {
            cell.removeFromSuperview()
        }
        currentCells = []
    }
    
    func renderGrid() {
        clearField()
        
        for Y in 0..<Y_COUNT {
            for X in 0..<X_COUNT {
                let cell = MineCell()
                cell.controller = self
                cell.loc = (x: X, y: Y)
                cell.frame = CGRect(x: CGFloat(X) * CELL_DIM, y: CGFloat(Y) * CELL_DIM, width: CELL_DIM, height: CELL_DIM)
                cell.setFromModel(model: field.grid[X][Y])
                field.grid[X][Y].cellView = cell
                currentCells.append(cell)
                zoomableView.addSubview(cell)
            }
        }
    }
    
    func resetGrid() {
        for c in currentCells {
            c.resetCell()
        }
    }
    
    func setCellsToAnimate() {
        for cell in currentCells {
            cell.settingAnimates = true
        }
    }
    
    
    
    // Controller Targets
    func cellClicked(x: Int, y: Int) {
        controller?.mineClicked()
        let mine = field.getMine(xPos: x, yPos: y)!
        if mine.isMine {
            mine.shouldBeOpen = true//mine.cellView!.openCell()
            controller?.gameComplete()
            status = .mineClicked
        } else {
            // Color Assignment Tint
            if let c = newCellsTint {
                mine.shouldSetColor = c//mine.cellView!.set(color: c)
            }
            
            mine.shouldBeOpen = true//mine.cellView!.openCell()
            if mine.surroundingMines == 0 {
                // Click on surrounding cells
                let pass = [-1, 0, 1]
                for xO in pass {
                    for yO in pass {
                        if let newMine = field.getMine(xPos: x + xO, yPos: y + yO) {
                            if !newMine.shouldBeOpen {//if !newMine.cellView!.cover.isHidden { // Checks if mine has already been opened
                                cellClicked(x: x + xO, y: y + yO)
                            }
                        }
                    }
                }
            }
        }
        updateVisuals()
        checkIfGameOver()
    }
    
    func updateVisuals() {
        for Y in 0..<Y_COUNT {
            for X in 0..<X_COUNT {
                let cell = field.getMine(xPos: X, yPos: Y)
                cell?.updateVisualsIfNeeded()
            }
        }
    }
    
    func checkIfGameOver() {
        var allNonMineCellsOpened = true
        for x in field.grid {
            for cell in x {
                if !cell.isMine && !cell.cellView!.cover.isHidden {
                    allNonMineCellsOpened = false
                }
            }
        }
        if allNonMineCellsOpened {
            status = .fieldCleared
            controller?.gameComplete()
        }
    }
    
    func updateFieldFrames() {
        if (lastX != X_COUNT) || (lastY != Y_COUNT) {
            lastX = X_COUNT
            lastY = Y_COUNT
            scroll.contentSize = CGSize(width: CGFloat(X_COUNT) * CELL_DIM, height: CGFloat(Y_COUNT) * CELL_DIM)
            zoomableView.frame = CGRect(origin: .zero, size: scroll.contentSize)
        }
    }
    
    override func layout() {
        scroll.frame = self.bounds
    }
    
}

enum gameStatusType {
    case inProgress
    case fieldCleared
    case mineClicked
}

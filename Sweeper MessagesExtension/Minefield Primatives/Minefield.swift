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
    var X_COUNT = 12
    var Y_COUNT = 10
    
    var CELL_DIM : CGFloat = 30
    var field = FieldModel()
    
    let scroll = UIScrollView()
    let zoomableView = UIView()
    
    var liveMinefieldController : LiveMinefieldView?
    var controller : GameControllerDelegate?
    
    var status : gameStatusType = .inProgress
    
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
    }
    
    func renderGrid() {
        clearField()
        scroll.contentSize = CGSize(width: CGFloat(X_COUNT) * CELL_DIM, height: CGFloat(Y_COUNT) * CELL_DIM + 60)
        zoomableView.frame = CGRect(origin: .zero, size: scroll.contentSize)
        for Y in 0..<Y_COUNT {
            for X in 0..<X_COUNT {
                let cell = MineCell()
                cell.controller = self
                cell.loc = (x: X, y: Y)
                cell.frame = CGRect(x: CGFloat(X) * CELL_DIM, y: CGFloat(Y) * CELL_DIM, width: CELL_DIM, height: CELL_DIM)
                cell.setFromModel(model: field.grid[X][Y])
                field.grid[X][Y].cellView = cell
                zoomableView.addSubview(cell)
            }
        }
    }
    
    
    
    // Controller Targets
    func cellClicked(x: Int, y: Int) {
        controller?.mineClicked()
        let mine = field.getMine(xPos: x, yPos: y)!
        if mine.isMine {
            mine.cellView!.openCell()
            controller?.gameComplete()
            status = .mineClicked
        } else {
            mine.cellView!.openCell()
            if mine.surroundingMines == 0 {
                // Click on surrounding cells
                let pass = [-1, 0, 1]
                for xO in pass {
                    for yO in pass {
                        if let newMine = field.getMine(xPos: x + xO, yPos: y + yO) {
                            if !newMine.cellView!.cover.isHidden { // Checks if mine has already been opened
                                cellClicked(x: x + xO, y: y + yO)
                            }
                        }
                    }
                }
            }
        }
        checkIfGameOver()
        
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
    
    
    override func layout() {
        scroll.frame = self.bounds
    }
    
}

enum gameStatusType {
    case inProgress
    case fieldCleared
    case mineClicked
}

//
//  FieldModel.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/2/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation

class FieldModel {
    
    var grid : [[CellModel]] = []
    var setX : Int = 16
    var setY : Int = 30
    
    func getMine(xPos: Int, yPos: Int) -> CellModel? {
        if xPos < 0 || xPos > grid.count - 1 {
            return nil
        }
        if yPos < 0 || yPos > grid[0].count - 1 {
            return nil
        }
        return grid[xPos][yPos]
    }
    
    func checkMine(xPos: Int, yPos: Int) -> Bool {
        if let mine = getMine(xPos: xPos, yPos: yPos) {
            return mine.isMine
        }
        return false
    }
    
    func generateGrid(X: Int, Y: Int, nMines: Int) {
        setX = X
        setY = Y
        grid = []
        for _ in 0..<X {
            // Create Column
            var column : [CellModel] = []
            for _ in 0..<Y {
                column.append(CellModel())
            }
        grid.append(column)
        }
        // Now Have Empy Grid
        // Generate List Of Randomly Placed Mines
        var mines : [(x: Int, y:Int)] = []
        for _ in 0..<nMines {
            var minePos = (x: Int.random(in: 0..<X), y: Int.random(in: 0..<Y))
            while (mines.contains { elm in
                if elm.x == minePos.x && elm.y == minePos.y {
                    return true
                }
                return false
            }) {
                minePos = (x: Int.random(in: 0..<X), y: Int.random(in: 0..<Y))
            }
            mines.append(minePos)
            grid[minePos.x][minePos.y].isMine = true
        }
        // Count Surrounding
        
        for x in 0..<X {
            for y in 0..<Y {
                let checks = [checkMine(xPos: x-1, yPos: y-1), checkMine(xPos: x, yPos: y-1), checkMine(xPos: x+1, yPos: y-1), checkMine(xPos: x-1, yPos: y), checkMine(xPos: x+1, yPos: y), checkMine(xPos: x-1, yPos: y+1), checkMine(xPos: x, yPos: y+1), checkMine(xPos: x+1, yPos: y+1)]
                grid[x][y].surroundingMines = 0
                for b in checks where b {
                    grid[x][y].surroundingMines += 1
                }
            }
        }
        
    }
    
}

class CellModel {
    
    var isMine = false
    var surroundingMines = 0
    var cellView : MineCell?
    
    func setValue(isMine: Bool, surroundingMines: Int) {
        self.isMine = isMine
        self.surroundingMines = surroundingMines
    }
    
}

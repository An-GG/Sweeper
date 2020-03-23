//
//  TimedGameController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/10/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

var GlobalTimedGameController : TimedGameController?

class TimedGameController : UIViewController, GameControllerDelegate {
    
    var model = FieldModel()
    var field = Minefield()
    
    
    @IBOutlet weak var popupContainer: UIView!
    @IBOutlet weak var output: UIView!
    @IBOutlet weak var topBar: UIVisualEffectView!
    @IBOutlet weak var endButtonContainer: UIVisualEffectView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var date = Date()
    var timerRunning = false
    
    override func viewDidLoad() {
        
        GlobalTimedGameController = self
        
        endButtonContainer.layer.cornerRadius = 20
        endButtonContainer.clipsToBounds = true
        topBar.layer.cornerRadius = 20
        topBar.clipsToBounds = true
        
        output.backgroundColor = .clear
        output.addSubview(field)
        output.clipsToBounds = false
        
        
        
        model.generateGrid(X: GlobalFieldSetupController!.currentWidth, Y: GlobalFieldSetupController!.currentHeight, nMines: GlobalFieldSetupController!.currentMines)
        
        field.scroll.clipsToBounds = false
        field.controller = self
        setupFieldFromModel()
    }
    
    func setupFieldFromModel() {
        field.field = model
        field.X_COUNT = model.setX
        field.Y_COUNT = model.setY
        field.renderGrid()
    }
    
    func mineClicked() {
        if !timerRunning {
            timerRunning = true
            date = Date()
            timer = Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true, block: { (t) in
                let interval = Date().timeIntervalSince(self.date)
                self.timeLabel.text = interval.stringFromTimeInterval()
            })
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    func gameComplete() {
        // Stop Timer
        timerRunning = false
        timer.invalidate()
        
        // Create Game
        let game = Game(gamemode: .timed, fieldModel: field.field)
        
        // Deploy Popup
        let popup = GlobalSendPopupController
        popup?.gameController = self
        
        let interval = Date().timeIntervalSince(date)
        let mins = Double(Int(interval / 0.6)) / 100
        popup!.bottomDescriptor.text = String(mins) + " min"
        
        if field.status == .fieldCleared {
            game.instigatorFail = false
            popup!.topTitle.text = "Field Clear"
            popup!.middleDescriptor.text = ""
        } else {
            game.instigatorFail = true
            popup!.topTitle.text = "Darn!"
            popup!.middleDescriptor.text = ""
            
        }
        popupContainer.isHidden = false
        
        // Load Game Into Comms
        game.instigatorTime = mins
        game.isInstigator = true
        globalComms.loadedGame = game
    }
    
    func resetAllViews() {
        timeLabel.text = "00:00"
        popupContainer.isHidden = true
    }
    
    func presentGame() {
        globalController!.present(self, animated: true, completion: nil)
    }
    
    func dismissToMain() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func endGame(_ sender: Any) {
        timerRunning = false
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        field.frame = output.bounds
    }
    
}

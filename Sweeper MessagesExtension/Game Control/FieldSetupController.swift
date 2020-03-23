//
//  FieldSetupController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/10/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

var GlobalFieldSetupController : FieldSetupController?

class FieldSetupController : UIViewController {
    
    
    @IBOutlet weak var minesSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    
    @IBOutlet weak var minesLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    let DIM_LOWER = 5
    let DIM_UPPER = 30
    let MINE_MAX_PROP : Float = 0.25
    
    var currentWidth = 5
    var currentHeight = 5
    var currentMines = 0
    
    // Dim range: 5-50
    //
    
    override func viewDidLoad() {
        GlobalFieldSetupController = self
        
        settingsChanged(minesSlider!)
    }
    
    @IBAction func settingsChanged(_ sender: Any) {
        let range = DIM_UPPER - DIM_LOWER
        
        currentWidth = Int(widthSlider.value * Float(range))+DIM_LOWER
        currentHeight = Int(heightSlider.value * Float(range))+DIM_LOWER
        let nMines = Float(currentWidth * currentHeight) * MINE_MAX_PROP
        
        currentMines = Int(minesSlider.value * nMines)
        
        widthLabel.text = String(currentWidth)
        heightLabel.text = String(currentHeight)
        minesLabel.text = String(currentMines)
    }
    
}

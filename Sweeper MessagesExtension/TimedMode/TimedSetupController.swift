//
//  TimedSetupController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/10/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit


class TimedSetupController : UIViewController {
    
    @IBOutlet weak var startButtonContainer: UIView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        startButtonContainer.layer.cornerRadius = 20
    }
    
    @IBAction func startClicked(_ sender: Any) {
         
    }
}

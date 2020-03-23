//
//  SendPopupController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/13/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import UIKit

var GlobalSendPopupController : SendPopupController?

class SendPopupController: UIViewController {

    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var middleDescriptor: UILabel!
    @IBOutlet weak var bottomDescriptor: UILabel!
    
    
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    @IBOutlet weak var sendRingView: UIView!
    @IBOutlet weak var sendInnerCircleView: UIView!
    
    var gameController : GameControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GlobalSendPopupController = self

        backgroundView.layer.cornerRadius = 42
        backgroundView.clipsToBounds = true
        
        sendRingView.layer.cornerRadius = 30
        sendInnerCircleView.layer.cornerRadius = 25
        
    }

    @IBAction func sendButtonClick(_ sender: Any) {
        // Animate Out And Stuff
        globalComms.sendLoadedGame()
        globalController?.dismiss(animated: true, completion: nil)
    }
}

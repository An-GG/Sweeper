//
//  FFAGameSendController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import UIKit

class FFAGameSendController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func sendClicked(_ sender: Any) {
        // Make Game Object
        let game = Game(gamemode: .FFA)
        globalComms.send(game: game)
    }
    

}

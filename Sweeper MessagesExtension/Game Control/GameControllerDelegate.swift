//
//  GameControllerDelegate.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 2/12/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation

protocol GameControllerDelegate {
    func mineClicked()
    func gameComplete()
    func resetAllViews()
    func presentGame()
    func dismissToMain()
}

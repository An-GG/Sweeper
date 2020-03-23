//
//  LiveGameDelegate.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/23/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation

@objc protocol LiveGameDelegate {
    @objc optional func becameReady()
    @objc optional func becameUnready()
}

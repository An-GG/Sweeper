//
//  Constants.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

enum ColorHex : String {
    case gRed = "#DB4437FF"
    case gBlue = "#4285F4FF"
    case gGreen = "#0F9D58FF"
    case gYellow = "#F4B400FF"
    case purple = "#9C88FFFF"
    case orangeYellow = "#FAB805FF"
}

func get(color : ColorHex) -> UIColor {
    return UIColor(hex: color.rawValue.lowercased())!
}

let PlayerColors = ["#55efc4ff", "#81ececff", "#74b9ffff", "#a29bfeff", "#ffeaa7ff", "#fab1a0ff", "#ff7675ff", "#fd79a8ff"]

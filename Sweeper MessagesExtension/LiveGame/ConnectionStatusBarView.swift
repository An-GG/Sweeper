//
//  ConnectionStatusBarView.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 3/20/20.
//  Copyright © 2020 Ankush Girotra. All rights reserved.
//

import Foundation
import UIKit

class ConnectionStatusBarView : View {
    
    let backColoredView = UIView()
    let settingsButton = UIButton()
    let statusLabel = UILabel()
    let ugidLabel = UILabel()
    
    var gameString = ""
    let SUGGESTED_HEIGHT : CGFloat = 40
    let LEFT_LABEL_PADDING : CGFloat = 60
    let BACK_COLOR_VIEW_PADDING : CGFloat = 10
    let SETTINGS_BUTTON_PADDING : CGFloat = 5
    
    override func initialize() {
        backColoredView.backgroundColor = get(color: .orangeYellow)
        backColoredView.layer.cornerRadius = 20
        
        statusLabel.textColor = .white
        statusLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        statusLabel.textAlignment = .center
        statusLabel.text = "CONNECTING..."
        
        ugidLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        ugidLabel.font = .systemFont(ofSize: 9, weight: .semibold)
        ugidLabel.textAlignment = .center
        ugidLabel.text = "ewrgdhndgqrwwhtet42rwds"
        
        let tintedImage = UIImage(named: "GearIcon")?.withRenderingMode(.alwaysTemplate)
        
        settingsButton.backgroundColor = .white
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.imageView?.tintColor = UIColor.black.withAlphaComponent(0.7)
        settingsButton.setImage(tintedImage, for: .normal)
        settingsButton.layer.cornerRadius = backColoredView.layer.cornerRadius - SETTINGS_BUTTON_PADDING
        
        self.addSubview(backColoredView)
        self.addSubview(statusLabel)
        self.addSubview(ugidLabel)
        self.addSubview(settingsButton)
    }
    
    override func layout() {
        backColoredView.frame = CGRect(x: BACK_COLOR_VIEW_PADDING, y: 0, width: bounds.width - 2 * BACK_COLOR_VIEW_PADDING, height: bounds.height)
        statusLabel.frame = CGRect(x: LEFT_LABEL_PADDING, y: 0, width: bounds.width - LEFT_LABEL_PADDING, height: bounds.height / 1.5)
        ugidLabel.frame = CGRect(x: LEFT_LABEL_PADDING, y: bounds.height / 3, width: bounds.width - LEFT_LABEL_PADDING, height: bounds.height * (2/3))
        settingsButton.frame = CGRect(x: SETTINGS_BUTTON_PADDING + BACK_COLOR_VIEW_PADDING, y: SETTINGS_BUTTON_PADDING, width: 50, height: bounds.height - (2*SETTINGS_BUTTON_PADDING))
    }
    
    var pulseTimer : Timer?
    func pulsate() {
        if pulseTimer?.isValid != true {
            pulseTimer = Timer.scheduledTimer(withTimeInterval: 1.7, repeats: true, block: { (t) in
                UIView.animate(withDuration: 0.75, animations: {
                    self.statusLabel.alpha = 0
                }) { (b) in
                    UIView.animate(withDuration: 0.75, animations: {
                        self.statusLabel.alpha = 1
                    })
                }
            })
        }
    }
    
    func stopPulsating() {
        pulseTimer?.invalidate()
    }
    
    // Controller Interaction
    func set(status : ConnectionStatus) {
        switch status {
        case .connecting:
            statusLabel.text = "CONNECTING..."
            stopPulsating()
            UIView.animate(withDuration: 0.3) {
                self.backColoredView.backgroundColor = get(color: .orangeYellow)
            }
        case .connected:
            statusLabel.text = "CONNECTED"
            pulsate()
            UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveLinear, animations: {
                self.backColoredView.backgroundColor = get(color: .gGreen)
            }, completion: nil)
        case .failed:
            statusLabel.text = "FAILED"
            stopPulsating()
            UIView.animate(withDuration: 0.3) {
                self.backColoredView.backgroundColor = get(color: .gRed)
            }
        }
    }
}

enum ConnectionStatus {
    case connecting
    case connected
    case failed
}


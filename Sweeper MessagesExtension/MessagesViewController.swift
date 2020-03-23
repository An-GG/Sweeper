//
//  MessagesViewController.swift
//  Sweeper MessagesExtension
//
//  Created by Ankush Girotra on 12/16/19.
//  Copyright © 2019 Ankush Girotra. All rights reserved.
//

import UIKit
import Messages
import FirebaseCore
import FirebaseDatabase

var convo: MSConversation?
var globalComms = Comms()
var globalController : MessagesViewController?
var globalDatabseRef : DatabaseReference!

class MessagesViewController: MSMessagesAppViewController {
    
    let liveView = LiveGameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalController = self
        
        FirebaseApp.configure()
        globalDatabseRef = Database.database().reference()
        
        self.view.addSubview(liveView)
        liveView.isHidden = true
    }
    
    override func viewLayoutMarginsDidChange() {
        
    }

    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        convo = conversation

        
        // User Selects Message and App Is Inactive
        if let _ = conversation.selectedMessage {
            globalComms.launchGame(url: conversation.selectedMessage!.url!)
            print("Game Launch Attemped From Activation")
        }
    }
    
    func layout() {
        liveView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.height - self.view.safeAreaInsets.bottom)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        // User Selects Message and App is Active
        globalComms.launchGame(url: message.url!)
    }

    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        layout()
    }
    
    // Live Game Setup
    func startLiveGame(UGID: String, gamemode: Gamemode) {
        layout()
        dismiss(animated: true, completion: nil)
        liveView.isHidden = false
        liveView.startGame(UGID: UGID, gamemode: gamemode)
    }

}

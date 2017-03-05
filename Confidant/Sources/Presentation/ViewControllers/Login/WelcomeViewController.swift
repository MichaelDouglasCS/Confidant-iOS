//
//  WelcomeViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 02/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Structs -
//
//**************************************************************************************************

fileprivate struct WelcomeMessages {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    private let messageOne = ["title": "Welcome", "text": "Feel free for help someone or keep someone help you, find your Confidant."]
    private let messageTwo = ["title": "MessageTwo", "text": "MessageTwo"]
    private let messageThree = ["title": "MessageThree", "text": "MessageThree"]
    private let messageFour = ["title": "MessageFour", "text": "MessageFour"]
    private let messageFive = ["title": "MessageFive", "text": "MessageFive"]
    
    //*************************************************
    // MARK: - Public Methods
    //*************************************************
    
    func getMessages() -> [Dictionary<String, String>] {
        let messagesArray = [self.messageOne, self.messageTwo, self.messageThree, self.messageFour, self.messageFive]
        return messagesArray
    }
    
}

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class WelcomeViewController: UIViewController {

    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    
    @IBOutlet weak var messagePageControl: UIPageControl!
    
    //*************************************************
    // MARK: - Setup Design Properties
    //*************************************************
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
//    private func loadMessages() {
//        let messages = WelcomeMessages().getMessages()
//        for (index, message) in messages.enumerated() {
//
//            
//        }
//    }
    

}

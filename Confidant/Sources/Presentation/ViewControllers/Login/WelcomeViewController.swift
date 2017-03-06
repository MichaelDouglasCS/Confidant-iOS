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
    
    @IBOutlet weak var messageScrollView: UIScrollView!
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
    // MARK: - Properties
    //*************************************************
    
    private var messageView: UIView!
    private var messageTitle: UILabel!
    private var messageText: UILabel!
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWelcomeMessages()
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func loadWelcomeMessages() {
        
        //Setup Size and Position MessageView, Title and Text
        self.messageView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.messageScrollView.bounds.size.width), height: CGFloat(self.messageScrollView.bounds.size.height)))
        self.messageTitle = UILabel(frame: CGRect(x: CGFloat(self.messageView.frame.size.width - 345) / 2, y: 0, width: 345, height: 20))
        self.messageText = UILabel(frame: CGRect(x: CGFloat(self.messageView.frame.size.width - 345) / 2, y: CGFloat(self.messageTitle.frame.size.height + 3), width: 345, height: 45))
        
        //Configure MessageView Background
        self.messageView.backgroundColor = UIColor.clear
        
        //Configure MessageTitle and MessageText to input in MessageView
        var attributedString = NSMutableAttributedString(string: "Welcome")
        attributedString.addAttribute(NSKernAttributeName, value: -0.5, range: NSRange(location: 0, length: attributedString.length))
        self.messageTitle.attributedText = attributedString
        self.messageTitle.font = UIFont(name: "Gotham-Bold", size: 22)
        self.messageTitle.textColor = UIColor.white
        self.messageTitle.textAlignment = .center
        
        attributedString = NSMutableAttributedString(string: "Feel free for help someone or keep someone help you, find your Confidant.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.messageText.textAlignment
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.messageText.attributedText = attributedString
        self.messageText.font = UIFont(name: "Gotham-Bold", size: 12)
        self.messageText.numberOfLines = 0
        self.messageText.textColor = UIColor(white: 100, alpha: 0.7)
        self.messageText.textAlignment = .center
        
        self.messageView.addSubview(self.messageTitle)
        self.messageView.addSubview(self.messageText)
        
        print(self.messageTitle.frame)
        print(self.messageText.frame)
        
        //Configure MessagesLabel to input in MessageView
        
        
        
        self.messageScrollView.addSubview(self.messageView)
//        
//        let messages = WelcomeMessages().getMessages()
//        for (index, message) in messages.enumerated() {
//            
//        }
    }
    

}

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

class WelcomeViewController: UIViewController, UIScrollViewDelegate {
    
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
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWelcomeMessages()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    //*************************************************
    // MARK: - Public Methods
    //*************************************************
    
    internal func swipeRecognizer(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            if self.messagePageControl.currentPage != 4 {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - self.messageScrollView.frame.size.width, y: 0), animated: true)
            } else {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - self.messageScrollView.frame.size.width, y: 0), animated: true)
            }
        case UISwipeGestureRecognizerDirection.left:
            print("left")
            if self.messagePageControl.currentPage != 4 {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width, y: 0), animated: true)
            } else {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - (self.messageScrollView.frame.size.width * 4), y: 0), animated: false)
            }
        default: break
        }
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func loadWelcomeMessages() {
        
        let welcomeMessages = WelcomeMessages().getMessages()
        
        for (index, message) in welcomeMessages.enumerated() {
            
            self.messageScrollView.contentSize = CGSize(width: self.view.bounds.size.width * CGFloat(welcomeMessages.count), height: self.messageScrollView.frame.size.height)
            
            //Setup Size and Position MessageView, Title and Text
            let messageView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.messageScrollView.bounds.size.width), height: CGFloat(self.messageScrollView.bounds.size.height)))
            let messageTitle = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: 0, width: 345, height: 20))
            let messageText = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: CGFloat(messageTitle.frame.size.height + 3), width: 345, height: 45))
            
            //Configure MessageView Background
            messageView.backgroundColor = UIColor.clear
            
            //Configure MessageTitle and MessageText to input in MessageView
            if let title = message["title"] {
                messageTitle.getMessageTitleFormat(title: title)
            }
            if let text = message["text"] {
                messageText.getMessageTextFormat(text: text)
            }
            
            //Input MessagesLabels into MessageView
            messageView.addSubview(messageTitle)
            messageView.addSubview(messageText)
            
            messageView.frame.origin.x = CGFloat(index) * self.messageScrollView.frame.size.width
            
            //Input MessageView into MessageScrollView
            self.messageScrollView.addSubview(messageView)
            
        }
        
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.messagePageControl.currentPage = Int(page)
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - UILabel - WelcomeMessageFormat
//
//**************************************************************************************************

extension UILabel {
    func getMessageTitleFormat(title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSKernAttributeName, value: -0.5, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: 22)
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    func getMessageTextFormat(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: 12)
        self.textColor = UIColor(white: 100, alpha: 0.7)
        self.textAlignment = .center
        self.numberOfLines = 0
    }
}

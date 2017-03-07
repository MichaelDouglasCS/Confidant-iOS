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
    
    private let messageOne = ["title": "Welcome", "text": "Feel free for help someone or keep someone help you, find your Confidant"]
    private let messageTwo = ["title": "Anonymously", "text": "Don't care about your identity, we assure your securence and anonymity"]
    private let messageThree = ["title": "Randomly", "text": "Let us find someone to help you, according to your interests"]
    private let messageFour = ["title": "Voluntary", "text": "How about you being a volunteer?"]
    private let messageFive = ["title": "Score", "text": "Be punctuated by people that you help, become the first and share it with everyone"]
    
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
            if self.messagePageControl.currentPage != 0 {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - self.messageScrollView.frame.size.width, y: 0), animated: true)
            } else {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width * 4, y: 0), animated: false)
                self.view.layoutIfNeeded()
            }
        case UISwipeGestureRecognizerDirection.left:
            if self.messagePageControl.currentPage != 4 {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width, y: 0), animated: true)
            } else {
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - (self.messageScrollView.frame.size.width * 4), y: 0), animated: false)
                self.view.layoutIfNeeded()
            }
        default: break
        }
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func loadWelcomeMessages() {
        
        let welcomeMessages = WelcomeMessages().getMessages()
        
        self.messagePageControl.numberOfPages = welcomeMessages.count
        
        for (index, message) in welcomeMessages.enumerated() {
            
            self.messageScrollView.contentSize = CGSize(width: self.view.bounds.size.width * CGFloat(welcomeMessages.count), height: self.messageScrollView.frame.size.height)
            
            //Setup Size and Position MessageView, Title and Text
            let messageView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.messageScrollView.bounds.size.width), height: CGFloat(self.messageScrollView.bounds.size.height)))
            let messageTitle = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: 0, width: 345, height: 25))
            let messageText = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: CGFloat(messageTitle.frame.size.height + 3), width: 345, height: 40))
            
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
        
        print(self.messageScrollView)
        
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.messagePageControl.currentPage = Int(page)
    }
    
}

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
    
    private var numberOfPages: Int {
        get {
            return WelcomeMessages().getMessages().count
        }
    }
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWelcomeMessages()
        self.messagePageControl.numberOfPages = self.numberOfPages
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
            self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - self.messageScrollView.frame.size.width, y: 0), animated: true)
        case UISwipeGestureRecognizerDirection.left:
                self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width, y: 0), animated: true)
        default: break
        }
    }
    
    //*************************************************
    // MARK: - Private Methods
    //*************************************************
    
    private func loadWelcomeMessages() {
        let welcomeMessages = WelcomeMessages().getMessages()
        self.messageScrollView.contentSize = CGSize(width: self.view.bounds.size.width * (CGFloat(welcomeMessages.count) + 2), height: self.messageScrollView.frame.size.height)
        for (index, message) in welcomeMessages.enumerated() {
            //Setup Size and Position MessageView, Title and Text
            let messageView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.messageScrollView.bounds.size.width), height: CGFloat(self.messageScrollView.bounds.size.height)))
            let messageTitle = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: 0, width: 345, height: 25))
            let messageText = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 345) / 2, y: CGFloat(messageTitle.frame.size.height + 3), width: 345, height: 40))
            //Configure MessageView Background
            messageView.backgroundColor = UIColor.clear
            
            if index == welcomeMessages.startIndex {
                let firstView = UIView(frame: messageView.frame)
                let firstTitle = UILabel(frame: messageTitle.frame)
                let firstText = UILabel(frame: messageText.frame)
                if let title = welcomeMessages[welcomeMessages.endIndex-1]["title"] {
                    firstTitle.getMessageTitleFormat(title: title)
                }
                if let text = welcomeMessages[welcomeMessages.endIndex-1]["text"] {
                    firstText.getMessageTextFormat(text: text)
                }
                firstView.addSubViews(views: [firstTitle, firstText])
                firstView.frame.origin.x = CGFloat(index-1) * self.messageScrollView.frame.size.width
                self.messageScrollView.addSubview(firstView)
            }
            
            //Configure MessageTitle and MessageText to input in MessageView
            if let title = message["title"] {
                messageTitle.getMessageTitleFormat(title: title)
            }
            if let text = message["text"] {
                messageText.getMessageTextFormat(text: text)
            }
            
            messageView.addSubViews(views: [messageTitle, messageText])
            messageView.frame.origin.x = CGFloat(index) * self.messageScrollView.frame.size.width
            self.messageScrollView.addSubview(messageView)
            
            if index == welcomeMessages.endIndex - 1 {
                let lastView = UIView(frame: messageView.frame)
                let lastTitle = UILabel(frame: messageTitle.frame)
                let lastText = UILabel(frame: messageText.frame)
                if let title = welcomeMessages[welcomeMessages.startIndex]["title"] {
                    lastTitle.getMessageTitleFormat(title: title)
                }
                if let text = welcomeMessages[welcomeMessages.startIndex]["text"] {
                    lastText.getMessageTextFormat(text: text)
                }
                lastView.addSubViews(views: [lastTitle, lastText])
                lastView.frame.origin.x = CGFloat(index+1) * self.messageScrollView.frame.size.width
                self.messageScrollView.addSubview(lastView)
            }
        }
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == (-self.view.frame.size.width)) {
            self.messageScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width * CGFloat(self.numberOfPages), y: 0), animated: false)
        } else if (scrollView.contentOffset.x == (self.view.frame.size.width * CGFloat(self.numberOfPages))) {
            self.messageScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - scrollView.frame.size.width * CGFloat(self.numberOfPages), y: 0), animated: false)
        }
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.messagePageControl.currentPage = Int(page)
    }
    
}

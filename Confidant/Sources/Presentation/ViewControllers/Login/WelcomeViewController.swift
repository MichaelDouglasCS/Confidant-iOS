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

//TitleAttributes
fileprivate let kFontSizeTitle: CGFloat = 22
fileprivate let kLetterSpacingTitle: Double = -0.5

//TextAttributes
fileprivate let kLineSpacingText: CGFloat = 10
fileprivate let kFontSizeText: CGFloat = 12

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
    // MARK: - Internal Methods
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

class WelcomeViewController : UIViewController {
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    @IBOutlet weak var messageScrollView: UIScrollView!
    @IBOutlet weak var messagePageControl: UIPageControl!
    
    private var timer = Timer()
    fileprivate var numberOfPages: Int {
        get {
            return WelcomeMessages().getMessages().count
        }
    }
    
//*************************************************
// MARK: - Constructors
//*************************************************
    
//*************************************************
// MARK: - Protected Methods
//*************************************************
    
    private func setupNavigationBar() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func addSwipeGestureRecognizers() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
        swipeRight.direction = .right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
        swipeLeft.direction = .left
        
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    @objc private func swipeTimer() {
        self.view.isUserInteractionEnabled = false
        self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func swipeRecognizer(_ gesture: UISwipeGestureRecognizer) {
        self.view.isUserInteractionEnabled = false
        self.resetTimer()
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x - self.messageScrollView.frame.size.width, y: 0), animated: true)
        case UISwipeGestureRecognizerDirection.left:
            self.messageScrollView.setContentOffset(CGPoint(x: self.messageScrollView.contentOffset.x + self.messageScrollView.frame.size.width, y: 0), animated: true)
        default: break
        }
    }
    
    //*************************************************
    // MARK: - Welcome Messages Methods
    //*************************************************
    
    private func loadWelcomeMessages() {
        //Actualize MessageScrollView with the same frame of Super View
        self.messageScrollView.frame = self.view.frame
        
        let welcomeMessages = WelcomeMessages().getMessages()
        
        self.messageScrollView.contentSize = CGSize(width: self.view.bounds.size.width * (CGFloat(welcomeMessages.count) + 2), height: self.messageScrollView.frame.size.height)
        
        for (index, message) in welcomeMessages.enumerated() {
            //Setup Size and Position MessageView, Title and Text
            let messageView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(self.messageScrollView.bounds.size.width), height: CGFloat(self.messageScrollView.bounds.size.height)))
            let messageTitle = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 300) / 2, y: 0, width: 300, height: 25))
            let messageText = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 300) / 2, y: CGFloat(messageTitle.frame.size.height + 3), width: 300, height: 40))
            
            //Configure MessageView Background
            messageView.backgroundColor = UIColor.clear

            if index == welcomeMessages.startIndex {
                let firstView = UIView(frame: messageView.frame)
                let firstTitle = UILabel(frame: messageTitle.frame)
                let firstText = UILabel(frame: messageText.frame)
                
                if let title = welcomeMessages[welcomeMessages.endIndex-1]["title"] {
                    firstTitle.getMessageFormat(title: title)
                }
                if let text = welcomeMessages[welcomeMessages.endIndex-1]["text"] {
                    firstText.getMessageFormat(text: text)
                }
                
                firstView.addSubViews(views: [firstTitle, firstText])
                firstView.frame.origin.x = CGFloat(index-1) * self.messageScrollView.frame.size.width
                
                self.messageScrollView.addSubview(firstView)
            }
            
            //Configure MessageTitle and MessageText to input in MessageView
            if let title = message["title"] {
                messageTitle.getMessageFormat(title: title)
            }
            if let text = message["text"] {
                messageText.getMessageFormat(text: text)
            }
            
            messageView.addSubViews(views: [messageTitle, messageText])
            messageView.frame.origin.x = CGFloat(index) * self.messageScrollView.frame.size.width
            
            self.messageScrollView.addSubview(messageView)
            
            if index == welcomeMessages.endIndex - 1 {
                let lastView = UIView(frame: messageView.frame)
                let lastTitle = UILabel(frame: messageTitle.frame)
                let lastText = UILabel(frame: messageText.frame)
                if let title = welcomeMessages[welcomeMessages.startIndex]["title"] {
                    lastTitle.getMessageFormat(title: title)
                }
                if let text = welcomeMessages[welcomeMessages.startIndex]["text"] {
                    lastText.getMessageFormat(text: text)
                }
                lastView.addSubViews(views: [lastTitle, lastText])
                lastView.frame.origin.x = CGFloat(index+1) * self.messageScrollView.frame.size.width
                self.messageScrollView.addSubview(lastView)
            }
        }
    }
    
    //*************************************************
    // MARK: - Timer Methods
    //*************************************************
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.swipeTimer), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        self.timer.invalidate()
        self.startTimer()
    }
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadWelcomeMessages()
        self.messagePageControl.numberOfPages = self.numberOfPages
        self.addSwipeGestureRecognizers()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - WelcomeVC - UIScrollViewDelegate
//
//**************************************************************************************************

extension WelcomeViewController : UIScrollViewDelegate {
    
    //*************************************************
    // MARK: - ScrollView Methods
    //*************************************************
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x == (-self.view.frame.size.width)) {
            self.messageScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width * CGFloat(self.numberOfPages), y: 0), animated: false)
        } else if (scrollView.contentOffset.x == (self.view.frame.size.width * CGFloat(self.numberOfPages))) {
            self.messageScrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - scrollView.frame.size.width * CGFloat(self.numberOfPages), y: 0), animated: false)
        }
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.messagePageControl.currentPage = Int(page)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.view.isUserInteractionEnabled = true
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - UILabel - WelcomeMessageFormat
//
//**************************************************************************************************

extension UILabel {
    
    func getMessageFormat(title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSKernAttributeName, value: kLetterSpacingTitle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: kFontSizeTitle)
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    
    func getMessageFormat(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = kLineSpacingText
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: kFontSizeText)
        self.textColor = UIColor(white: 100, alpha: 0.7)
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
}

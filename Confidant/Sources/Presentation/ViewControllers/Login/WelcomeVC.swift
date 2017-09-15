//
//  WelcomeVC.swift
//  Confidant
//
//  Created by Michael Douglas on 02/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class WelcomeVC: UIViewController {
	
	fileprivate struct Messages {
		
		typealias local = String.Local
		
		private static let welcome = ["title": local.welcome, "text": local.welcomeMessage]
		private static let anonymously = ["title": local.anonymously, "text": local.anonymouslyMessage]
		private static let randomly = ["title": local.randomly, "text": local.randomlyMessage]
		private static let voluntary = ["title": local.voluntary, "text": local.voluntaryMessage]
		private static let score = ["title": local.score, "text": local.scoreMessage]
		
		static func getList() -> [[String: String]] {
			let messages = [self.welcome,
			                     self.anonymously,
			                     self.randomly,
			                     self.voluntary,
			                     self.score]
			
			return messages
		}
	}
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var pagesCount: Int { return Messages.getList().count }
	private var timer = Timer()
	
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
    private func setupNavigationBar() {
		let barButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = barButton
    }
	
    private func addSwipeGesture() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRecognizer(_:)))
		
		swipeRight.direction = .right
        swipeLeft.direction = .left
		
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
	
    @objc private func swipeRecognizer(_ gesture: UISwipeGestureRecognizer) {
        self.view.isUserInteractionEnabled = false
        self.resetTimer()
		
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x - self.scrollView.frame.size.width, y: 0), animated: true)
        case UISwipeGestureRecognizerDirection.left:
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.size.width, y: 0), animated: true)
        default: break
        }
    }
	
	@objc private func swipeAction() {
		self.view.isUserInteractionEnabled = false
		self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x + self.scrollView.frame.size.width, y: 0), animated: true)
	}
	
    private func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.swipeAction), userInfo: nil, repeats: true)
    }
    
    private func resetTimer() {
        self.timer.invalidate()
        self.startTimer()
    }

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadData()
        self.addSwipeGesture()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
		self.navigationController?.setNavigationBarHidden(true, animated: true)
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

extension WelcomeVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let frame = self.view.frame
		
        if (scrollView.contentOffset.x == (-frame.size.width)) {
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.size.width * CGFloat(self.pagesCount), y: 0), animated: false)
        } else if (scrollView.contentOffset.x == (frame.size.width * CGFloat(self.pagesCount))) {
            self.scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - scrollView.frame.size.width * CGFloat(self.pagesCount), y: 0), animated: false)
        }
		
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.pageControl.currentPage = Int(page)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.view.isUserInteractionEnabled = true
    }
}

//**********************************************************************************************************
//
// MARK: - Extension - Load Data
//
//**********************************************************************************************************

extension WelcomeVC {
	
	fileprivate func loadData() {
		let messages = Messages.getList()
		let frame = self.view.frame
		let bounds = self.view.bounds
		
		self.scrollView.frame = frame
		
		let scrollViewFrame = self.scrollView.frame
		let scrollViewBounds = self.scrollView.bounds
		
		
		self.scrollView.contentSize = CGSize(width: bounds.size.width * (CGFloat(messages.count) + 2),
		                                     height: self.scrollView.frame.size.height)
		
		for (index, message) in messages.enumerated() {
			//Setup Size and Position MessageView, Title and Text
			let messageView = UIView(frame: CGRect(x: 0,
			                                       y: 0,
			                                       width: CGFloat(scrollViewBounds.size.width),
			                                       height: CGFloat(scrollViewBounds.size.height)))
			let messageTitle = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 300) / 2,
			                                         y: 0,
			                                         width: 300,
			                                         height: 25))
			let messageText = UILabel(frame: CGRect(x: CGFloat(messageView.frame.size.width - 300) / 2,
			                                        y: CGFloat(messageTitle.frame.size.height + 3),
			                                        width: 300,
			                                        height: 40))
			
			//Configure MessageView Background
			messageView.backgroundColor = UIColor.clear
			
			if index == messages.startIndex {
				let firstView = UIView(frame: messageView.frame)
				let firstTitle = UILabel(frame: messageTitle.frame)
				let firstText = UILabel(frame: messageText.frame)
				
				if let title = messages[messages.endIndex-1]["title"] {
					firstTitle.format(title: title)
				}
				
				if let text = messages[messages.endIndex-1]["text"] {
					firstText.format(text: text)
				}
				
				firstView.addSubViews(views: [firstTitle, firstText])
				firstView.frame.origin.x = CGFloat(index-1) * scrollViewFrame.size.width
				
				self.scrollView.addSubview(firstView)
			}
			
			//Configure MessageTitle and MessageText to input in MessageView
			if let title = message["title"] {
				messageTitle.format(title: title)
			}
			
			if let text = message["text"] {
				messageText.format(text: text)
			}
			
			messageView.addSubViews(views: [messageTitle, messageText])
			messageView.frame.origin.x = CGFloat(index) * scrollViewFrame.size.width
			
			self.scrollView.addSubview(messageView)
			
			if index == messages.endIndex - 1 {
				let lastView = UIView(frame: messageView.frame)
				let lastTitle = UILabel(frame: messageTitle.frame)
				let lastText = UILabel(frame: messageText.frame)
				
				if let title = messages[messages.startIndex]["title"] {
					lastTitle.format(title: title)
				}
				
				if let text = messages[messages.startIndex]["text"] {
					lastText.format(text: text)
				}
				
				lastView.addSubViews(views: [lastTitle, lastText])
				lastView.frame.origin.x = CGFloat(index+1) * scrollViewFrame.size.width
				
				self.scrollView.addSubview(lastView)
			}
		}
		
		self.pageControl.numberOfPages = self.pagesCount
	}
}

//**************************************************************************************************
//
// MARK: - Extension - UILabel - MessageFormat
//
//**************************************************************************************************

extension UILabel {
    
    fileprivate func format(title: String) {
        let attributedString = NSMutableAttributedString(string: title)
		
        attributedString.addAttribute(NSKernAttributeName,
                                      value: -0.5,
                                      range: NSRange(location: 0, length: attributedString.length))
		
		self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: 22)
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    
    fileprivate func format(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
		
        paragraphStyle.lineSpacing = 10
        attributedString.addAttribute(NSParagraphStyleAttributeName,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
		
		self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: 12)
        self.textColor = UIColor(white: 100, alpha: 0.7)
        self.textAlignment = .center
        self.numberOfLines = 0
    }
}

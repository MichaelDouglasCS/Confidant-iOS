//
//  FinishChatAlertView.swift
//  Confidant
//
//  Created by Michael Douglas on 24/10/17.
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

protocol FinishChatAlertViewDelegate : class {
	func finishChatAlert(_ chatAlert: FinishChatAlertView, didFinishChat chat: ChatBO?)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class FinishChatAlertView: XIBDesignable {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var popOverView: UIBox!
	@IBOutlet weak var rateTextLabel: LocalizedLabel!
	@IBOutlet weak var starOne: UIButton!
	@IBOutlet weak var starTwo: UIButton!
	@IBOutlet weak var starThree: UIButton!
	@IBOutlet weak var starFour: UIButton!
	@IBOutlet weak var starFive: UIButton!
	
	weak var delegate: FinishChatAlertViewDelegate?
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupView() {
		let typeOfUser = UsersLO.sharedInstance.current.profile.typeOfUser
		typealias local = String.Local
		
		self.rateTextLabel.text = typeOfUser == .confidant ? local.rateWhoYouHelped : local.rateYourConfidant
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func cancelAction(_ sender: LocalizedButton) {
		self.delegate?.finishChatAlert(self, didFinishChat: nil)
	}
	
	@IBAction func yesAction(_ sender: LocalizedButton) {
		let chat = ChatLO.sharedInstance.current
		self.delegate?.finishChatAlert(self, didFinishChat: chat)
	}
	
	@IBAction func rateAction(_ sender: UIButton) {
		
		switch sender {
		case self.starOne:
			self.starOne.isSelected = true
			self.starTwo.isSelected = false
			self.starThree.isSelected = false
			self.starFour.isSelected = false
			self.starFive.isSelected = false
		case self.starTwo:
			self.starOne.isSelected = true
			self.starTwo.isSelected = true
			self.starThree.isSelected = false
			self.starFour.isSelected = false
			self.starFive.isSelected = false
		case self.starThree:
			self.starOne.isSelected = true
			self.starTwo.isSelected = true
			self.starThree.isSelected = true
			self.starFour.isSelected = false
			self.starFive.isSelected = false
		case self.starFour:
			self.starOne.isSelected = true
			self.starTwo.isSelected = true
			self.starThree.isSelected = true
			self.starFour.isSelected = true
			self.starFive.isSelected = false
		case self.starFive:
			self.starOne.isSelected = true
			self.starTwo.isSelected = true
			self.starThree.isSelected = true
			self.starFour.isSelected = true
			self.starFive.isSelected = true
		default: break
		}
	}
	
	func showingAnimate(completion: ((Bool) -> Void)? = nil) {
		self.backgroundView.alpha = 0.0
		self.popOverView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
		
		UIView.animate(withDuration: 0.3,
		               delay: 0.3,
		               usingSpringWithDamping: 0.7,
		               initialSpringVelocity: 0,
		               options: .transitionCrossDissolve,
		               animations: {
						self.backgroundView.alpha = 0.5
						self.popOverView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		}, completion: { (bool) in
			
			if let completionHandler = completion {
				completionHandler(bool)
			}
		})
	}
	
	func hiddenAnimate(completion: ((Bool) -> Void)? = nil) {
		
		UIView.animate(withDuration: 0.5,
		               delay: 0.0,
		               usingSpringWithDamping: 0.7,
		               initialSpringVelocity: 0,
		               options: .transitionCrossDissolve,
		               animations: {
						self.popOverView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
						self.backgroundView.alpha = 0.0
		}, completion: { (bool) in
			
			if let completionHandler = completion {
				completionHandler(bool)
			}
		})
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.setupView()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
}

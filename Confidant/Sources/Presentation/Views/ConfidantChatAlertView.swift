//
//  ConfidantChatAlertView.swift
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

protocol ConfidantChatAlertDelegate : class {
	func chatAlert(_ chatAlert: ConfidantChatAlertView, didSelectAnswer chat: ChatBO?)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ConfidantChatAlertView: XIBDesignable {

//*************************************************
// MARK: - Properties
//*************************************************
	
	private var chat: ChatBO?
	
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var popOverView: UIBox!
	@IBOutlet weak var userImageView: CircularImage!
	@IBOutlet weak var userNickname: LocalizedLabel!
	@IBOutlet weak var userReason: UITextView!
	
	weak var delegate: ConfidantChatAlertDelegate?
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

	private func setupView() {
		
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************

	func updateLayout(for model: ChatBO?) {
		self.chat = model
		
		if let model = model {
			self.userImageView.loadingIndicatorView(isShow: true, at: nil)

			MediaLO.downloadImage(from: model.userProfile?.picture?.fileURL ?? "") { (image, result) in
				
				switch result {
				case .success:
					self.userImageView.image = image
				default:
					break
				}
				self.userImageView.loadingIndicatorView(isShow: false, at: nil)
			}
			
			self.userNickname.text = model.userProfile?.nickname
			self.userReason.text = model.reason
		}
	}

	@IBAction func noAction(_ sender: LocalizedButton) {
		self.delegate?.chatAlert(self, didSelectAnswer: nil)
	}
	
	@IBAction func yesAction(_ sender: LocalizedButton) {
		let user = UsersLO.sharedInstance.current
		self.chat?.confidantProfile = ChatProfileBO(id: user.id,
		                                            nickname: user.profile.nickname,
		                                            picture: user.profile.picture)
		
		self.delegate?.chatAlert(self, didSelectAnswer: self.chat)
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

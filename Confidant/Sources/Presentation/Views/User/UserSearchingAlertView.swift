//
//  UserSearchingAlertView.swift
//  Confidant
//
//  Created by Michael Douglas on 29/10/17.
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

protocol UserSearchingAlertDelegate: class {
	func didSelectCancel(_ searchingAlert: UserSearchingAlertView)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class UserSearchingAlertView: XIBDesignable {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var popOverView: UIBox!
	@IBOutlet weak var loadingView: UIImageView!
	
	weak var delegate: UserSearchingAlertDelegate?

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupView() {
		var loading = [UIImage]()
		
		for i in 0...40 {
			let image = UIImage(named: "loading_\(i)")
			if let imageLoad = image {
				loading.append(imageLoad)
			}
		}

		self.loadingView.image = UIImage.animatedImage(with: loading, duration: 1.5)
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func cancelAction(_ sender: LocalizedButton) {
		self.delegate?.didSelectCancel(self)
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


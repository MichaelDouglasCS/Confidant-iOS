//
//  ProfileTypeVC.swift
//  Confidant
//
//  Created by Michael Douglas on 29/09/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ProfileTypeVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var userButton: UIButton!
	@IBOutlet weak var confidantButton: UIButton!
	@IBOutlet weak var continueButton: IBDesigableButton!

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func changeType(for sender: UIButton) {
		let userInstance = UsersLO.sharedInstance
		self.userButton.isSelected = false
		self.userButton.isUserInteractionEnabled = true
		self.confidantButton.isSelected = false
		self.confidantButton.isUserInteractionEnabled = true
		self.continueButton.isEnabled = true
		
		sender.isSelected = true
		sender.isUserInteractionEnabled = false
		
		switch sender {
		case self.userButton:
			userInstance.current.profile.typeOfUser = .user
			userInstance.current.profile.isAvailable = false
		case self.confidantButton:
			userInstance.current.profile.typeOfUser = .confidant
			
			if let knowledges = userInstance.current.profile.knowledges {
				userInstance.current.profile.knowledges = knowledges
			} else {
				userInstance.current.profile.knowledges = []
			}
			
			if let isAvailable = userInstance.current.profile.isAvailable {
				userInstance.current.profile.isAvailable = isAvailable
			} else {
				userInstance.current.profile.isAvailable = false
			}
		default:
			break
		}
	}
	
	private func updateAndContinue() {
		let user = UsersLO.sharedInstance.current
		
		self.loadingIndicatorCustom(isShow: true)
		
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			switch result {
			case .success:
				
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "showPersonalInfoSegue", sender: nil)
				}
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.loadingIndicatorCustom(isShow: false)
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func userSelectedAction(_ sender: UIButton) {
		self.changeType(for: sender)
	}
	
	@IBAction func confidantSelectedAction(_ sender: UIButton) {
		self.changeType(for: sender)
	}

	@IBAction func continueAction(_ sender: IBDesigableButton) {
		self.updateAndContinue()
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
    override func viewDidLoad() {
        super.viewDidLoad()
		UIApplication.shared.statusBarStyle = .default
    }
}

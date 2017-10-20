//
//  GoOnlineVC.swift
//  Confidant
//
//  Created by Michael Douglas on 19/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class GoOnlineVC: UIViewController {

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func updateAndContinue() {
		self.loadingIndicatorCustom(isShow: true)
		
		UsersLO.sharedInstance.changeAvailability() { (result) in
			
			switch result {
			case .success:
				print("\(UsersLO.sharedInstance.current.profile.isAvailable ?? false)")
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.loadingIndicatorCustom(isShow: false)
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func goOnlineAction(_ sender: IBDesigableButton) {
		self.updateAndContinue()
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UIApplication.shared.statusBarStyle = .default
	}
}

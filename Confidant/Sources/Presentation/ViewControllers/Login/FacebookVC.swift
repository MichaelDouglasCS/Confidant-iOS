//
//  FacebookVC.swift
//  Confidant
//
//  Created by Michael Douglas on 17/08/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SafariServices

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

class FacebookVC: SFSafariViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	private var rootViewController: UIViewController?
	private var completion: LogicResult?
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

	private func setupSafariBrowser() {
		self.preferredBarTintColor = .white
		self.preferredControlTintColor = UIColor.Confidant.pink
	}
	
	@objc private func authenticationSuccessful() {
		self.completion?(.success)
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc private func authenticationFailed() {
		self.completion?(.error(.unkown))
		self.dismiss(animated: true, completion: nil)
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	func auth(target viewController: UIViewController, completionHandler: @escaping LogicResult) {
		self.rootViewController = viewController
		self.completion = completionHandler
		self.modalTransitionStyle = .coverVertical
		self.modalPresentationStyle = .overCurrentContext
		viewController.present(self, animated: true)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupSafariBrowser()
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.authenticationSuccessful),
		                                       name: .userDidLoginSuccess,
		                                       object: nil)
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.authenticationFailed),
		                                       name: .userDidLoginError,
		                                       object: nil)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.rootViewController?.loadingIndicator(isShow: false)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

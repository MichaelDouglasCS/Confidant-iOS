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
// MARK: - Class -
//
//**********************************************************************************************************

class FacebookVC: SFSafariViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	private var rootViewController: UIViewController?
	fileprivate var completion: LogicResult?

//*************************************************
// MARK: - Protected Methods
//*************************************************

	private func setupSafariBrowser() {
		self.preferredBarTintColor = .white
		self.preferredControlTintColor = UIColor.Confidant.pink
		self.definesPresentationContext = true
		self.delegate = self
	}
	
	@objc private func authenticationSuccessful() {
		
		self.dismiss(animated: true) { _ in
			
			UsersLO.sharedInstance.load() { (result) in
				self.completion?(result)
			}
		}
	}
	
	@objc private func authenticationFailed() {
		
		self.dismiss(animated: true) { _ in
			self.completion?(.error(.unkown))
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	func auth(target viewController: UIViewController, completionHandler: @escaping LogicResult) {
		self.rootViewController = viewController
		self.completion = completionHandler
		
		self.modalTransitionStyle = .coverVertical
		self.modalPresentationStyle = .overFullScreen
		
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.statusBarStyle = .default
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - SFSafariViewControllerDelegate
//
//**********************************************************************************************************

extension FacebookVC : SFSafariViewControllerDelegate {
	
	func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
		self.completion?(.error(.facebookError))
	}
}

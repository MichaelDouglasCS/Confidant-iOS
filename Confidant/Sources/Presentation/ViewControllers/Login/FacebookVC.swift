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

public class FacebookVC: SFSafariViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
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
	
	public func auth(target viewController: UIViewController, completionHandler: @escaping LogicResult) {
		self.completion = completionHandler
		viewController.present(self, animated: true)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override public func viewDidLoad() {
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
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

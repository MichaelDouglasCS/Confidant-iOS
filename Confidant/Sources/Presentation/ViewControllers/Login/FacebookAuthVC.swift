//
//  FacebookAuthVC.swift
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

protocol FacebookAuthVCDelegate : class {
	func authenticate(_ viewController: FacebookAuthVC, didAuthenticate user: UserVO)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class FacebookAuthVC: SFSafariViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	weak var facebookDelegate: FacebookAuthVCDelegate?
	
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
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func open(target viewController: UIViewController, completionHandler: @escaping UserVO) {
		viewController.present(self, animated: true)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		self.setupSafariBrowser()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

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

protocol FacebookVCDelegate : class {
	func authenticate(_ viewController: FacebookVC, didAuthenticate user: UserVO)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class FacebookVC: SFSafariViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	weak var facebookDelegate: FacebookVCDelegate?
	
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
	
	public func auth(target viewController: UIViewController, completionHandler: @escaping ((UserVO) -> Void)) {
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

extension URL {
	
	public var queryParameters: [String: String]? {
		guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
			return nil
		}
		
		var parameters = [String: String]()
		for item in queryItems {
			parameters[item.name] = item.value
		}
		
		return parameters
	}
}

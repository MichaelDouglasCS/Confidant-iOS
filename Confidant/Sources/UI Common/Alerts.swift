/*
 *	Alerts.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 05/12/16.
 *	Copyright 2017 Watermelon. All rights reserved.
 */

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

//**********************************************************************************************************
//
// MARK: - Extension - UIViewController
//
//**********************************************************************************************************

extension UIViewController {

//**************************************************
// MARK: - Properties
//**************************************************

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func generateAlert(for title: String, message: Any) -> UIAlertController {
		
		let attMsg = message as? NSAttributedString
		let stringMsg = message as? String ?? ""
		
		let alert = UIAlertController(title: title, message: stringMsg, preferredStyle: .alert)
		
		if let attributed = attMsg {
			alert.setValue(attributed, forKey: "attributedMessage")
			//attributedTitle
		}
		
		return alert
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	func showInfoAlert(title: String, message: Any, completion: ((UIAlertAction) -> Void)? = nil) {
		
		let alert = self.generateAlert(for: title, message: message)
		let defaultAction = UIAlertAction(title: String.Local.ok, style: .cancel, handler: completion)
		
		alert.addAction(defaultAction)
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func showActionAlert(title: String, message: Any, actions: UIAlertAction...) {
		
		let alert = self.generateAlert(for: title, message: message)
		
		for action in actions {
			alert.addAction(action)
		}
		
		self.present(alert, animated: true, completion: nil)
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************

}

/*
 *	KeyboardAdjuster.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 01/12/16.
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

protocol KeyboardSizeAdjuster {
	func keyboardWillTake(frame: CGRect)
}

//**********************************************************************************************************
//
// MARK: - Extension - UIViewController -
//
//**********************************************************************************************************

extension UIViewController {
	
	func keyboardWillChange(notification: Notification) {
		if let userInfo = notification.userInfo,
			let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			(self as? KeyboardSizeAdjuster)?.keyboardWillTake(frame: keyboardRect)
		}
	}
	
	func addKeyboardObservers() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.keyboardWillChange),
		                                       name: .UIKeyboardWillChangeFrame,
		                                       object: nil)
		
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
		                                                         action: #selector(self.dismissKeyboard))
		self.view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard() {
		self.view.endEditing(true)
	}
	
	func removeObservers() {
		NotificationCenter.default.removeObserver(self)
		self.view.gestureRecognizers?.removeAll()
	}
}

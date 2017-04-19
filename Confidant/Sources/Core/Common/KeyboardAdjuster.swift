/*
 *	KeyboardAdjuster.swift
 *	Sapphire
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
	}
	
	func removeObservers() {
		NotificationCenter.default.removeObserver(self)
	}
}

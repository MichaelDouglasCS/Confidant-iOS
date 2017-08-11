/*
 *	LinkedChain.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 04/12/16.
 *	Copyright 2017 Watermelon. All rights reserved.
 */

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

fileprivate var kNextKey: Int8 = 0
fileprivate var kPrevKey: Int8 = 0

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public protocol LinkedChain: class {
	var nextItem: LinkedChain? { get set }
	var previousItem: LinkedChain? { get }
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

fileprivate class WeakWrapper {
	
//**************************************************
// MARK: - Properties
//**************************************************

	weak var value: AnyObject?
	
//**************************************************
// MARK: - Constructors
//**************************************************

	init(_ value: AnyObject?) {
		self.value = value
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - LinkedChain
//
//**********************************************************************************************************

public extension LinkedChain {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	public weak var nextItem: LinkedChain? {
		get {
			return self.retrieveItem(&kNextKey)
		}
		
		set {
			self.nextItem?.previousItem = nil
			self.storeItem(newValue, withKey: &kNextKey)
			newValue?.previousItem = self
		}
	}
	
	public weak internal(set) var previousItem: LinkedChain? {
		get {
			return self.retrieveItem(&kPrevKey)
		}
		
		set {
			self.storeItem(newValue, withKey: &kPrevKey)
		}
	}

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func storeItem(_ optionalItem: LinkedChain?, withKey key: UnsafeRawPointer) {
		if let item = optionalItem {
			objc_setAssociatedObject(self, key, WeakWrapper(item), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		} else {
			objc_setAssociatedObject(self, key, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	private func retrieveItem(_ key: UnsafeRawPointer) -> LinkedChain? {
		if let object = objc_getAssociatedObject(self, key) as? WeakWrapper {
			if let item = object.value as? LinkedChain {
				return item
			} else {
				self.storeItem(nil, withKey: key)
			}
		}
		
		return nil
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************

//**************************************************
// MARK: - Overridden Methods
//**************************************************
}

//**********************************************************************************************************
//
// MARK: - Extension - UIView
//
//**********************************************************************************************************

extension UIView: LinkedChain {
	
	@IBOutlet weak var nextView: UIView? {
		get {
			return self.nextItem as? UIView
		}
		
		set {
			self.nextItem = newValue
			
			// KeyboardToolbar routine
			if let _ = newValue {
				if let textField = self as? UITextField {
					textField.inputAccessoryView = KeyboardToolbar.instance
				} else if let textView = self as? UITextView {
					textView.inputAccessoryView = KeyboardToolbar.instance
				}
			}
		}
	}
	
	weak var previousView: UIView? {
		get {
			return self.previousItem as? UIView
		}
	}
}

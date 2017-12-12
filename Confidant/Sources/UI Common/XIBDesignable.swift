/*
*	XibDesignable.swift
*	MApLE
*
*	Created by Diney on 09/11/16.
*	Copyright 2017 IBM. All rights reserved.
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

public protocol XIBDesignableProtocol : NSObjectProtocol {
	
	var ibView: UIView { get }
	func loadIBView() -> UIView
	func ibName() -> String
}

extension XIBDesignableProtocol where Self : UIView {
	
	fileprivate func setupIB() {
		let view = self.loadIBView()
		view.frame = self.ibView.bounds
		view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		view.translatesAutoresizingMaskIntoConstraints = true
		self.ibView.addSubview(view)
	}
	
	public var ibView : UIView {
		return self
	}
	
	public func ibName() -> String {
		return type(of: self).description().components(separatedBy: ".").last ?? ""
	}
	
	public func loadIBView() -> UIView {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: self.ibName(), bundle: bundle)
		return nib.instantiate(withOwner: self, options: nil)[0] as? UIView ?? UIView()
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
open class XIBDesignable : UIView, XIBDesignableProtocol {
	
	convenience public init(frame: CGRect, fromNib: Bool) {
		self.init(frame: frame)
		
		if fromNib {
			self.setupIB()
		}
		
		self.layoutIfNeeded()
	}
	
	//**************************************************
	// MARK: - Overridden Methods
	//**************************************************
	
	override open func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupIB()
	}
	
	override open func awakeFromNib() {
		super.awakeFromNib()
		self.setupIB()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITableView
//
//**********************************************************************************************************

extension UITableView {
	
	func cellFromXIB(withIdentifier id: String) -> UITableViewCell? {
		if let view = self.dequeueReusableCell(withIdentifier: id) {
			return view
		} else {
			self.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
			return self.dequeueReusableCell(withIdentifier: id)
		}
	}
	
	//	func cellFrom(class classCell: AnyClass, withIdentifier id: String) -> UITableViewCell? {
	//		if let view = self.dequeueReusableCell(withIdentifier: id) {
	//			return view
	//		} else {
	//			self.register(classCell, forCellReuseIdentifier: id)
	//			return self.dequeueReusableCell(withIdentifier: id)
	//		}
	//	}
	
	func headerFromXIB(withIdentifier id: String) -> UITableViewHeaderFooterView? {
		if let view = self.dequeueReusableHeaderFooterView(withIdentifier: id) {
			return view
		} else {
			self.register(UINib(nibName: id, bundle: nil), forHeaderFooterViewReuseIdentifier: id)
			return self.dequeueReusableHeaderFooterView(withIdentifier: id)
		}
	}
}

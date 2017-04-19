/*
 *	LocalizedTextField.swift
 *	Sapphire
 *
 *	Created by Michael Douglas on 03/12/16.
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
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
class LocalizedTextField : UITextField {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	@IBInspectable var cornerRadius: CGFloat = 0.0
	@IBInspectable var strokeThikness: CGFloat = 0.0
	@IBInspectable var strokeColor: UIColor = UIColor.gray
	
	private lazy var originalFont: UIFont = {
		return self.font ?? UIFont.systemFont(ofSize: 12)
	}()
	
	override var text: String? {
		get {
			return super.attributedText?.string
		}
		
		set {
			self.attributedText = newValue?.localizedAttributed(for: self.originalFont)
		}
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func setupView() {
		self.text = self.text?.localized
		self.placeholder = self.placeholder?.localized
		
		let cgLayer = self.layer
		cgLayer.cornerRadius = self.cornerRadius
		cgLayer.borderWidth = self.strokeThikness
		cgLayer.borderColor = self.strokeColor.cgColor
		cgLayer.masksToBounds = true
		
		self.setValue(self.textColor, forKeyPath: "_placeholderLabel.textColor")
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************

//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.textRect(forBounds: bounds)
		return rect.insetBy(dx: 4.0, dy: 0.0)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.placeholderRect(forBounds: bounds)
		return rect.insetBy(dx: 4.0, dy: 0.0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		let rect = super.editingRect(forBounds: bounds)
		return rect.insetBy(dx: 4.0, dy: 0.0)
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
}

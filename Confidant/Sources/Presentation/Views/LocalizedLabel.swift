/*
 *	LocalizedLabel.swift
 *	Sapphire
 *
 *	Created by Michael Douglas on 07/11/16.
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
class LocalizedLabel : UILabel {

//**************************************************
// MARK: - Properties
//**************************************************
	
	private lazy var originalFont: UIFont = {
		return self.font
	}()

	override var text: String? {
		get {
			return super.attributedText?.string
		}
		
		set {
			self.attributedText = newValue?.localizedAttributed(for: self.originalFont)
            self.accessibilityHint = self.attributedText?.string
            self.accessibilityLabel = self.attributedText?.string
		}
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************
	
	convenience init(legendStyleWithText string: String) {
		self.init()
		self.font = UIFont.preferredFont(forTextStyle: .caption2)
		self.textColor = UIColor.lightGray
		self.numberOfLines = 1
		self.minimumScaleFactor = 0.7
		self.text = string
	}
	
//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func setupView() {
		self.text = self.text?.localized
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************

//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
}

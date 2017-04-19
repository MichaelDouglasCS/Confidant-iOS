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
class LocalizedButton : UIButton {

//**************************************************
// MARK: - Properties
//**************************************************
	
	@IBInspectable var numberOfLines: Int = 1
	@IBInspectable var underlineStroke: CGFloat = 0.0

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func setupView() {
		
		// Applying the localization for each preferred style
		let localizedStates: [UIControlState] = [ .normal, .disabled ]
		
		localizedStates.forEach {
			let localizedTitle = self.title(for: $0)?.localized
            
			self.setTitle(localizedTitle, for: $0)
            self.accessibilityHint = localizedTitle
            self.accessibilityLabel = localizedTitle
		}
		
		self.titleLabel?.numberOfLines = self.numberOfLines
		self.setBackgroundImage(self.backgroundImage(for: .normal)?.nineSliced(), for: .normal)
		
		// Underline routine once
		if self.underlineStroke > 0.0, let title = self.titleLabel?.text {
			let att = NSMutableAttributedString(string: title)
			let range = NSMakeRange(0, title.characters.count)
			
			att.addAttribute(NSUnderlineStyleAttributeName, value: self.underlineStroke, range: range)
			self.titleLabel?.attributedText = att
		}
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

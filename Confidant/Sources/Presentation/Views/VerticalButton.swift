/*
 *	VerticalButton.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 23/03/17.
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
class VerticalButton: LocalizedButton {

//**************************************************
// MARK: - Properties
//**************************************************

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func setupView() {
		let padding = CGFloat(6.0)
		let imageSize = self.imageView?.frame.size ?? CGSize(width: 0, height: 0)
		let titleSize = self.titleLabel?.frame.size ?? CGSize(width: 0, height: 0)
		let totalHeight = imageSize.height + titleSize.height + padding
		
		self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height),
		                                        titleSize.width * 0.5,
		                                        0.0,
		                                        0.0)
		
		self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
		                                        -imageSize.width,
		                                        -(totalHeight - titleSize.height),
		                                        0.0)
		
		self.setTitle(self.title(for: .normal)?.localized, for: .normal)
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

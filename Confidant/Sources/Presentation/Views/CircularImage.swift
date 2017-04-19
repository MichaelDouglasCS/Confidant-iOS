/*
 *	CircularImage.swift
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

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
class CircularImage : UIImageView {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBInspectable var borderColor: UIColor = UIColor.white
	@IBInspectable var borderWidth: CGFloat = 2.0
	@IBInspectable var cornerRadius: CGFloat = -1.0
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

//**************************************************
// MARK: - Exposed Methods
//**************************************************

	private func setupView() {
		
		let radius = self.cornerRadius
		let cgLayer = self.layer
		cgLayer.cornerRadius = radius < 0.0 ? (min(self.frame.width, self.frame.height) * 0.5) : radius
		cgLayer.borderColor = self.borderColor.cgColor
		cgLayer.borderWidth = self.borderWidth
		cgLayer.masksToBounds = true
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.setupView()
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

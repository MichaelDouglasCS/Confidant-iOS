/*
 *	UIBox.swift
 *	Harmony
 *
 *	Created by Diney on 06/11/16.
 *	Copyright 2016 Merck. All rights reserved.
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
class TiledView: UIView {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBInspectable var pattern: UIImage? = UIImage(named: "common_papaper_tile")
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func setupView() {
		
		if let image = self.pattern {
			self.backgroundColor = UIColor(patternImage: image)
		}
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************

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

//
//  RoundedSearchBar.swift
//  Confidant
//
//  Created by Michael Douglas on 10/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class RoundedSearchBar : LocalizedSearchBar {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBInspectable
	var borderColor: UIColor = .white {
		didSet {
			self.layer.borderColor = self.borderColor.cgColor
			self.setupView()
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat = 0.0 {
		didSet {
			self.layer.borderWidth = self.borderWidth
			self.setupView()
		}
	}
	
	@IBInspectable
	var cornerRadius: CGFloat = 0.0 {
		didSet {
			self.layer.cornerRadius = self.cornerRadius
			self.setupView()
		}
	}

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupView() {
		self.backgroundImage = UIImage()
		self.backgroundColor = UIColor.white
		self.clipsToBounds = true
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

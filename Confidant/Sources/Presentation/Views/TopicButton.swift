//
//  TopicButton.swift
//  Confidant
//
//  Created by Michael Douglas on 12/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
class TopicButton: IBDesigableButton {

//*************************************************
// MARK: - Properties
//*************************************************
	
	override var isSelected: Bool {
		didSet {
			self.setupView()
		}
	}

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupView() {
		
		if self.isSelected {
			self.borderColor = UIColor.Confidant.pink
			self.backgroundColor = UIColor.Confidant.pink
		} else {
			self.borderColor = UIColor.lightGray
			self.backgroundColor = UIColor.Confidant.condensedGray
		}
	}

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

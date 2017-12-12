/*
 *	LocalizedSegmentedControl.swift
 *	Harmony
 *
 *	Created by Diney on 22/01/17.
 *	Copyright 2017 Merck. All rights reserved.
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

class LocalizedSegmentedControl: UISegmentedControl {

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
		//self.text = self.text?.localized
		let count = self.numberOfSegments
		
		for i in 0..<count {
			let title = self.titleForSegment(at: i)
			self.setTitle(title?.localized, forSegmentAt: i)
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

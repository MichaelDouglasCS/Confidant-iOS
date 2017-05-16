/*
 *	LocalizedTabBar.swift
 *	Harmony
 *
 *	Created by Diney on 06/12/16.
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
class LocalizedTabBar : UITabBar {

//**************************************************
// MARK: - Properties
//**************************************************

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
	}

//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
//	override var topItem: UINavigationItem? {
//		let item = super.topItem
//		
//		return item
//	}
	
	override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
		items?.forEach {
			$0.title = $0.title?.localized
		}
		
		super.setItems(items, animated: animated)
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

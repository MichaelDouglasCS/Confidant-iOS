/*
 *	BlurredView.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 11/01/17.
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
class BlurredView : UIVisualEffectView {

//**************************************************
// MARK: - Properties
//**************************************************
	
	private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()

	@IBInspectable var colorTint: UIColor? {
		get { return self.getBlurValue(forKey: "colorTint") as? UIColor }
		set { self.setBlurValue(newValue, forKey: "colorTint") }
	}
	
	@IBInspectable var colorTintAlpha: CGFloat {
		get { return self.getBlurValue(forKey: "colorTintAlpha") as! CGFloat }
		set { self.setBlurValue(newValue, forKey: "colorTintAlpha") }
	}
	
	@IBInspectable var blurRadius: CGFloat {
		get { return self.getBlurValue(forKey: "blurRadius") as! CGFloat }
		set { self.setBlurValue(newValue, forKey: "blurRadius") }
	}
	
    @IBInspectable
	var blurrScale: CGFloat {
		get { return self.getBlurValue(forKey: "scale") as! CGFloat }
		set { self.setBlurValue(newValue, forKey: "scale") }
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func setupView() {
		self.blurrScale = 1
	}
	
	private func getBlurValue(forKey key: String) -> Any? {
		return self.blurEffect.value(forKeyPath: key)
	}
	
	private func setBlurValue(_ value: Any?, forKey key: String) {
		self.blurEffect.setValue(value, forKeyPath: key)
		self.effect = self.blurEffect
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

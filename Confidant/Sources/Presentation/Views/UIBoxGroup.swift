/*
 *	UIBoxGroup.swift
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
class UIBoxGroup: UIBox {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBInspectable var isFirst: Bool = false {
		didSet {
			if oldValue != self.isFirst {
				self.setupView()
			}
		}
	}
	
	@IBInspectable var isLast: Bool = false {
		didSet {
			if oldValue != self.isLast {
				self.setupView()
			}
		}
	}
	
	@IBInspectable var lineColor: UIColor? {
		didSet {
			if oldValue != self.lineColor {
				self.setupView()
			}
		}
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func setupView() {
		
		let caLayer = self.layer
		let radiusArea = self.shadowRadius * 2.0
		let radii = CGSize(width: self.cornerRadius, height: self.cornerRadius)
		var corners: UIRectCorner = []
		var rect = self.bounds
		rect.origin.x -= radiusArea
		rect.size.width += radiusArea * 2.0
		
		if self.isFirst {
			corners.insert([.topLeft, .topRight])
			rect.origin.y -= radiusArea
			rect.size.height += radiusArea
		}
		
		if self.isLast {
			corners.insert([.bottomLeft, .bottomRight])
			rect.size.height += radiusArea
		}
		
		// The shadow will have the same frame as the bounds
		let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
		let shadowMask = CAShapeLayer()
		shadowMask.frame = self.bounds
		shadowMask.path = path.cgPath
		
		// The shadow's holder will present the correct corner and background color
		let sublayer = CALayer()
		sublayer.frame = self.bounds
		sublayer.backgroundColor = self.backgroundColor?.cgColor
		sublayer.shadowColor = self.shadowColor.cgColor
		sublayer.shadowOffset = self.shadowOffset
		sublayer.shadowRadius = self.shadowRadius
		sublayer.shadowOpacity = 1.0
		sublayer.shadowPath = path.cgPath
		sublayer.mask = shadowMask
		
		// The visible mas will clips the current layer in order to hide undesired shadows
		let visiblePath = UIBezierPath(rect: rect)
		let visibleMask = CAShapeLayer()
		visibleMask.frame = self.bounds
		visibleMask.path = visiblePath.cgPath
		
		// The separation line will be added only to non-last elements
		if let color = self.lineColor, !self.isLast {
			let line = CALayer()
			var lineFrame = self.bounds
			
			lineFrame.origin.y = lineFrame.size.height - 1.0
			lineFrame.size.height = 1.0
			line.frame = lineFrame
			line.backgroundColor = color.cgColor
			sublayer.sublayers = [line]
		}
		
		caLayer.mask = visibleMask
		caLayer.shadowPath = nil
		caLayer.sublayers = [sublayer]
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

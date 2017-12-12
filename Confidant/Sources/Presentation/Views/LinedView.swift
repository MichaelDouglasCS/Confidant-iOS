/*
 *	LinedView.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 04/04/17.
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
class LinedView: UIView {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBInspectable var lineColor: UIColor = UIColor.lightGray
	@IBInspectable var lineWidth: CGFloat = 0.5
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

//**************************************************
// MARK: - Exposed Methods
//**************************************************

//**************************************************
// MARK: - Overridden Methods
//**************************************************

	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let aPath = UIBezierPath()
		self.lineColor.set()
		
		aPath.move(to: CGPoint(x: 0.0, y: self.frame.size.height))
		aPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
		aPath.lineWidth = self.lineWidth
		aPath.close()
		aPath.stroke()
		aPath.fill()
	}
}

/*
 *	DisclosureView.swift
 *	Harmony
 *
 *	Created by Diney on 04/12/16.
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
class DisclosureView: UIView {
	
	enum Direction: Int {
		case left, right, up, down
	}
	
//**************************************************
// MARK: - Properties
//**************************************************

	var direction: DisclosureView.Direction = .right
	
	@IBInspectable var lineWidth: CGFloat = 2.0
	@IBInspectable var lineColor: UIColor = UIColor.blue
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func draw(_ rect: CGRect) {
		
		let bezierPath = UIBezierPath()
		let rect = self.bounds.insetBy(dx: self.lineWidth * 0.5, dy: self.lineWidth * 0.5)
		
		switch self.direction {
			case .left:
				bezierPath.move(to: CGPoint(x: rect.maxX, y: rect.minY))
				bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
				bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			case .right:
				bezierPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
				bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
				bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			case .down:
				bezierPath.move(to: CGPoint(x: rect.minX, y: rect.minY))
				bezierPath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
				bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
			case .up:
				bezierPath.move(to: CGPoint(x: rect.minX, y: rect.maxY))
				bezierPath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
				bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		}
		
		self.lineColor.setStroke()
		bezierPath.lineCapStyle = .butt
		bezierPath.lineJoinStyle = .miter
		bezierPath.lineWidth = self.lineWidth
		bezierPath.stroke()
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
class DisclosureHorizontal: DisclosureView {
	
	@IBInspectable var isRight: Bool = true {
		didSet {
			self.direction = (self.isRight) ? .right : .left
			self.backgroundColor = UIColor.clear
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

@IBDesignable
class DisclosureVertical: DisclosureView {
	
	@IBInspectable var isUp: Bool = true {
		didSet {
			self.direction = (self.isUp) ? .up : .down
			self.backgroundColor = UIColor.clear
		}
	}
}

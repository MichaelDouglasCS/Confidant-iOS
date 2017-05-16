/*
 *	ChartColumnView.swift
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

@IBDesignable
class ChartColumnView : UIView {

//**************************************************
// MARK: - Properties
//**************************************************

	@IBInspectable var fillColor: UIColor = UIColor.red.withAlphaComponent(0.05)
	@IBInspectable var lineColor: UIColor = UIColor.red
	@IBInspectable var lineStroke: CGFloat = 1.0
	@IBInspectable var useGPU: Bool = true
	@IBInspectable var value: CGFloat = 1.0

	var bezierPath: UIBezierPath {
		let current = self.value.clamped(min: 0.0, max: 1.0)
		let size = self.bounds.size
		let start = (1.0 - current) * size.height
		
		let path = UIBezierPath()
		path.move(to: CGPoint(x: 0.0, y: start))
		path.addLine(to: CGPoint(x: size.width, y: start))
		
		return path
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

	private func setupView() {
		
		if !self.useGPU {
			let size = self.bounds.size
			let path = self.bezierPath
			
			let line = CAShapeLayer()
			line.frame = self.bounds
			line.lineWidth = self.lineStroke
			line.strokeColor = self.lineColor.cgColor
			line.path = path.cgPath
			
			path.addLine(to: CGPoint(x: size.width, y: size.height))
			path.addLine(to: CGPoint(x: 0.0, y: size.height))
			
			let fill = CAShapeLayer()
			fill.frame = self.bounds
			fill.fillColor = self.fillColor.cgColor
			fill.path = path.cgPath
			
			self.layer.sublayers = [line, fill]
		}
		
		self.backgroundColor = UIColor.clear
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************

//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func draw(_ rect: CGRect) {
		if self.useGPU {
			let size = self.bounds.size
			
			let line = self.bezierPath
			self.lineColor.set()
			line.stroke()
			
			let fill = self.bezierPath
			fill.addLine(to: CGPoint(x: size.width, y: size.height))
			fill.addLine(to: CGPoint(x: 0.0, y: size.height))
			self.fillColor.set()
			fill.fill()
		}
		
		super.draw(rect)
	}
	
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

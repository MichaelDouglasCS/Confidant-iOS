/*
 *	MathKit.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 14/11/16.
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
// MARK: - Extension - CGPoint
//
//**********************************************************************************************************

extension CGPoint {
	
	func distance(to: CGPoint) -> CGFloat {
		
		let xDist = to.x - self.x
		let yDist = to.y - self.y
		let distance = sqrt((xDist * xDist) + (yDist * yDist))
		
		return distance
	}
    
}

//**********************************************************************************************************
//
// MARK: - Extension - Comparable
//
//**********************************************************************************************************

extension Comparable {
	func clamped(min: Self, max: Self) -> Self {
		let value = (self < min) ? min : self
		return (self > max) ? max : value
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - FloatingPoint
//
//**********************************************************************************************************

extension FloatingPoint {
	var degreesToRadians: Self { return self * .pi / 180 }
	var radiansToDegrees: Self { return self * 180 / .pi }
}

//**********************************************************************************************************
//
// MARK: - Extension - Sequence
//
//**********************************************************************************************************

extension Sequence where Self.Iterator.Element : Hashable {
	
	var frequencies: [(Self.Iterator.Element, Int)] {
		var frequency: [Self.Iterator.Element : Int] = [:]
		
		self.forEach {
			frequency[$0] = (frequency[$0] ?? 0) + 1
		}
		
		return frequency.sorted { $0.1 > $1.1 }
	}
}

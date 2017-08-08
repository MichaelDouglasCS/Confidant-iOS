/*
 *	KeyboardToolbar.swift
 *	Sapphire
 *
 *	Created by Michael Douglas on 05/12/16.
 *	Copyright 2017 Watermelon. All rights reserved.
 */

import UIKit
//import AKImageKit

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

fileprivate struct KeyboardSizes {
	static let phonePortrait: CGFloat = 216.0
	static let phoneLandscape: CGFloat = 162.0
	static let padPortrait: CGFloat = 264.0
	static let padLandscape: CGFloat = 352.0
	
	static var currentHeight: CGFloat {
		
		let orientation = UIApplication.shared.statusBarOrientation
		let isPad = UIDevice.current.userInterfaceIdiom == .pad
		var height: CGFloat = 0.0
		
		if orientation.isLandscape {
			height = isPad ? self.padLandscape : self.phoneLandscape
		} else {
			height = isPad ? self.padPortrait : self.phonePortrait
		}
		
		return height
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class KeyboardToolbar : UIToolbar {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	private lazy var arrowButtons: [UIBarButtonItem] = {
		
		let prevSel = #selector(self.toolbarDidPrevious(_:))
		let nextSel = #selector(self.toolbarDidNext(_:))
		let prevImg = UIImage(named: "btn_left_chevron")
		let nextImg = UIImage(named: "btn_right_chevron")
		let previous = UIBarButtonItem(image: prevImg, style: .done, target: self, action: prevSel)
		let next = UIBarButtonItem(image: nextImg, style: .done, target: self, action: nextSel)
		
		previous.width = 30.0
		next.width = 30.0
		
		return [previous, next]
	}()
	
	private lazy var baseButtons: [UIBarButtonItem] = {
		
		let doneSel = #selector(self.toolbarDidDone(_:))
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSel)
		
		return [space, done]
	}()
	
	static let instance: KeyboardToolbar = {
		
		let toolbar = KeyboardToolbar()
		toolbar.barStyle = .default
		toolbar.isTranslucent = false
		toolbar.tintColor = UIColor.blue
		toolbar.sizeToFit()
		toolbar.items = toolbar.arrowButtons + toolbar.baseButtons
		
		return toolbar
	}()
	
//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	@objc private func toolbarDidDone(_ sender: Any) {
		UIView.firstResponder?.resignFirstResponder()
	}
	
	@objc private func toolbarDidNext(_ sender: Any) {
		UIView.firstResponder?.nextView?.becomeFirstResponder()
		self.checkArrows()
	}
	
	@objc private func toolbarDidPrevious(_ sender: Any) {
		UIView.firstResponder?.previousView?.becomeFirstResponder()
		self.checkArrows()
	}
	
	private func checkArrows() {
		
		if let currentResponder = UIView.firstResponder,
			currentResponder.responds(to: #selector(getter: previousView)) {
			
			let hasPrevious = currentResponder.previousView != nil
			let hasNext = currentResponder.nextView != nil
			let finalItems: [UIBarButtonItem]
			
			if !hasPrevious && !hasNext {
				finalItems = self.baseButtons
			} else {
				finalItems = self.arrowButtons + self.baseButtons
			}
			
			self.arrowButtons[0].isEnabled = hasPrevious
			self.arrowButtons[1].isEnabled = hasNext
			self.setItems(finalItems, animated: true)
		}
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override public func didMoveToSuperview() {
		super.didMoveToSuperview()
		
		if self.superview != nil {
			self.checkArrows()
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UIView
//
//**********************************************************************************************************

extension UIView {
	
	var firstResponder: UIView? {
		
		if self.isFirstResponder {
			return self
		}
		
		for view in self.subviews {
			if let firstResponder = view.firstResponder {
				return firstResponder
			}
		}
		
		return nil
	}
	
	class var firstResponder: UIView? {
		
		for window in UIApplication.shared.windows {
			if let firstResponder = window.firstResponder {
				return firstResponder
			}
		}
		
		return nil
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UIScrollView
//
//**********************************************************************************************************

extension UIScrollView {
	
	@objc private func tapOutside() {
		UIView.firstResponder?.resignFirstResponder()
	}
	
	func makeTapGestureResignFirstResponder() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOutside))
		tap.cancelsTouchesInView = false
		self.addGestureRecognizer(tap)
	}
	
	func scrollToOffset(for view: UIView, animated: Bool = true) {
		
		// Algorithm to calculate the visible portion necessary to show the view. It must be a subview.
		if let window = view.window {
			let frameInWindow = self.convert(window.frame, from: window)
			let toHeight = frameInWindow.size.height - KeyboardSizes.currentHeight
			let point = view.convert(CGPoint.zero, to: self)
			let topInset = self.contentInset.top
			var offsetY = point.y - (toHeight * 0.5)
			offsetY = (offsetY < -topInset) ? -topInset : offsetY
			self.setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
		}
	}
}

extension UIViewController {
    
    @objc private func tapOutside() {
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    func makeTapGestureEndEditing() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.tapOutside))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
}

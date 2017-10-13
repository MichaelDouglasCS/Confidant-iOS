/*
 *	Cells.swift
 *	MApLE
 *
 *	Created by Diney on 01/12/16.
 *	Copyright 2017 IBM. All rights reserved.
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

struct CellID {
	
}

enum ItemAction {
	case didChangeValue
	case didChangeLayout
	case willTakePicture
	case willShowDrillDown
	case willShowPreparation
	case willPresentDirections
}

protocol ItemActionDelegate : class {
	func handleAction(_ action: ItemAction, from sender: AnyObject)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ActionableCell : UITableViewCell {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	private var isBuildingAction: Bool = false
	
	/**
	[VIRTUAL]
	Each subclass of this class will override this routine in order to return a new actionView.
	*/
	var actionView: UIView {
		return UIView()
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************

//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	/**
	This function triggers an asynchronous process that will end up adding a subview in this cell.
	It's a single UIView containg all the subactions' buttons. After that single view being added,
	the cell will return to its normal context, so there is no need to call "endActionContext".
	*/
	func beginActionContext() {
		self.isBuildingAction = true
	}
	
	static func makeDeleteView(corner: CGFloat, offset: UIEdgeInsets) -> UIView {
		let size = (corner * 2.0) + max(offset.top + offset.bottom, offset.left + offset.right)
		let view = UIView(frame: CGRect(x: 0, y: 0, width: size, height: size))
		
		view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
		view.isUserInteractionEnabled = false
		
		return view
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override func didAddSubview(_ subview: UIView) {
		super.didAddSubview(subview)
		
		if self.isBuildingAction {
			subview.backgroundColor = UIColor.clear
			
			for innerView in subview.subviews {
				if let button = innerView as? UIButton {
					let view = self.actionView
					view.frame = button.bounds
					button.backgroundColor = UIColor.clear
					button.insertSubview(view, at: 0)
				}
			}
			
			self.isBuildingAction = false
		}
	}
}

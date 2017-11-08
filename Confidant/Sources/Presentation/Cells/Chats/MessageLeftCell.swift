//
//  MessageLeftCell.swift
//  Confidant
//
//  Created by Michael Douglas on 07/11/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

extension CellID {
	static var messageLeft = String(describing: MessageLeftCell.self)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class MessageLeftCell: MessageBaseCell {

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
	override func updateLayout(for model: MessageBO?) {
		super.updateLayout(for: model)
	}
}

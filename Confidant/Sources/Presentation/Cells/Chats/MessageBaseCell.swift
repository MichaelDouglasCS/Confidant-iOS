//
//  MessageBaseCell.swift
//  Confidant
//
//  Created by Michael Douglas on 07/11/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class MessageBaseCell: UITableViewCell {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var contentLabel: LocalizedLabel!
	@IBOutlet weak var timeLabel: LocalizedLabel!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	func updateLayout(for model: MessageBO?) {
		
		if let model = model {
			self.contentLabel.text = model.content
			self.timeLabel.text = Date(timeIntervalSince1970: model.timestamp ?? 0).stringLocal(time: .short)
		}
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
}

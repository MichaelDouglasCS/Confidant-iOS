//
//  KnowledgeCell.swift
//  Confidant
//
//  Created by Michael Douglas on 12/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

extension CellID {
	static let knowledgeCell = String(describing: KnowledgeCell.self)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class KnowledgeCell: UICollectionViewCell {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var topicButton: TopicButton!
	
	override var isSelected: Bool {
		didSet {
			self.topicButton.isSelected = self.isSelected
		}
	}

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	func updateLayout(for model: KnowledgeBO?) {
		
		if let knowledge = model {
			self.topicButton.setTitle(knowledge.topic, for: .normal)
		}
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
}

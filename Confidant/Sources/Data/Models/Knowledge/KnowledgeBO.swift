//
//  KnowledgeBO.swift
//  Confidant
//
//  Created by Michael Douglas on 12/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import ObjectMapper

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

public class KnowledgeBO: Mappable {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var id: String?
	public var topic: String?
	
//*************************************************
// MARK: - Constructors
//*************************************************
	
	public required init() { }
	
	public required init?(map: Map) { }
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func mapping(map: Map) {
		self.id <- map["id"]
		self.topic <- map["topic"]
	}
}

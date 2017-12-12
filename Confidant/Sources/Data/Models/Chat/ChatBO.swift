//
//  ChatBO.swift
//  Confidant
//
//  Created by Michael Douglas on 27/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import ObjectMapper

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class ChatBO: Mappable {

//*************************************************
// MARK: - Properties
//*************************************************
	
	public var id: String?
	public var createdDate: TimeInterval?
	public var updatedDate: TimeInterval?
	public var userProfile: ChatProfileBO?
	public var confidantProfile: ChatProfileBO?
	public var reason: String?
	public var knowledge: KnowledgeBO?
	public var messages: [MessageBO]?

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
		self.createdDate <- map["createdDate"]
		self.updatedDate <- map["updatedDate"]
		self.userProfile <- map["userProfile"]
		self.confidantProfile <- map["confidantProfile"]
		self.reason <- map["reason"]
		self.knowledge <- map["knowledge"]
		self.messages <- map["messages"]
	}
}

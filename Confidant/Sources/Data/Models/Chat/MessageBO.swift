//
//  MessageBO.swift
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

public class MessageBO: Mappable {

//*************************************************
// MARK: - Properties
//*************************************************
	
	public var id: String?
	public var chatID: String?
	public var timestamp: TimeInterval?
	public var recipientID: String?
	public var senderID: String?
	public var content: String?
	public var isSended: Bool?
	public var isReceived: Bool?
	public var isReaded: Bool?

//*************************************************
// MARK: - Constructors
//*************************************************

	public required init() { }
	
	public required init?(map: Map) { }
	
	public convenience init(id: String?,
	                        chatID: String?,
	                        timestamp: TimeInterval?,
	                        recipientID: String?,
	                        senderID: String?,
	                        content: String?) {
		self.init()
		self.id = id
		self.chatID = chatID
		self.timestamp = timestamp
		self.recipientID = recipientID
		self.senderID = senderID
		self.content = content
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************

	public func mapping(map: Map) {
		self.id <- map["id"]
		self.chatID <- map["chatID"]
		self.timestamp <- map["timestamp"]
		self.recipientID <- map["recipientID"]
		self.senderID <- map["senderID"]
		self.content <- map["content"]
		self.isSended <- map["isSended"]
		self.isReceived <- map["isReceived"]
		self.isReaded <- map["isReaded"]
	}
}

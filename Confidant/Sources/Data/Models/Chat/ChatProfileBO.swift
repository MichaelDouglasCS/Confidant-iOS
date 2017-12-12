//
//  ChatProfileBO.swift
//  Confidant
//
//  Created by Michael Douglas on 28/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import ObjectMapper

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class ChatProfileBO: Mappable {

//*************************************************
// MARK: - Properties
//*************************************************

	public var id: String?
	public var nickname: String?
	public var picture: MediaBO?
	
//*************************************************
// MARK: - Constructors
//*************************************************

	public required init() { }
	
	public required init?(map: Map) { }
	
	public convenience init(id: String?,
	                        nickname: String?,
	                        picture: MediaBO?) {
		self.init()
		self.id = id
		self.nickname = nickname
		self.picture = picture
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func mapping(map: Map) {
		self.id	<- map["id"]
		self.nickname <- map["nickname"]
		self.picture <- map["picture"]
	}
}

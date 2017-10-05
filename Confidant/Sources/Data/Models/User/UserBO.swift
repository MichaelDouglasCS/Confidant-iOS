//
//  UserBO.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import ObjectMapper

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

public class UserBO: Mappable {

//*************************************************
// MARK: - Properties
//*************************************************

    public var id: String?
	public var email: String?
	public var password: String?
	public var createdDate: TimeInterval?
	public var token: String?
	public var profile: ProfileBO = ProfileBO()
	
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
		self.email <- map["email"]
		self.password <- map["password"]
		self.createdDate <- map["createdDate"]
		self.token <- map["token"]
		self.profile <- map["profile"]
	}
}

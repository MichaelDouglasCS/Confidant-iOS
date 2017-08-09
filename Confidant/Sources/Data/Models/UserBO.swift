//
//  UserBO.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SwiftyJSON

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

public class UserBO : ModelBO {

//*************************************************
// MARK: - Properties
//*************************************************

    public var id: String = ""
	public var createdDate: TimeInterval = 0
    public var email: String = ""
	public var password: String = ""
	public var profile: ProfileBO = ProfileBO()
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

//*************************************************
// MARK: - Exposed Methods
//*************************************************

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

	override public func decodeJSON(json: JSON) {
		
		self.id = json["id"].stringValue
		self.createdDate = json["createdDate"].doubleValue
		self.email = json["email"].stringValue
		self.password = json["password"].stringValue
		self.profile = ProfileBO(json: json["profile"])
	}
	
	override public func encodeJSON() -> JSON {
		
		var json: JSON = ["id": self.id as AnyObject,
		                  "createdDate": self.createdDate as AnyObject,
		                  "email": self.email as AnyObject,
		                  "password": self.password as AnyObject]
		
		json["profile"] = self.profile.encodeJSON()
		
		return json
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

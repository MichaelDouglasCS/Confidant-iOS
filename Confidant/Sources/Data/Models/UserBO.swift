//
//  UserBO.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseAuth

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
	
	public func decodeFacebook(json: JSON) {
		
		self.email = json["email"].stringValue
		self.profile.name = json["name"].stringValue
		self.profile.birthdate = json["birthday"].stringValue
		self.profile.gender = json["gender"].stringValue
		self.profile.picture = json["picture"].stringValue
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

	override public func decodeJSON(json: JSON) {
		
		self.id = json["id"].stringValue
		self.email = json["email"].stringValue
		self.password = json["password"].stringValue
		self.profile = ProfileBO(json: json["profile"])
	}
	
	override public func encodeJSON() -> JSON {
		
		var json: JSON = ["id" : self.id as AnyObject,
		                  "email" : self.email as AnyObject,
		                  "password" : self.password as AnyObject]
		
		json["profile"] = self.profile.encodeJSON()
		
		return json
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

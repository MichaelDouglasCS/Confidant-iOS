//
//  UserVO.swift
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

public class UserVO : ModelVO {

//*************************************************
// MARK: - Properties
//*************************************************

    public var id: String = ""
    public var email: String = ""
	public var password: String = ""
	public var profile: ProfileVO = ProfileVO()
	
//*************************************************
// MARK: - Constructors
//*************************************************
    
//*************************************************
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************

	override public func decodeJSON(json: JSON) {
		
		self.id = json["id"].stringValue
		self.email = json["email"].stringValue
		self.password = json["password"].stringValue
		self.profile = ProfileVO(json: json["profile"])
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

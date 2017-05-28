//
//  ProfileVO.swift
//  Confidant
//
//  Created by Michael Douglas on 22/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class ProfileVO : ModelVO {

	public enum UserKind : String {
		case user = "USER"
		case confidant = "CONFIDANT"
	}
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var name: String = ""
	public var birthdate: String?
	public var gender: String?
	public var userKind: ProfileVO.UserKind = .user
	public var picture: String?

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	override public func decodeJSON(json: JSON) {
		
		self.name = json["name"].stringValue
		self.birthdate = json["birthdate"].string
		self.gender = json["gender"].string
		self.userKind = UserKind(rawValue: json["userKind"].stringValue) ?? .user
		self.picture = json["picture"].string
	}
	
	override public func encodeJSON() -> JSON {
		
		var json: JSON = ["name" : self.name as AnyObject]
		
		json["userKind"] = JSON(self.userKind.rawValue)
		
		if let birthdate = self.birthdate {
			json["birthdate"] = JSON(birthdate)
		}
		
		if let gender = self.gender {
			json["gender"] = JSON(gender)
		}
		
		if let picture = self.picture {
			json["picture"] = JSON(picture)
		}
		
		return json
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

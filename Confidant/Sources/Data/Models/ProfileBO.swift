//
//  ProfileBO.swift
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

public class ProfileBO : ModelBO {

	public enum TypeOfUser : String {
		case user = "User"
		case confidant = "Confidant"
	}
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var name: String = ""
	public var birthdate: String = ""
	public var gender: String = ""
	public var typeOfUser: ProfileBO.TypeOfUser = .user

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
		self.birthdate = json["birthdate"].stringValue
		self.gender = json["gender"].stringValue
		self.typeOfUser = TypeOfUser(rawValue: json["typeOfUser"].stringValue) ?? .user
	}
	
	override public func encodeJSON() -> JSON {
		
		var json: JSON = ["name": self.name as AnyObject,
		                  "birthdate": self.birthdate as AnyObject,
		                  "gender": self.gender as AnyObject]
		
		json["typeOfUser"] = JSON(self.typeOfUser.rawValue)
		
		return json
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

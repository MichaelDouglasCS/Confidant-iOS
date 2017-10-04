//
//  ProfileBO.swift
//  Confidant
//
//  Created by Michael Douglas on 22/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import ObjectMapper

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

public class ProfileBO: Mappable {

	public enum TypeOfUser: String {
		case user = "User"
		case confidant = "Confidant"
	}
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var name: String?
	public var nickname: String?
	public var pictureURL: String?
	public var birthdate: String?
	public var gender: String?
	public var typeOfUser: ProfileBO.TypeOfUser?

//*************************************************
// MARK: - Constructors
//*************************************************
	
	public required init() { }
	
	public required init?(map: Map) { }

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func mapping(map: Map) {
		self.name <- map["name"]
		self.nickname <- map["nickname"]
		self.pictureURL <- map["pictureURL"]
		self.birthdate <- map["birthdate"]
		self.gender <- map["gender"]
		self.typeOfUser <- map["typeOfUser"]
	}
}

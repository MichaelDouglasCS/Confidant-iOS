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
	public var picture: MediaBO?
	public var birthdate: String?
	public var gender: String?
	public var typeOfUser: ProfileBO.TypeOfUser?
	public var knowledges: [KnowledgeBO] = []

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
		self.picture <- map["picture"]
		self.birthdate <- map["birthdate"]
		self.gender <- map["gender"]
		self.typeOfUser <- map["typeOfUser"]
		self.knowledges <- map["knowledges"]
	}
}

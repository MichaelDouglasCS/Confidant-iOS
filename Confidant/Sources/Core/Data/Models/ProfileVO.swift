//
//  ProfileVO.swift
//  Confidant
//
//  Created by Michael Douglas on 22/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

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

public class ProfileVO : Parsable {

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
	
	public required init() { }

//*************************************************
// MARK: - Protected Methods
//*************************************************

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func parsing(_ parser: Parser) {
		self.name <-> parser["name"]
		self.birthdate <-> parser["birthdate"]
		self.gender <-> parser["gender"]
		self.userKind <-> parser["userKind"]
		self.picture <-> parser["picture"]
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************
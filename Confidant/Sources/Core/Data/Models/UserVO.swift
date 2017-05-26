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

public class UserVO : Parsable {

//*************************************************
// MARK: - Properties
//*************************************************

    public var id: String = ""
    public var email: String?
	public var profile: ProfileVO = ProfileVO()
	
//*************************************************
// MARK: - Constructors
//*************************************************
    
	public required init() { }
    
//*************************************************
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************

	public func parsing(_ parser: Parser) {
		self.id <-> parser["id"]
		self.email <-> parser["email"]
		self.profile <-> parser["profile"]
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

extension UserVO {
	
	public convenience init(firUser: FIRUser,
	                        name: String,
	                        birthdate: String,
	                        gender: String) {
		self.init()
		
		self.id = firUser.uid
		self.email = firUser.email
		self.profile.name = name
		self.profile.birthdate = birthdate
		self.profile.gender = gender
		self.profile.userKind = .user
		self.profile.picture = firUser.photoURL?.absoluteString
	}
	
	public convenience init(facebookJSON: JSON) {
		self.init()
		
		self.email = facebookJSON["email"].string
		self.profile.name = facebookJSON["name"].stringValue
		self.profile.birthdate = facebookJSON["birthday"].string
		self.profile.gender = facebookJSON["gender"].string
		self.profile.userKind = .user
		self.profile.picture = facebookJSON["picture"].string
	}
}

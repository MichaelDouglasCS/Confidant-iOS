//
//  UserVO.swift
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

class UserVO : NSObject {

//*************************************************
// MARK: - Properties
//*************************************************

    public var userId: String?
    public var email: String?
    public var nickName: String?
    public var dateOfBirth: String?
    public var gender: String?
    public var photoURL: String?
    
//*************************************************
// MARK: - Constructors
//*************************************************
    
    override init() {
        
    }

    init(userId: String?,
         email: String?,
         nickName: String?,
         dateOfBirth: String?,
         gender: String?,
         photoURL: String?) {
        self.userId = userId ?? ""
        self.email = email ?? ""
        self.nickName = nickName ?? ""
        self.dateOfBirth = dateOfBirth ?? ""
        self.gender = gender ?? ""
        self.photoURL = photoURL ?? ""
    }
    
//*************************************************
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
    public func decodeJSON(fromFacebook: JSON) {
        self.email = fromFacebook["email"].string
        self.nickName = fromFacebook["name"].string
        self.dateOfBirth = fromFacebook["birthday"].string
        self.gender = fromFacebook["gender"].string
        self.photoURL = fromFacebook["picture"].string
    }
    
    public func encodeJSON() -> JSON {
        let json: JSON = ["email" : self.email as AnyObject,
                          "nickName" : self.nickName as AnyObject,
                          "dateOfBirth" : self.dateOfBirth as AnyObject,
                          "gender" : self.gender as AnyObject,
                          "photoURL" : self.photoURL as AnyObject]
        return json
    }
    
    public func encodeAccountEmailJSON() -> JSON {
        let accountJSONValue: JSON = ["email" : self.email as AnyObject]
        return accountJSONValue
    }

//*************************************************
// MARK: - Override Public Methods
//*************************************************

}

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

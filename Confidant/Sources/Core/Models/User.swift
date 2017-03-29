//
//  User.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation

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

typealias JSON = [String: AnyObject]

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class User : NSObject {

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
        self.email = fromFacebook["email"] as? String ?? ""
        self.nickName = fromFacebook["name"] as? String ?? ""
        self.dateOfBirth = fromFacebook["birthday"] as? String ?? ""
        self.gender = fromFacebook["gender"] as? String ?? ""
        self.photoURL = fromFacebook["picture"] as? String ?? ""
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

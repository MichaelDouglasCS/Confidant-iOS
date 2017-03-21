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

typealias FirebaseJSON = [String: String]

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class User: NSObject {

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
// MARK: - Self Public Methods
//*************************************************
    
    func getJSON() -> FirebaseJSON {
        let userJSONValue: FirebaseJSON = ["email": self.email ?? "",
                             "nickName": self.nickName ?? "",
                             "dateOfBirth": self.dateOfBirth ?? "",
                             "gender": self.gender ?? "",
                             "photoURL": self.photoURL ?? ""]
        return userJSONValue
    }
    
    func getAccountEmail() -> FirebaseJSON {
        let accountJSONValue: FirebaseJSON = ["email": self.email ?? ""]
        return accountJSONValue
    }
    
//*************************************************
// MARK: - Private Methods
//*************************************************

//*************************************************
// MARK: - Internal Methods
//*************************************************

//*************************************************
// MARK: - Override Public Methods
//*************************************************

}

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

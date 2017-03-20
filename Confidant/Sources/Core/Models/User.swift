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

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class User: NSObject {

//*************************************************
// MARK: - Properties
//*************************************************

    private var userId: String?
    private var email: String?
    private var name: String?
    private var userName: String?
    private var dateOfBirth: String?
    private var gender: String?
    private var photoURL: String?
    
//*************************************************
// MARK: - Constructors
//*************************************************

    init(userId: String?,
         email: String?,
         name: String?,
         userName: String?,
         dateOfBirth: String?,
         gender: String?,
         photoURL: String?) {
        self.userId = userId ?? ""
        self.email = email ?? ""
        self.name = name ?? ""
        self.userName = userName ?? ""
        self.dateOfBirth = dateOfBirth ?? ""
        self.gender = gender ?? ""
        self.photoURL = photoURL ?? ""
    }
    
//*************************************************
// MARK: - Self Public Methods
//*************************************************
    
    func getJSON() -> [String: String] {
        let userJSONValue: [String: String] = ["email": self.email ?? "",
                             "name": self.name ?? "",
                             "userName": self.userName ?? "",
                             "dateOfBirth": self.dateOfBirth ?? "",
                             "gender": self.gender ?? "",
                             "photoURL": self.photoURL ?? ""]
        return userJSONValue
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

//
//  PersistenceManager.swift
//  Confidant
//
//  Created by Michael Douglas on 19/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import FirebaseDatabase

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

public let kUsersTableName = "users"
public let kAccountTableName = "accounts"

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

class PersistenceManager {

//*************************************************
// MARK: - Properties
//*************************************************

    static var databaseReference: FIRDatabaseReference {
        get {
            return FIRDatabase.database().reference(fromURL: URLs.databaseURL())
        }
    }

//*************************************************
// MARK: - Enum
//*************************************************
    
    enum FirebaseDBTables {
        case Users(user: User)
        case Accounts(userEmailSha1: String)
        func reference() -> FIRDatabaseReference {
            switch self {
            case .Users(let user):
                return PersistenceManager.databaseReference.child(kUsersTableName).child(user.userId!)
            case .Accounts(let userEmailSha1):
                return PersistenceManager.databaseReference.child(kAccountTableName).child(userEmailSha1)
            }
        }
    }
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
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

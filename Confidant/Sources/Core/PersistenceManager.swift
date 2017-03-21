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
// MARK: - Enum -
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
            return FIRDatabase.database().reference(fromURL: URL.databaseURL())
        }
    }
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Public Methods
//*************************************************
    
    func createUser() {
        
    }
    
//*************************************************
// MARK: - Enum
//*************************************************
    
    enum FirebaseDBTables {
        case Users(user: User)
        case Accounts
        func reference() -> FIRDatabaseReference {
            switch self {
            case .Users(let user):
                return PersistenceManager.databaseReference.child(kUsersTableName).child(user.userId!)
            case .Accounts:
                return PersistenceManager.databaseReference.child(kAccountTableName)
            }
        }
    }

//*************************************************
// MARK: - Self Public Methods
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
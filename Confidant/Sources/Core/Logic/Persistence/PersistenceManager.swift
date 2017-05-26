//
//  PersistenceManager.swift
//  Confidant
//
//  Created by Michael Douglas on 19/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

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

public struct PersistenceManager {
    
    enum FirebaseDBTables {
        case Users(userId: String)
        case Accounts(userEmailEncrypted: String)
		
//        func reference() -> FIRDatabaseReference {
//            switch self {
//            case .Users(let userId):
//                return self.firebaseDB.child("users").child(userId)
//            case .Accounts(let email):
//                return PersistenceManager.firebaseDB.child("accounts").child(email)
//            }
//        }
    }

//*************************************************
// MARK: - Properties
//*************************************************

    private lazy var firebaseDB: FIRDatabaseReference = {
		return FIRDatabase.database().reference(fromURL: URLs.database())
    }()

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//    func create(user: UserVO, completionHandler: @escaping LogicResult) {
//        PersistenceManager.FirebaseDBTables.Accounts(userEmailEncrypted: (user.email?.toSHA1())!).reference().updateChildValues(user.encodeAccountEmailJSON(), withCompletionBlock: { (error, accountResult) in
//            if error == nil {
//                PersistenceManager.FirebaseDBTables.Users(userId: user.userId!).reference().updateChildValues(user.encodeJSON(), withCompletionBlock: {
//                    (error, userResult) in
//                    if error == nil {
//                        completion(.Success, error)
//                    } else {
//                        completion(.Failed, error)
//                    }
//                })
//            } else {
//                completion(.Failed, error)
//            }
//        })
//    }
//	
//	public func update() {
//		self.firebaseDB.childByAutoId().remove
//	}
	
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

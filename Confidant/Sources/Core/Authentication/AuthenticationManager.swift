//
//  AuthenticationManager.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
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

class AuthenticationManager {

//*************************************************
// MARK: - Properties
//*************************************************

    var userAuthenticated: User?
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Self Public Methods
//*************************************************
    
    func createUserWithEmail(email: String,
                             name: String,
                             password: String,
                             userName: String,
                             dateOfBirth: String,
                             gender: String,
                             completion: @escaping (Error?)->Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (userResponse: FIRUser?, error)  in
            if error != nil {
                completion(error)
            } else {
                guard
                    let uid = userResponse?.uid else {
                        return
                }
                let user = User(userId: uid, email: email, name: name, userName: userName, dateOfBirth: dateOfBirth, gender: gender, photoURL: nil)
                let dbReference = PersistenceManager.databaseReference
                let userDBReference = dbReference.child(kUsersDBReference).child(uid)
                userDBReference.updateChildValues(user.getJSON(), withCompletionBlock: { (error, databaseReference) in
                    if error != nil {
                        completion(error)
                    }
                })
                self.userAuthenticated = user
            }
        })
    }
    
    func userEmailExists(email: String, isExists: @escaping (Bool?)->Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: "", completion: { (userResponse: FIRUser?, errorResponse)  in
            let error = errorResponse as? NSError
            if error?.code == KnowErrorCode.EmailAlreadyInUse.rawValue {
                isExists(true)
            } else {
                isExists(false)
            }
        })
    }
    
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

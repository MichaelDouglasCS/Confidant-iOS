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
// MARK: - Self Public Methods
//*************************************************
    
    func createUserWithEmail(email: String,
                             nickName: String,
                             password: String,
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
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: dateOfBirth, gender: gender, photoURL: nil)
                let userDBReference = PersistenceManager.FirebaseDBTables.Users(user: user).reference()
                let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts.reference()
                
                accountDBReference.updateChildValues(user.getAccountEmail(), withCompletionBlock: { (error, accountDBResult) in
                    if error != nil {
                        
                        completion(error)
                        
                    } else {
                        
                        userDBReference.updateChildValues(user.getJSON(), withCompletionBlock: { (error, userDBResult) in
                            if error != nil {
                                completion(error)
                            } else {
                                self.userAuthenticated = user
                            }
                        })
                        
                    }
                })
            }
        })
        
    }
    
    class func userEmailExists(email: String, isExists: @escaping (Bool)->Void) {
        let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts.reference()
        let userDBReference = accountDBReference.queryOrderedByValue()
        userDBReference.queryEqual(toValue: "\(email)").observe(.value, with: { snapshot in
            if snapshot.exists() {
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

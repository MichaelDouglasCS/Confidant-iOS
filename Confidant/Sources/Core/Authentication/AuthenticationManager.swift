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
// MARK: - Private Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
    func createUserWith(email: String,
                             nickName: String,
                             password: String,
                             dateOfBirth: String,
                             gender: String,
                             completion: @escaping (Error?)->Void) {
        var completionError: Error?
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (userResponse: FIRUser?, error)  in
            if error != nil {
                completionError = error
            } else {
                guard
                    let uid = userResponse?.uid else {
                        return
                }
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: dateOfBirth, gender: gender, photoURL: nil)
                let userDBReference = PersistenceManager.FirebaseDBTables.Users(user: user).reference()
                let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailSha1: email.sha1()).reference()
                accountDBReference.updateChildValues(user.getAccountEmail(), withCompletionBlock: { (error, accountDBResult) in
                    if error != nil {
                        completionError = error
                    } else {
                        userDBReference.updateChildValues(user.getJSON(), withCompletionBlock: { (error, userDBResult) in
                            if error != nil {
                                completionError = error
                            } else {
                                self.userAuthenticated = user
                            }
                        })
                        
                    }
                })
            }
            completion(completionError)
        })
        
    }
    
    func logInWith(email: String, password: String, completion: @escaping (Error?)->Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (userResponse: FIRUser?, error) in
            var completionError: Error?
            if error != nil {
                completionError = error
            } else {
                if let user = userResponse {
                    print(user)
                }
            }
            completion(completionError)
        })
    }
    
    class func userEmailExists(email: String, isExists: @escaping (Bool)->Void) {
        let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailSha1: email.sha1()).reference()
        let userDBReference = accountDBReference.queryOrderedByValue()
        userDBReference.queryEqual(toValue: "\(email)").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                isExists(true)
            } else {
                isExists(false)
            }
        })
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

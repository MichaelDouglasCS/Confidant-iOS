//
//  AuthenticationManager.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit
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
    
    func createUserWith(facebook: FIRAuthCredential, completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.signIn(with: facebook, completion: { (userFirebase: FIRUser?, error) in
            if error != nil {
                completion(.Failed, error)
                return
            } else {
                guard
                    let uid = userFirebase?.uid,
                    let email = userFirebase?.email,
                    let nickName = userFirebase?.displayName,
                    let photoURL = userFirebase?.photoURL?.absoluteString else {
                        return
                }
            
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: nil, gender: nil, photoURL: photoURL)
                let userDBReference = PersistenceManager.FirebaseDBTables.Users(user: user).reference()
                let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailSha1: email.sha1()).reference()
                
                accountDBReference.updateChildValues(user.getAccountEmail(), withCompletionBlock: { (error, accountDBResult) in
                    if error != nil {
                        completion(.Failed, error)
                        return
                    } else {
                        
                        userDBReference.updateChildValues(user.getJSON(), withCompletionBlock: { (error, userDBResult) in
                            if error != nil {
                                completion(.Failed, error)
                                return
                            }
                            self.userAuthenticated = user
                            completion(.Success, error)
                        })
                    }
                })
            }
        })
    }
    
    
    func createUserWith(email: String,
                        nickName: String,
                        password: String,
                        dateOfBirth: String,
                        gender: String,
                        completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (userFirebase: FIRUser?, error)  in
            if error != nil {
                completion(.Failed, error)
                return
            } else {
                guard
                    let uid = userFirebase?.uid else {
                        return
                }
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: dateOfBirth, gender: gender, photoURL: nil)
                let userDBReference = PersistenceManager.FirebaseDBTables.Users(user: user).reference()
                let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailSha1: email.sha1()).reference()
                
                accountDBReference.updateChildValues(user.getAccountEmail(), withCompletionBlock: { (error, accountDBResult) in
                    if error != nil {
                        completion(.Failed, error)
                        return
                    } else {
                        userDBReference.updateChildValues(user.getJSON(), withCompletionBlock: { (error, userDBResult) in
                            if error != nil {
                                completion(.Failed, error)
                                return
                            }
                            self.userAuthenticated = user
                            completion(.Success, error)
                        })
                    }
                })
            }
        })
    }
    
    func logInWith(email: String, password: String, completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (userFirebase: FIRUser?, error) in
            if error != nil {
                completion(.Failed, error)
                return
            } else {
                if let uid = userFirebase?.uid {
                    print(uid)
                }
                
                if let email = userFirebase?.email {
                    print(email)
                }
                
                if let displayName = userFirebase?.displayName {
                    print(displayName)
                }
                
                if let photoURL = userFirebase?.photoURL {
                    print(photoURL)
                }
                completion(.Success, error)
            }
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

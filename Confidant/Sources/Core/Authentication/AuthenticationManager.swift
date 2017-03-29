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
    
    func createUserWith(credentials: FIRAuthCredential, accreditedUser: User, completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (firebaseUser: FIRUser?, error) in
            if error == nil {
                guard
                    let uid = firebaseUser?.uid,
                    let email = firebaseUser?.email,
                    let nickName = firebaseUser?.displayName,
                    let dateOfBirth = accreditedUser.dateOfBirth,
                    let gender = accreditedUser.gender,
                    let photoURL = firebaseUser?.photoURL?.absoluteString else {
                        completion(.Failed, error)
                        return
                }
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: dateOfBirth, gender: gender, photoURL: photoURL)
                let persistence = PersistenceManager()
                
                persistence.create(user: user, completion: { (responseStatus, error) in
                    switch responseStatus {
                    case .Success:
                        completion(.Success, error)
                    case .Failed:
                        completion(.Failed, error)
                    }
                })
            } else {
                completion(.Failed, error)
            }
        })
    }
    
    func createUserWith(email: String,
                        nickName: String,
                        password: String,
                        dateOfBirth: String,
                        gender: String,
                        completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firebaseUser: FIRUser?, error)  in
            if error == nil {
                guard let uid = firebaseUser?.uid else { return }
                let user = User(userId: uid, email: email, nickName: nickName, dateOfBirth: dateOfBirth, gender: gender, photoURL: nil)
                let persistence = PersistenceManager()
                
                persistence.create(user: user, completion: { (responseStatus, error) in
                    switch responseStatus {
                    case .Success:
                        completion(.Success, error)
                        self.userAuthenticated = user
                    case .Failed:
                        completion(.Failed, error)
                    }
                })
            } else {
                completion(.Failed, error)
            }
        })
    }
    
    func logInWith(email: String, password: String, completion: @escaping (ResponseStatus, Error?)->Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firebaseUser: FIRUser?, error) in
            if error == nil {
                completion(.Success, error)
            } else {
                completion(.Failed, error)
            }
        })
    }
    
    class func userEmailExists(email: String, isExists: @escaping (Bool)->Void) {
        let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailEncrypted: email.toSHA1()).reference()
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

extension String {
    
    mutating func dateToLongFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let date = dateFormatter.date(from: self)
        let newDate = dateFormatter.string(from: date!)
        return newDate
    }
    
}

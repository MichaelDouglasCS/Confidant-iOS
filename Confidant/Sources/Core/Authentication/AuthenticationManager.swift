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

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Self Public Methods
//*************************************************

    func signUpUser(email: String,
                    name: String,
                    password: String,
                    userName: String,
                    dateOfBirth: String,
                    gender: String, responseError: @escaping (Error?)->Void) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error)  in
            
            if error != nil {
                responseError(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: URL.databaseURL())
            let userReference = ref.child("users").child(uid)
            let parameters = ["email": email,
                              "name": name,
                              "userName": userName,
                              "dateOfBirth": dateOfBirth,
                              "gender": gender]
            
            userReference.updateChildValues(parameters)
            
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

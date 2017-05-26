//
//  AuthenticationManager.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseDatabase
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public struct AuthenticationManager {
	
	public enum Method {
		case signInBy(email: String, name: String, password: String, birthdate: String, gender: String)
		case signInByFacebook(from: UIViewController)
		case logInBy(email: String, password: String)
	}
	
//*************************************************
// MARK: - Properties
//*************************************************

	public let method: AuthenticationManager.Method
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func authenticateWith(email: String, password: String, completionHandler: @escaping FirebaseResult) {
		FIRAuth.auth()?.signIn(withEmail: email, password: password) { (firUser: FIRUser?, error) in
			if let error = error {
				completionHandler(firUser, .failed(error))
			} else {
				completionHandler(firUser, .success)
			}
		}
	}
	
	private func createUserWith(email: String, password: String, completionHandler: @escaping FirebaseResult) {
		FIRAuth.auth()?.createUser(withEmail: email, password: password) { (firUser: FIRUser?, error)  in
			if let error = error {
				completionHandler(firUser, .failed(error))
			} else {
				completionHandler(firUser, .success)
			}
		}
	}
	
	private func signInWith(credentials: FIRAuthCredential, completionHandler: @escaping FirebaseResult) {
		FIRAuth.auth()?.signIn(with: credentials) { (firUser: FIRUser?, error) in
			if let error = error {
				completionHandler(firUser, .failed(error))
			} else {
				completionHandler(firUser, .success)
			}
		}
	}
	
	private func signInWithFacebook(from target: UIViewController, completionHandler: @escaping UserResult) {
		let readPermissions = ["email", "public_profile", "user_birthday"]
		
		FBSDKLoginManager().logIn(withReadPermissions: readPermissions, from: target) {
			(resultFacebook, error) in
			
			if let resultFacebook = resultFacebook {
				if !(resultFacebook.isCancelled) {
					if let error = error {
						completionHandler(nil, .failed(error))
					} else {
						let accessToken = resultFacebook.token?.tokenString ?? ""
						let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
						
						FBSDKGraphRequest(graphPath: "me",
						                  parameters: ["fields": "email, name, birthday, gender, picture"]).start() {
											(connection, resultGraph, error) -> Void in
											
											if let error = error {
												completionHandler(nil, .failed(error))
											} else {
												var user: UserVO?
												let dic = resultGraph as! NSDictionary
												
												let json = JSON(dic)
												let userJSON = UserVO(facebookJSON: json)
												
												user = userJSON
												
												FIRAuth.auth()?.signIn(with: credentials) { (firUser: FIRUser?, error) in
													if let error = error {
														completionHandler(user, .failed(error))
													} else {
														user?.id = firUser?.uid ?? ""
														
														completionHandler(user, .success)
													}
												}
											}
						}
					}
				} else {
					completionHandler(nil, .failed(nil))
				}
			} else {
				completionHandler(nil, .failed(nil))
			}
		}
	}
	
//	func userEmailExists(email: String, isExists: @escaping (Bool)->Void) {
//		let accountDBReference = PersistenceManager.FirebaseDBTables.Accounts(userEmailEncrypted: email.toSHA1()).reference()
//		let userDBReference = accountDBReference.queryOrderedByValue()
//
//		userDBReference.queryEqual(toValue: "\(email)").observeSingleEvent(of: .value, with: { snapshot in
//			if snapshot.exists() {
//				isExists(true)
//			} else {
//				isExists(false)
//			}
//		})
//	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func execute(completionHandler: @escaping UserResult) {
		
		switch self.method {
		case .logInBy(let email, let password):
			self.authenticateWith(email: email, password: password) { (firUser, logicResult) in
				var user: UserVO?
				
				if let firUser = firUser {
					user = UserVO(firUser: firUser, name: "Michael", birthdate: "10/06/1996", gender: "Male")
					completionHandler(user, logicResult)
				} else {
					completionHandler(user, logicResult)
				}
			}
		case .signInByFacebook(let target):
			self.signInWithFacebook(from: target) { (resultUser, logicResult) in
				var user: UserVO?
				
				if let resultUser = resultUser {
					user = resultUser
					completionHandler(user, logicResult)
				} else {
					completionHandler(user, logicResult)
				}
			}
		case .signInBy(let email, let name, let password, let birthdate, let gender):
			self.createUserWith(email: email, password: password) { (firUser, logicResult) in
				var user: UserVO?
				
				if let firUser = firUser {
					user = UserVO(firUser: firUser, name: name, birthdate: birthdate, gender: gender)
					completionHandler(user, logicResult)
				} else {
					completionHandler(user, logicResult)
				}
			}
		}
	}
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

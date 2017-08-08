//
//  UsersLO.swift
//  Confidant
//
//  Created by Michael Douglas on 25/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
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

public final class UsersLO {
	
	public struct AuthenticationType {
		
		public enum Register {
			case email(user: UserBO)
			case facebook
		}
		
		public enum Login {
			case email(user: UserBO)
			case facebook
		}
	}
	
//*************************************************
// MARK: - Properties
//*************************************************

	public var current: UserBO?
	
	static public let instance: UsersLO = UsersLO()
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func getFacebookCredentials(completionHandler: @escaping (FIRAuthCredential?, ServerResponse)->Void) {
		let readPermissions = ["email", "public_profile", "user_birthday"]
		let topViewController = UIWindow().topMostController
		var credential: FIRAuthCredential?
		
		FBSDKLoginManager().logIn(withReadPermissions: readPermissions, from: topViewController) {
			(resultFacebook, error) in
			
			if let resultFacebook = resultFacebook {
				if !(resultFacebook.isCancelled) {
					if let error = error {
						completionHandler(nil, .failed(error))
					} else {
						let accessToken = resultFacebook.token?.tokenString ?? ""
						credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
						
						completionHandler(credential, .success)
					}
				} else {
					completionHandler(credential, .failed(error))
				}
			} else {
				completionHandler(credential, .failed(error))
			}
		}
	}
	
	private func loadFacebookUser(completionHandler: @escaping UserResult) {
		var user: UserBO?
		
		FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, birthday, gender, picture"]).start() {
			(connection, resultGraph, error) -> Void in
			if let error = error {
				completionHandler(user, .failed(error))
			} else {
				if let dictionary = resultGraph as? NSDictionary {
					let json = JSON(dictionary)
					
					user = UserBO()
					user?.decodeFacebook(json: json)
				}
				completionHandler(user, .success)
			}
		}
	}

	private func save(user: UserBO, completionHandler: @escaping LogicResult) {

		PersistenceManager.save(.user(user)) { (result) in
			switch result {
			case .success:
				self.current = user
				completionHandler(.success)
			case .failed(let error):
				completionHandler(.failed(error))
			}
		}
	}
	
	private func load(user: UserBO, completionHandler: @escaping LogicResult) {
		
		PersistenceManager.load(.user(user)) { (json, result) in
			switch result {
			case .success:
				let user = UserBO(json: json)
				self.current = user
				completionHandler(.success)
			case .failed(let error):
				completionHandler(.failed(error))
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func register(by method: AuthenticationType.Register, completionHandler: @escaping LogicResult) {

		switch method {
		case .email(let user):
			FIRAuth.auth()?.createUser(withEmail: user.email, password: user.password) { (firUser: FIRUser?, error) in
				if let error = error {
					completionHandler(.failed(error))
				} else {
					user.id = firUser?.uid ?? ""
					
					self.save(user: user) { (result) in
						switch result {
						case .success:
							completionHandler(.success)
						case .failed(let error):
							completionHandler(.failed(error))
						}
					}
				}
			}
		case .facebook:
			self.getFacebookCredentials() { (credential, result) in
				if let credential = credential {
					
					FIRAuth.auth()?.signIn(with: credential) { (firUser: FIRUser?, error) in
						if let error = error {
							completionHandler(.failed(error))
						} else {
							
							self.loadFacebookUser() { (user, result) in
								if let user = user {
									user.id = firUser?.uid ?? ""
									
									self.save(user: user) { (result) in
										switch result {
										case .success:
											completionHandler(.success)
										case .failed(let error):
											completionHandler(.failed(error))
										}
									}
								} else {
									completionHandler(result)
								}
							}
						}
					}
				} else {
					completionHandler(result)
				}
			}
		}
	}
	
	public func login(by method: AuthenticationType.Login, completionHandler: @escaping LogicResult) {
		
		switch method {
		case .email(let user):
			FIRAuth.auth()?.signIn(withEmail: user.email, password: user.password) { (firUser: FIRUser?, error) in
				if let error = error {
					completionHandler(.failed(error))
				} else {
					let user = UserBO()
					user.id = firUser?.uid ?? ""
					
					self.load(user: user) { (result) in
						switch result {
						case .success:
							completionHandler(.success)
						case .failed(let error):
							completionHandler(.failed(error))
						}
					}
				}
			}
		case .facebook:
			self.getFacebookCredentials() { (credential, result) in
				
				if let credential = credential {
					FIRAuth.auth()?.signIn(with: credential) { (firUser: FIRUser?, error) in
						if let error = error {
							completionHandler(.failed(error))
						} else {
							let user = UserBO()
							user.id = firUser?.uid ?? ""
							
							self.load(user: user) { (result) in
								switch result {
								case .success:
									completionHandler(.success)
								case .failed(let error):
									completionHandler(.failed(error))
								}
							}
						}
					}
				} else {
					completionHandler(result)
				}
			}
		}
	}
	
	public func update(user: UserBO, completionHandler: @escaping LogicResult) {
		
	}
	
	public func signOut() {
		self.current = UserBO()
		try? FIRAuth.auth()?.signOut()
		FBSDKLoginManager().logOut()
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

}

//**********************************************************************************************************
//
// MARK: - Extension - UIWindow
//
//**********************************************************************************************************

extension UIWindow {
	
	var topMostController: UIViewController? {
		var topController = self.rootViewController
		
		while let controller = topController?.presentedViewController {
			topController = controller
		}
		
		return topController
	}
}

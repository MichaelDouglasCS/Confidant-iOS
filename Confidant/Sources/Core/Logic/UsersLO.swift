//
//  UsersLO.swift
//  Confidant
//
//  Created by Michael Douglas on 25/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

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
			case email(user: UserVO)
			case facebook
		}
		
		public enum Login {
			case email(user: UserVO)
			case facebook
		}
	}
	
//*************************************************
// MARK: - Properties
//*************************************************

	public var current: UserVO?
	
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
		
		FBSDKLoginManager().logIn(withReadPermissions: readPermissions, from: topViewController) {
			(resultFacebook, error) in
			
			if let resultFacebook = resultFacebook {
				if !(resultFacebook.isCancelled) {
					if let error = error {
						completionHandler(nil, .failed(error))
					} else {
						let accessToken = resultFacebook.token?.tokenString ?? ""
						let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken)
						
						completionHandler(credential, .success)
					}
				} else {
					completionHandler(nil, .failed(error))
				}
			} else {
				completionHandler(nil, .failed(error))
			}
		}
	}
	
	private func getFacebookUser() {
		
//		FBSDKGraphRequest(graphPath: "me",
//		                  parameters: ["fields": "email, name, birthday, gender, picture"]).start() {
//							(connection, resultGraph, error) -> Void in
//							
//							if let error = error {
//								completionHandler(nil, .failed(error))
//							} else {
//								var user: UserVO?
//								
//								if let dictionary = resultGraph as? NSDictionary {
//									let userJSON = UserVO(facebookJSON: JSON(dictionary))
//									user = userJSON
//								}
//								
//								FIRAuth.auth()?.signIn(with: credentials) { (firUser: FIRUser?, error) in
//									if let error = error {
//										completionHandler(user, .failed(error))
//									} else {
//										user?.id = firUser?.uid ?? ""
//										completionHandler(user, .success)
//									}
//								}
//							}
//		}
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
					completionHandler(.success)
				}
			}
		case .facebook:
			self.getFacebookCredentials() { (credential, result) in
				
				if let credential = credential {
					FIRAuth.auth()?.signIn(with: credential) { (firUser: FIRUser?, error) in
						if let error = error {
							completionHandler(.failed(error))
						} else {
							completionHandler(.success)
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
					completionHandler(.success)
				}
			}
		case .facebook:
			self.getFacebookCredentials() { (credential, result) in
				
				if let credential = credential {
					FIRAuth.auth()?.signIn(with: credential) { (firUser: FIRUser?, error) in
						if let error = error {
							completionHandler(.failed(error))
						} else {
							completionHandler(.success)
						}
					}
				} else {
					completionHandler(result)
				}
			}
		}
	}
	
	public func update(user: UserVO, completionHandler: @escaping LogicResult) {
		
	}
	
	public func signOut() {
		self.current = UserVO()
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

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
import SwiftyJSON

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
	
	public enum Path {
		case user(UserVO)
	}
	
	public struct Firebase {
		static fileprivate let reference = FIRDatabase.database().reference(fromURL: URLs.database())
		
		static public let users = PersistenceManager.Firebase.reference.child("users")
	}

//*************************************************
// MARK: - Properties
//*************************************************
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	static public func save(_ path: PersistenceManager.Path, completionHandler: @escaping LogicResult) {
		
		switch path {
		case .user(let user):
			if let params = user.encodeJSON().dictionaryObject, !user.id.isEmpty {
				self.Firebase.users.child(user.id).updateChildValues(params) { (error, _) in
					
					if let error = error {
						completionHandler(.failed(error))
					} else {
						completionHandler(.success)
					}
				}
			} else {
				completionHandler(.failed(nil))
			}
		}
	}
	
	static public func update(_ path: PersistenceManager.Path, completionHandler: @escaping LogicResult) {
		
		switch path {
		case .user(let user):
			if let params = user.encodeJSON().dictionaryObject, !user.id.isEmpty {
				self.Firebase.users.child(user.id).updateChildValues(params) { (error, _) in
					
					if let error = error {
						completionHandler(.failed(error))
					} else {
						completionHandler(.success)
					}
				}
			} else {
				completionHandler(.failed(nil))
			}
		}
	}
	
	static public func load(_ path: PersistenceManager.Path, completionHandler: @escaping ServerResult) {
		
		switch path {
		case .user(let user):
			var json: JSON = [:]
			
			if !user.id.isEmpty {
				self.Firebase.users.child(user.id).observeSingleEvent(of: .value, with: { (result) in
					if let value = result.value {
						json = JSON(value)
						
						completionHandler(json, .success)
					} else {
						completionHandler(json, .failed(nil))
					}
				})
			} else {
				completionHandler(json, .failed(nil))
			}
		}
	}
	
	static public func delete(_ path: PersistenceManager.Path, completionHandler: @escaping LogicResult) {
		
		switch path {
		case .user(let user):
			if let params = user.encodeJSON().dictionaryObject, !user.id.isEmpty {
				self.Firebase.users.child(user.id).updateChildValues(params) { (error, _) in
					
					if let error = error {
						completionHandler(.failed(error))
					} else {
						completionHandler(.success)
					}
				}
			} else {
				completionHandler(.failed(nil))
			}
		}
	}
}

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

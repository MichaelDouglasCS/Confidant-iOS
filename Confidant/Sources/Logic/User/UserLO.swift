//
//  UserLO.swift
//  Confidant
//
//  Created by Michael Douglas on 12/08/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
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

extension Notification.Name {
	static let userDidLoginSuccess = Notification.Name(rawValue: "UserDidLoginSuccess")
	static let userDidLoginError = Notification.Name(rawValue: "UserDidLoginError")
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public final class UserLO {

//*************************************************
// MARK: - Properties
//*************************************************
	
//	public var localUser: UserVO? {
//		let modelClass = RealmUserModel.self
//		
//		Persistence.dataBaseName = AppSettings.Defaults.dataBase
//		if let id = Persistence.load(collection: modelClass)?.first?.userID, !id.isEmpty {
//			
//			Persistence.dataBaseName = id
//			if let user = Persistence.load(collection: modelClass)?.first {
//				return UserVO(raw: user.json)
//			}
//		}
//		
//		return nil
//	}
//	
//	public private(set) lazy var current: UserVO = {
//		return self.localUser ?? UserVO()
//	}()
	
	static public let sharedInstance: UserLO = UserLO()

//*************************************************
// MARK: - Constructors
//*************************************************
	
	private init() { }

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func cacheAndSetCurrent(json: JSON) {
		
//		let newUser = UserVO(json: json)
//		
//		// Only for users with valid ID
//		if let id = newUser.id, !id.isEmpty {
//			let cache = RealmUserModel()
//			let model = RealmUserModel()
//			
//			cache.userID = id
//			model.userID = id
//			model.json = newUser.raw
//			
//			// Saving the current user only
//			Persistence.dataBaseName = AppSettings.Defaults.dataBase
//			Persistence.save(model: cache)
//			
//			// Saving the current user in its personal data base
//			Persistence.dataBaseName = id
//			Persistence.save(model: model)
//		}
//		
//		// Current user is always set, even when the new one is empty.
//		// That means the current user is no longer valid.
//		self.current = newUser
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func register(user: UserVO, completionHandler: @escaping LogicResult) {
		
		ServerRequest.API.userRegister.execute(params: user.toJSON()) { (json, result) in
			self.cacheAndSetCurrent(json: json)
			completionHandler(result)
		}
	}
	
	public func authenticate(user: UserVO, completionHandler: @escaping LogicResult) {

		ServerRequest.API.userAuthenticate.execute(params: user.toJSON()) { (json, result) in
			self.cacheAndSetCurrent(json: json)
			completionHandler(result)
		}
	}
	
	public func handleFacebookUser(from url: URL) -> Bool {
		var isHandled: Bool = false
		
		if url.scheme == ConfidantApp.scheme {
			let path = url.path
			let fullRange = NSRange(location: 0, length: path.characters.count)
			
			if let regex = try? NSRegularExpression(pattern: "\\/user\\/", options: []) {
				let jsonString = regex.stringByReplacingMatches(in: path,
				                                                options: [],
				                                                range: fullRange,
				                                                withTemplate: "")
				
				if let data = jsonString.data(using: String.Encoding.utf8) {
					let json = JSON(data: data)["user"]
					
					if json.exists() {
						self.cacheAndSetCurrent(json: json)
						isHandled = true
					}
				}
			}
		}
		
		if isHandled {
			NotificationCenter.default.post(name: .userDidLoginSuccess, object: nil)
		} else {
			NotificationCenter.default.post(name: .userDidLoginError, object: nil)
		}
		
		return isHandled
	}
	
	public func update(user: UserVO, completionHandler: @escaping LogicResult) {
		
		ServerRequest.API.userUpdate.execute(params: user.toJSON()) { (json, result) in
			self.cacheAndSetCurrent(json: json)
			completionHandler(result)
		}
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

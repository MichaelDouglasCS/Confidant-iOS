//
//  UsersLO.swift
//  Confidant
//
//  Created by Michael Douglas on 12/08/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

extension Notification.Name {
	static let userDidLoginSuccess = Notification.Name(rawValue: "UserDidLoginSuccess")
	static let userDidLoginError = Notification.Name(rawValue: "UserDidLoginError")
}

public class RealmUserModel : RealmModel {
	
	dynamic public var userID: String = ""
	
	convenience init(userID: String, data: Data? = nil) {
		self.init()
		self.userID = userID
		
		if let jsonData = data {
			self.data = jsonData
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
The user logic object is going to save the current userID to the default date base
and the full user into a separated and specific data base.

```
|\____/|         |\____/|
|      |         |      |
|UserID| 1 ... N | Full |
|      |         | User |
|------|         |------|
```

Throughout the app, everything related to the user will now be saved on its own data base.
Allowing the app to store multiple users and manage the current user on the default data base.

Invalid authentications or updates will make the curernt cached user to be erased.

The lazy initialized `current` is going to return the cached user automatically, if there is one.
*/
public final class UsersLO {

//**************************************************
// MARK: - Properties
//**************************************************
	
	static private let db: String = "User"
	
	private var localUser: UserBO? {
		let modelClass = RealmUserModel.self
		
		Persistence.dataBaseName = UsersLO.db
		
		if let id = Persistence.load(collection: modelClass)?.first?.userID, !id.isEmpty {
			
			Persistence.dataBaseName = id
			
			if let user = Persistence.load(collection: modelClass)?.first {
				return UserBO(JSON: JSON(data: user.data).dictionaryObject ?? [:])
			}
		}
		
		return nil
	}
	
	public lazy var current: UserBO = {
		return self.localUser ?? UserBO()
	}()
	
	static public let sharedInstance: UsersLO = UsersLO()
	
//**************************************************
// MARK: - Constructors
//**************************************************
	
	private init() { }

//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func cacheAndSetCurrent(json: JSON) {
		let newUser = UserBO(JSON: json.dictionaryObject ?? [:]) ?? UserBO()
		
		// Only for users with valid ID
		if let id = newUser.id, !id.isEmpty {
			// Saving the current user in its personal data base
			Persistence.dataBaseName = id
			Persistence.save(model: RealmUserModel(userID: id, data: try? JSON(newUser.toJSON()).rawData()))
			Persistence.save(model: RealmUserModel(userID: id), at: UsersLO.db)
		}
		
		// Current user is always set, even when the new one is empty.
		// That means the current user is no longer valid.
		self.current = newUser
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func register(user: UserBO, completionHandler: @escaping LogicResult) {
		
		ServerRequest.User.register.execute(params: user.toJSON()) { (json, result) in
			self.cacheAndSetCurrent(json: json)
			completionHandler(result)
		}
	}
	
	public func authenticate(user: UserBO, completionHandler: @escaping LogicResult) {

		ServerRequest.User.authenticate.execute(params: user.toJSON()) { (json, result) in
			self.cacheAndSetCurrent(json: json)
			completionHandler(result)
		}
	}
	
	public func update(user: UserBO, completionHandler: @escaping LogicResult) {

		ServerRequest.User.update.execute(params: user.toJSON()) { (_, result) in
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
	
	public func logout() {
		Persistence.dataBaseName = UsersLO.db
		Persistence.delete(collection: RealmUserModel.self)
		self.cacheAndSetCurrent(json: JSON([:]))
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UsersLO - Picture
//
//**********************************************************************************************************

extension UsersLO {
	
	public func upload(picture: UIImage) {
		let url = ServerRequest.Media.upload.path
		var headers = Alamofire.SessionManager.defaultHTTPHeaders
		
		if let token = UsersLO.sharedInstance.current.token {
			headers["Authorization"] = "Bearer \(token)"
		} else {
			headers.removeValue(forKey: "Authorization")
		}
		
		if let imageData = UIImagePNGRepresentation(picture),
			let imageID = self.current.id {
			
			Alamofire.upload(multipartFormData: { (multipartFormData) in
				multipartFormData.append(imageData,
				                         withName: "picture",
				                         fileName: "\(imageID).jpg",
				                         mimeType: "image/PNG")
				multipartFormData
			}, to: url, method: .post, headers: headers)
			{ (result) in
				
				switch result {
				case .success(let upload, _, _):
					
					upload.uploadProgress(closure: { (Progress) in
						print("Upload Progress: \(Progress.fractionCompleted)")
					})
					
					upload.responseJSON { response in
						//self.delegate?.showSuccessAlert()
						print(response.request)  // original URL request
						print(response.response) // URL response
						print(response.data)     // server data
						print(response.result)   // result of response serialization
						//                        self.showSuccesAlert()
						//self.removeImage("frame", fileExtension: "txt")
						if let JSON = response.result.value {
							print("JSON: \(JSON)")
						}
					}
					
				case .failure(let encodingError):
					//self.delegate?.showFailAlert()
					print(encodingError)
				}
				
			}
		}
	}
	
	public func downloadPicture() {
		
	}
}

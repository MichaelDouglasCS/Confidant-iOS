/*
*	ServerRequest.swift
*	Confidant
*
*	Created by Michael Douglas on 06/01/17.
*	Copyright 2017 Watermelon. All rights reserved.
*/

import Foundation
import Alamofire
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public typealias LogicResult = (ServerResponse) -> Void
public typealias ServerResult = (JSON, ServerResponse) -> Void

/**
Defines how the main server defines its responses.
Showing up the agreed error codes and messages for each of the known scenarios.
*/
public enum ServerResponse {
	
	public enum Error: String {
		case unkown = "MSG_SERVER_ERROR"
		case invalidCredentials = "MSG_INVALID_LOGIN"
		case invalidEmail = "MSG_INVALID_EMAIL"
		case emailAlreadyExists = "MSG_EMAIL_ALREADY_EXISTS"
		case facebookError = "MSG_FACEBOOK_ERROR"
		case tokenNotInformed = "MSG_TOKEN_NOT_INFORMED"
		case invalidToken = "MSG_INVALID_TOKEN"
		case pictureNotUpdated = "MSG_PICTURE_NOT_UPDATED"
	}
	
	case success
	case error(ServerResponse.Error)
	
	//**************************************************
	// MARK: - Properties
	//**************************************************
	
	public var localizedError: String {
		switch self {
		case .error(let type):
			return type.rawValue.localized
		default:
			return ""
		}
	}
	
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	
	public init(_ response: HTTPURLResponse?) {
		if let httpResponse = response {
			switch httpResponse.statusCode {
			case 200..<300:
				self = .success
			case 401, 404:
				self = .error(.invalidCredentials)
			case 402:
				self = .error(.invalidEmail)
			case 403:
				self = .error(.emailAlreadyExists)
			case 40:
				self = .error(.facebookError)
			case 407:
				self = .error(.tokenNotInformed)
			case 408:
				self = .error(.invalidToken)
			default:
				self = .error(.unkown)
			}
		} else {
			self = .error(.unkown)
		}
	}
}

struct ConfidantApp {
	static let scheme: String = "confidant"
}

//**********************************************************************************************************
//
// MARK: - Type -
//
//**********************************************************************************************************

public enum ServerRequest {
	
	case mobile(RESTContract)
	
	public typealias RESTContract = (method: HTTPMethod, path: String)
	
	public struct Domain {
		static public var mobile: String = Domain.develop
		
		static public let local: String = "http://localhost:3000/confidant/api/v1"
		static public let develop: String = "https://confidant-api.herokuapp.com/confidant/api/v1"
		static public let homolog: String = ""
		static public let production: String = ""
	}
	
	public struct User {
		static public let register: ServerRequest = .mobile((method: .post, path: "/users"))
		static public let update: ServerRequest = .mobile((method: .put, path: "/users"))
		static public let authenticate: ServerRequest = .mobile((method: .post, path: "/users/authenticate"))
		static public let facebookAuth: ServerRequest = .mobile((method: .get, path: "/users/facebook"))
		static public let getByEmail: ServerRequest = .mobile((method: .get, path: "/users/{email}"))
		static public let changeAvailability: ServerRequest = .mobile((method: .put, path: "/users/changeAvailability/{id}"))
	}
	
	public struct Media {
		static public let upload: ServerRequest = .mobile((method: .post, path: "/media/"))
	}
	
	public struct Knowledge {
		static public let insert: ServerRequest = .mobile((method: .post, path: "/knowledges"))
		static public let listAll: ServerRequest = .mobile((method: .get, path: "/knowledges"))
		static public let deleteByID: ServerRequest = .mobile((method: .delete, path: "/knowledges/{id}"))
	}
	
//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func getHeader() -> HTTPHeaders {
		var headers = Alamofire.SessionManager.defaultHTTPHeaders
		
		if let token = UsersLO.sharedInstance.current.token {
			headers["Authorization"] = "Bearer \(token)"
		} else {
			headers.removeValue(forKey: "Authorization")
		}
		
		return headers
	}

//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	public var method: HTTPMethod {
		switch self {
		case .mobile(let contract):
			return contract.method
		}
	}
	
	public var path: String {
		switch self {
		case .mobile(let contract):
			return ServerRequest.Domain.mobile + contract.path
		}
	}
	
	public func url(params: String...) -> URL? {
		let path = self.path
		let fullRange = NSRange(location: 0, length: path.characters.count)
		let template = "==##=="
		
		if let regex = try? NSRegularExpression(pattern: "\\{.*?\\}", options: []) {
			let clean = regex.stringByReplacingMatches(in: path,
			                                           options: [],
			                                           range: fullRange,
			                                           withTemplate: template)
			var components = clean.components(separatedBy: template)
			var index = 1
			
			params.forEach {
				if components.count > index {
					components.insert($0, at: index)
					index += 2
				}
			}
			
			return URL(string: components.joined())
		}
		
		return nil
	}
	
	/// This method is used to Execute Requests
	///
	/// - Parameters:
	///   - aPath: Custom Path for your Request.
	///   - params: Params of your Request
	///   - completion: This method produces (JSON, ServerResponse) -> Void
	public func execute(aPath: String? = nil,
	                    params: [String: Any]? = nil,
	                    completion: @escaping ServerResult) {
		DispatchQueue.global(qos: .background).async {
			
			let method = self.method
			let finalPath = aPath ?? self.path
			let closure = { (_ dataResponse: DataResponse<Any>) in
				
				var json: JSON = [:]
				let httpResponse = dataResponse.response
        
				switch dataResponse.result {
				case .success(let data):
					json = JSON(data)
				default:
					break
				}
				
				completion(json, ServerResponse(httpResponse))
			}
			
			let headers = self.getHeader()
			
			_ = Alamofire.request(finalPath,
			                      method: method,
			                      parameters: params,
			                      encoding: JSONEncoding.default,
			                      headers: headers).responseJSON(completionHandler: closure)
		}
	}
	
	
	/// This method is used to Upload Files
	///
	/// - Parameters:
	///   - aPath: Custom Path to Upload your File
	///   - data: Data to be Uploaded
	///   - fieldName: Name of the field, ***default = "file"***
	///   - fileName: Name of the File
	///   - mimeType: Type of your File
	///   - completion: This method produces (JSON, ServerResponse) -> Void
	public func execute(aPath: String? = nil,
	                   data: Data,
	                   fieldName: String,
	                   fileName: String,
	                   mimeType: String,
	                   completion: @escaping ServerResult) {
		DispatchQueue.global(qos: .background).async {
			
			let method = self.method
			let finalPath = aPath ?? self.path
			let closure = { (_ dataResponse: DataResponse<Any>) in
				
				var json: JSON = [:]
				let httpResponse = dataResponse.response
				
				switch dataResponse.result {
				case .success(let data):
					json = JSON(data)
				default:
					break
				}
				
				completion(json, ServerResponse(httpResponse))
			}
			
			let headers = self.getHeader()
			
			Alamofire.upload(multipartFormData: { (multipartFormData) in
				multipartFormData.append(data,
				                         withName: fieldName,
				                         fileName: fileName,
				                         mimeType: mimeType)
			}, to: finalPath,
			   method: method,
			   headers: headers) { (result) in
				
				switch result {
				case .success(let upload, _, _):
					upload.responseJSON(completionHandler: closure)
				case .failure:
					let json: JSON = [:]
					
					completion(json, .error(ServerResponse.Error.unkown))
				}
				
			}
			
		}
	}
}

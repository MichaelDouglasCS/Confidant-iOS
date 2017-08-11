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
// MARK: - Constants -
//
//**********************************************************************************************************

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
	
	public enum Error {
		case unkown
		case invalidCredentials
	}
	
	case success
	case error(ServerResponse.Error)
	
	//**************************************************
	// MARK: - Properties
	//**************************************************
	
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	
	public init(_ response: HTTPURLResponse?) {
		if let httpResponse = response {
			switch httpResponse.statusCode {
			case 200..<300:
				self = .success
			case 401:
				self = .error(.invalidCredentials)
			default:
				self = .error(.unkown)
			}
		} else {
			self = .error(.unkown)
		}
	}
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
		
		static public let develop: String = "https://confidant-api.herokuapp.com/confidant/api/v1"
		static public let beta: String = ""
		static public let homolog: String = ""
		static public let production: String = ""
	}
	
	public struct API {
		static public let register: ServerRequest = .mobile((method: .post, path: "/register"))
		static public let authenticate: ServerRequest = .mobile((method: .post, path: "/authenticate"))
		static public let facebook: ServerRequest = .mobile((method: .get, path: "/facebook"))
	}
	
	//**************************************************
	// MARK: - Protected Methods
	//**************************************************
	
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
	
	public func execute(aPath: String? = nil,
	                    params: [String: AnyObject]? = nil,
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
			
			_ = Alamofire.request(finalPath,
			                      method: method,
			                      parameters: params,
			                      encoding: JSONEncoding.default,
			                      headers: nil).responseJSON(completionHandler: closure)
		}
	}
}

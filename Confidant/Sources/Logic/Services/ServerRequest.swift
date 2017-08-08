//
//  ServerRequest.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SwiftyJSON
import FirebaseAuth

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
public typealias FirebaseResult = (FIRUser?, ServerResponse) -> Void
public typealias UserResult = (UserBO?, ServerResponse) -> Void

/**
Defines how the main server defines its responses.
Showing up the agreed error codes and messages for each of the known scenarios.
*/
public enum ServerResponse {
	
	public enum Errors : String {
		case unkown = "MSG_SERVER_ERROR"
		case invalidCredentials = "MSG_INVALID_LOGIN"
		case emailAlreadyExists = "MSG_EMAIL_ALREADY_EXISTS"
		case tooManyRequests = "MSG_TOO_MANY_REQUESTS"
		case userNotFound = "MSG_USER_NOT_FOUND"
		case networkError = "MSG_NETWORK_ERROR"
	}
	
	case success
	case failed(Error?)
	
	public var localizedError: String {
		switch self {
		case .failed(let error as NSError):
			return description(error).localized
		default:
			return ""
		}
	}
	
	private func description(_ error: NSError) -> String {
		var description = ""
		
		switch error.code {
		case 17007:
			description = Errors.emailAlreadyExists.rawValue
		case 17008, 17009:
			description = Errors.invalidCredentials.rawValue
		case 17010:
			description = Errors.tooManyRequests.rawValue
		case 17011:
			description = Errors.userNotFound.rawValue
		case 17020:
			description = Errors.networkError.rawValue
		default:
			description = Errors.unkown.rawValue
		}
		
		return description
	}
}


//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ServerRequest {

//*************************************************
// MARK: - Properties
//*************************************************
    
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
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************

}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

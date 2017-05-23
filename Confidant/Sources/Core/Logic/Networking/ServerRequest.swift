//
//  ServerRequest.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
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

public typealias LogicResult = (ServerResponse) -> Void
public typealias ServerResult = (JSON, ServerResponse) -> Void

/**
Defines how the main server defines its responses.
Showing up the agreed error codes and messages for each of the known scenarios.
*/
public enum ServerResponse {
	
	public enum Error : String {
		case unkown = "MSG_SERVER_ERROR"
		case invalidCredentials = "MSG_INVALID_LOGIN"
	}
	
	case success
	case error(ServerResponse.Error)
	
	public var localizedError: String {
		switch self {
		case .error(let type):
			return type.rawValue.localized
		default:
			return ""
		}
	}
	
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

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

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

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

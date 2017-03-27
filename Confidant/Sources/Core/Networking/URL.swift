//
//  URL.swift
//  Confidant
//
//  Created by Michael Douglas on 18/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation

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
// MARK: - Enum -
//
//**************************************************************************************************

enum BaseURL: String {
    case MockServer = "https://ihungry.com"
}

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

public class URLs {
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    static let host = BaseURL.MockServer
    
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
    
    public class func hostURL() -> String {
        return self.host.rawValue
    }
    
    public class func databaseURL() -> String {
        return "https://confidant-47e97.firebaseio.com/"
    }
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
}

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

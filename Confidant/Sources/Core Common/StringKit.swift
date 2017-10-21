//
//  StringKit.swift
//  Confidant
//
//  Created by Michael Douglas on 18/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation

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

extension String {
	
	func contains(_ find: String) -> Bool{
		return self.range(of: find) != nil
	}
	
	func containsIgnoringCase(_ find: String) -> Bool{
		return self.range(of: find, options: .caseInsensitive) != nil
	}
}
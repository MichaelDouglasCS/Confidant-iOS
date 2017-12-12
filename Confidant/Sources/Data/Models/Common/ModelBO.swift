//
//  ModelBO.swift
//  Confidant
//
//  Created by Michael Douglas on 22/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class ModelBO: NSObject, NSCoding {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	public var raw: Data {
		var raw = Data()
		
		if let rawData = try? self.encodeJSON().rawData() {
			raw = rawData
		}
		
		return raw
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************
	
	public override init() {
		super.init()
	}
	
	required convenience public init(json: JSON) {
		self.init()
		self.decodeJSON(json: json)
	}
	
	required convenience public init(raw: Data) {
		self.init()
		self.decodeJSON(json: JSON(data: raw))
	}
	
	required convenience public init?(coder aDecoder: NSCoder) {
		self.init()
		if let data = aDecoder.decodeData() {
			self.decodeJSON(json: JSON(data: data))
		}
	}

//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	public func encode(with aCoder: NSCoder) {
		let json = self.encodeJSON()
		
		aCoder.encode(try? json.rawData())
	}
	
	public func decodeJSON(json: JSON) {
		
	}
	
	public func encodeJSON() -> JSON {
		return [:]
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
	
	override public var description: String {
		return self.encodeJSON().description
	}
	
	override public var debugDescription: String {
		return self.description
	}
}

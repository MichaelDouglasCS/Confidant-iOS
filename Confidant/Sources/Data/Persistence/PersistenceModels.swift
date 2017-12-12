//
//  PersistenceModels.swift
//  Confidant
//
//  Created by Michael Douglas on 12/08/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import RealmSwift

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

public class RealmModel : Object {
	
//**************************************************
// MARK: - Properties
//**************************************************

	/**
	Incremental ID, altough it's a string due to server side compatibility.
	*/
	dynamic public var id: String = ""
	
	/**
	JSON data for models.
	*/
	dynamic public var data: Data = Data()
	
	/**
	Auto-increment routine
	*/
	public var nextId: String {
		return "local:\(UUID().uuidString)"
	}
	
//**************************************************
// MARK: - Constructors
//**************************************************

	/**
	Initializer for auto-increment routine, pass nil to the id to make it auto-increment.
	*/
	convenience public init(id: String?) {
		self.init()
		self.id = id ?? self.nextId
	}
	
	/**
	Initializer for data property.
	*/
	convenience public init(data: Data) {
		self.init()
		self.data = data
	}
	
//**************************************************
// MARK: - Protected Methods
//**************************************************

//**************************************************
// MARK: - Exposed Methods
//**************************************************

	class public func isLocalID(_ id: String) -> Bool {
		return id.hasPrefix("local:")
	}
	
//**************************************************
// MARK: - Overridden Methods
//**************************************************
		
	override class public func primaryKey() -> String? {
		return "id"
	}
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class RealmSync : RealmModel {
	
	@objc
	public enum Action : Int {
		case none = 0
		case add = 1
		case update = 2
		case delete = 3
		case synced = 4
	}
	
	dynamic public var action: RealmSync.Action = .none
}

//
//  PersistenceStore.swift
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

public struct Persistence {

//**************************************************
// MARK: - Properties
//**************************************************
	
	static public var path: String {
		return Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
	}
	
	static public var dataBaseName: String {
		get {
			let config = Realm.Configuration.defaultConfiguration
			return config.fileURL?.lastPathComponent.replacingOccurrences(of: ".realm", with: "") ?? ""
		}
		
		set {
			var config = Realm.Configuration.defaultConfiguration
			let path = config.fileURL?.deletingLastPathComponent()
			let finalPath = path?.appendingPathComponent("\(newValue).realm")
			
			config.fileURL = finalPath
			
			Realm.Configuration.defaultConfiguration = config
		}
	}

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	static private func config(for name: String?) -> Realm.Configuration {
		var config = Realm.Configuration.defaultConfiguration
		
		if let dbName = name {
			let path = config.fileURL?.deletingLastPathComponent()
			let finalPath = path?.appendingPathComponent("\(dbName).realm")
			
			config = Realm.Configuration(fileURL: finalPath)
		}
		
		config.deleteRealmIfMigrationNeeded = true
		
		return config
	}

//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	static public func save(model: Object, at: String? = nil) {
		
		do {
			let realm = try Realm(configuration: self.config(for: at))
			
			try realm.write {
				realm.add(model, update: true)
			}
		} catch let error {
			print("Realm error:\(error)")
		}
	}
	
	static public func load<T : Object>(collection: T.Type,
							query: String? = nil,
							at: String? = nil) -> Results<T>? {
		
		do {
			let realm = try Realm(configuration: self.config(for: at))
			
			if let queryString = query {
				return realm.objects(collection).filter(queryString)
			} else {
				return realm.objects(collection)
			}
		} catch let error {
			print("Realm error:\(error)")
		}
		
		return nil
	}
	
	static public func delete<T : Object>(collection: T.Type, query: String? = nil, at: String? = nil) {
		
		do {
			let realm = try Realm(configuration: self.config(for: at))
			var results = realm.objects(collection)
			
			if let finalQuery = query {
				results = results.filter(finalQuery)
			}
			
			try realm.write {
				realm.delete(results)
			}
		} catch let error {
			print("Realm error:\(error)")
		}
	}

//**************************************************
// MARK: - Overridden Methods
//**************************************************

}

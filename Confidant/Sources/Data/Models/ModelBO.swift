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
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public var rootFolder: String?

public func saveObjectToFile(object: AnyObject?, encodeKey: String, path: String) {
	
	let store = NSMutableData()
	let archiver = NSKeyedArchiver(forWritingWith: store)
	archiver.encode(object, forKey: encodeKey)
	archiver.finishEncoding()
	
	store.write(toFile: path, atomically: true)
}

public func loadObjectFromFile(decodeKey: String, path: String) -> Any? {
	
	if let jsonData = NSData(contentsOfFile: path) {
		let archiver = NSKeyedUnarchiver(forReadingWith: jsonData as Data)
		
		let baseVO = archiver.decodeObject(forKey: decodeKey)
		archiver.finishDecoding()
		
		return baseVO
	}
	
	return nil
}

public func getFilePath(fileName: String, folders: String) -> String {
	var localPath = ""
	let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
	
	if paths.count > 0 {
		localPath = paths[0]
		
		if let customFolder = rootFolder, !customFolder.isEmpty {
			localPath = localPath.appending("/\(String(describing: rootFolder))/\(folders)")
		} else {
			localPath = localPath.appending("/\(folders)")
		}
		
		let fileManager = FileManager.default
		if !fileManager.fileExists(atPath: localPath) {
			let _ = try? fileManager.createDirectory(atPath: localPath,
			                                         withIntermediateDirectories: true,
			                                         attributes: nil)
		}
		
		localPath = localPath.appending("/\(fileName)")
	}
	
	return localPath
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class ModelBO : NSObject, NSCoding {
	
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
	
	//	public init?(file named: String, path: String = "") {
	//		let localPath = getFilePath(fileName: named, folders: path)
	//		if let object = loadObjectFromFile(decodeKey: named, path: localPath) as? ModelBO {
	//			self = object
	//		} else {
	//			return nil
	//		}
	//	}
	
//**************************************************
// MARK: - Protected Methods
//**************************************************

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
	
	public func saveToFile(fileName:String, path: String = "") {
		
		let localPath = getFilePath(fileName: fileName, folders: path)
		saveObjectToFile(object: self, encodeKey: fileName, path: localPath)
	}
	
	public static func loadFromFile(fileName:String, path: String) -> ModelBO? {
		
		let localPath = getFilePath(fileName: fileName, folders: path)
		let object = loadObjectFromFile(decodeKey: fileName, path: localPath)
		
		return object as? ModelBO
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

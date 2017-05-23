//
//  Parsable.swift
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

infix operator <->

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public protocol Parsable {
	init()
	mutating func parsing(_ parser: Parser)
}

public extension Parsable {
	
	public init(json: JSON) {
		self.init()
		self.parsing(Parser(mode: .fromJSON, json: json))
	}
	
	public func json() -> JSON {
		let parser = Parser(mode: .toJSON)
		var mutableCopy = self
		
		mutableCopy.parsing(parser)
		
		return parser.json
	}
}

//**********************************************************************************************************
//
// MARK: - Type -
//
//**********************************************************************************************************

public final class Parser {
	
	public enum Mode {
		case fromJSON
		case toJSON
	}
	
	//**************************************************
	// MARK: - Properties
	//**************************************************
	
	fileprivate let mode: Parser.Mode
	fileprivate var json: JSON
	fileprivate var keys: [String] = []
	fileprivate var keyPath: String? {
		didSet {
			self.keys = self.keyPath?.components(separatedBy: ".") ?? []
		}
	}
	
	public subscript(key: String) -> Parser {
		self.keyPath = self.keyPath?.appending(".\(key)") ?? key
		
		return self
	}
	
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	
	public init(mode: Parser.Mode, json: JSON = [:], keyPath: String? = nil) {
		self.mode = mode
		self.json = json
		self.keyPath = keyPath
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - JSON Handler
//
//**********************************************************************************************************

extension Parser {
	
	//**************************************************
	// MARK: - Properties
	//**************************************************
	
	fileprivate var currentNode: JSON {
		var node: JSON = [:]
		
		if let key = self.keys.first {
			node = self.json[key]
			
			// Dealing with the nested logic
			self.keys.suffix(from: 1).forEach {
				node = node[$0]
			}
		}
		
		return node
	}
	
	//**************************************************
	// MARK: - Protected Methods
	//**************************************************
	
	fileprivate func node(for path: [String]) -> JSON? {
		var node: JSON?
		
		if let key = path.first {
			node = self.json[key]
			node = (node?.type == .null) ? nil : node
			
			// Dealing with the nested logic
			path.suffix(from: 1).forEach {
				node = node?[$0]
				node = (node?.type == .null) ? nil : node
			}
		}
		
		return node
	}
	
	fileprivate func assignNode(_ json: JSON) {
		var keysCopy = self.keys
		var node = json
		var jsonTree = JSON([:])
		
		// Dealing with the nested logic
		self.keys.reversed().forEach {
			keysCopy.removeLast()
			jsonTree = self.node(for: keysCopy) ?? [:]
			jsonTree[$0] = node
			node = jsonTree
		}
		
		if let key = self.keys.first {
			self.json[key] = node[key]
		}
	}
	
	fileprivate static func jsonNode<T>(from value: T) -> JSON {
		
		switch value {
		case let parsable as Parsable:
			return parsable.json()
		default:
			return JSON(value as AnyObject)
		}
	}
	
	fileprivate static func object<T>(_ type: T.Type, from node: JSON) -> T? {
		
		switch type {
		case let parsable as Parsable.Type:
			return (node.type != .null) ? parsable.init(json: node) as? T : nil
		default:
			return node.object as? T
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - Operators
//
//**********************************************************************************************************

extension Parser {
	
	//**************************************************
	// MARK: - Exposed Methods
	//**************************************************
	
	public static func <-> <T>(left: inout T?, right: Parser) {
		switch right.mode {
		case .fromJSON:
			left = Parser.object(T.self, from: right.currentNode)
		default:
			if let value = left {
				right.assignNode(Parser.jsonNode(from: value))
			}
		}
		
		right.keyPath = nil
	}
	
	public static func <-> <T>(left: inout [T]?, right: Parser) {
		switch right.mode {
		case .fromJSON:
			left = right.currentNode.flatMap { Parser.object(T.self, from: $0.1) }
		default:
			if let value = left {
				right.assignNode(JSON(value.map { Parser.jsonNode(from: $0) }))
			}
		}
		
		right.keyPath = nil
	}
	
	public static func <-> <T : RawRepresentable>(left: inout T?, right: Parser) {
		switch right.mode {
		case .fromJSON:
			if let value = right.currentNode.object as? T.RawValue {
				left = T(rawValue: value)
			}
		default:
			if let value = left {
				right.assignNode(JSON(value.rawValue as AnyObject))
			}
		}
		
		right.keyPath = nil
	}
	
	public static func <-> <T>(left: inout T, right: Parser) {
		switch right.mode {
		case .fromJSON:
			if let value = Parser.object(T.self, from: right.currentNode) {
				left = value
			}
		default:
			right.assignNode(Parser.jsonNode(from: left))
		}
		
		right.keyPath = nil
	}
	
	public static func <-> <T>(left: inout [T], right: Parser) {
		switch right.mode {
		case .fromJSON:
			left = right.currentNode.flatMap { Parser.object(T.self, from: $0.1) }
		default:
			right.assignNode(JSON(left.map { Parser.jsonNode(from: $0) }))
		}
		
		right.keyPath = nil
	}
	
	public static func <-> <T : RawRepresentable>(left: inout T, right: Parser) {
		switch right.mode {
		case .fromJSON:
			if let value = right.currentNode.object as? T.RawValue, let raw = T(rawValue: value) {
				left = raw
			}
		default:
			right.assignNode(JSON(left.rawValue as AnyObject))
		}
		
		right.keyPath = nil
	}
}


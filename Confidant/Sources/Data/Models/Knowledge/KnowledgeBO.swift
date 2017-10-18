//
//  KnowledgeBO.swift
//  Confidant
//
//  Created by Michael Douglas on 12/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import ObjectMapper

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

public class KnowledgeBO: Mappable {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var id: String?
	public var topic: String?
	
//*************************************************
// MARK: - Constructors
//*************************************************
	
	public required init() { }
	
	public required init?(map: Map) { }
	
	convenience init(topic: String?) {
		self.init()
		self.topic = topic
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func mapping(map: Map) {
		self.id <- map["id"]
		self.topic <- map["topic"]
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

extension KnowledgeBO: Equatable {
	
	/// Returns a Boolean value indicating whether two values are equal.
	///
	/// Equality is the inverse of inequality. For any values `a` and `b`,
	/// `a == b` implies that `a != b` is `false`.
	///
	/// - Parameters:
	///   - lhs: A value to compare.
	///   - rhs: Another value to compare.
	public static func ==(lhs: KnowledgeBO, rhs: KnowledgeBO) -> Bool {
		let isTopicEqual = lhs.topic?.range(of: rhs.topic ?? "", options: .caseInsensitive) != nil
		
		return lhs.id == rhs.id && isTopicEqual
	}
}

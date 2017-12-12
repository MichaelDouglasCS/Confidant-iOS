//
//  KnowledgeLO.swift
//  Confidant
//
//  Created by Michael Douglas on 05/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public final class KnowledgeLO {
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private class func parse(json: JSON) -> [KnowledgeBO] {
		var knowledges: [KnowledgeBO] = []
		
		json["knowledges"].arrayValue.forEach({ json in
			
			if let knowledge = KnowledgeBO(JSON: json.dictionaryObject ?? [:]) {
				knowledges.append(knowledge)
			}
		})
		
		return knowledges
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public class func load(completionHandler: @escaping ([KnowledgeBO], ServerResponse) -> Void) {
		
		ServerRequest.Knowledge.listAll.execute() { (json, result) in
			let knowledges = self.parse(json: json)

			completionHandler(knowledges, result)
		}
	}
	
	public class func insert(knowledges: [KnowledgeBO],
	                   completionHandler: @escaping ([KnowledgeBO], ServerResponse) -> Void) {
		let params = ["knowledges": knowledges.toJSON()]
		
		ServerRequest.Knowledge.insert.execute(params: params) { (json, result) in
			let knowledges = self.parse(json: json)
			
			completionHandler(knowledges, result)
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - KnowledgeBO
//
//**********************************************************************************************************

extension KnowledgeBO {
	
	public var isSelected: Bool {
		return UsersLO.sharedInstance.current.profile.knowledges?.contains(self) ?? false
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - Array
//
//**********************************************************************************************************

extension Array where Element : KnowledgeBO {
	
	func knowledgeSorted() -> [Element] {
		// Sort Knowledge by isSelected and Alphabetical.
		let isSelected = self.filter({$0.isSelected}).sorted(by: {
			return $0.topic?.localizedCaseInsensitiveCompare($1.topic ?? "") == .orderedAscending
		})
		let isNotSelected = self.filter({!$0.isSelected}).sorted(by: {
			return $0.topic?.localizedCaseInsensitiveCompare($1.topic ?? "") == .orderedAscending
		})
		
		return isSelected + isNotSelected
	}
	
	func update(_ knowledge: KnowledgeBO) {
		self.forEach({
			if $0.topic?.range(of: knowledge.topic ?? "", options: .caseInsensitive) != nil {
				$0.id = knowledge.id
			}
		})
	}
}

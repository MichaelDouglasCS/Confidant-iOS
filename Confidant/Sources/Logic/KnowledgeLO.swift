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
		
		json.arrayValue.forEach({ json in
			
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
			let knowledge = self.parse(json: json)

			completionHandler(knowledge, result)
		}
	}
}

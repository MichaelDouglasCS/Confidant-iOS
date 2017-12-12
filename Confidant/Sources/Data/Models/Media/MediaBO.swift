//
//  MediaBO.swift
//  Confidant
//
//  Created by Michael Douglas on 22/05/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import ObjectMapper

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class MediaBO: Mappable {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	public var fileURL: String?
	public var base64: String?
	
	public var hasMedia: Bool {
		return self.base64 != nil || self.fileURL != nil
	}
	
	public var localImage: UIImage? {
		
		if let encoded = self.base64 {
			return UIImage(base64EncodedString: encoded)
		}
		
		return nil
	}
	
//*************************************************
// MARK: - Constructors
//*************************************************
	
	public required init() { }
	
	public required init?(map: Map) { }
	
	public convenience init(image: UIImage?, fileURL: String?) {
		self.init()
		self.base64 = image?.base64EncodedString() ?? ""
		self.fileURL = fileURL
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func mapping(map: Map) {
		self.fileURL <- map["fileURL"]
	}
}

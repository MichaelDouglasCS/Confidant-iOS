//
//  MediaLO.swift
//  Confidant
//
//  Created by Michael Douglas on 05/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public final class MediaLO {

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private class func parse(json: JSON) -> MediaBO {
		let media = MediaBO(JSON: json.dictionaryObject ?? [:])
		
		return media ?? MediaBO()
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public class func upload(data: Data,
	                         fieldName: String,
	                         fileName: String,
	                         mimeType: String,
	                         completionHandler: @escaping (MediaBO, ServerResponse) -> Void) {
		
		ServerRequest.Media.upload.execute(data: data,
		                                   fieldName: fieldName,
		                                   fileName: fileName,
		                                   mimeType: mimeType) { (json, result) in
											let media = self.parse(json: json)
											
											completionHandler(media, result)
		}
	}
	
	public class func downloadImage(from url: String,
	                         completionHandler: @escaping (UIImage?, ServerResponse) -> Void) {
		
		Alamofire.request(url).responseImage { response in
			let serverResponse = ServerResponse(response.response)
			
			switch serverResponse {
			case .success:
				completionHandler(response.result.value, serverResponse)
			case .error:
				completionHandler(response.result.value, .error(.pictureNotUpdated))
			}
		}
	}
}

//
//  ChatLO.swift
//  Confidant
//
//  Created by Michael Douglas on 28/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SwiftyJSON

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

extension NSNotification.Name {
	public static let chatsDidUpdate = NSNotification.Name(rawValue: "ChatsDidUpdate")
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public final class ChatLO {
	
//**************************************************
// MARK: - Properties
//**************************************************
	
	public var current: ChatBO?
	
	static public let sharedInstance: ChatLO = ChatLO()

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func startConversation(with chat: ChatBO, completionHandler: @escaping ((Bool) -> Void)) {
		
		SocketLO.sharedInstance.socket.emitWithAck("startConversation", with: [chat.toJSON()])
			.timingOut(after: 0) { (response) in
				
				if let json = JSON(response.first as Any).dictionaryObject,
					let chat = ChatBO(JSON: json) {
					
					if chat.confidantProfile != nil {
						UsersLO.sharedInstance.current.profile.chats?.append(chat)
						NotificationCenter.default.post(name: .chatsDidUpdate, object: nil)
						completionHandler(true);
					} else {
						completionHandler(false);
					}
				} else {
					completionHandler(false);
				}
		}
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

}

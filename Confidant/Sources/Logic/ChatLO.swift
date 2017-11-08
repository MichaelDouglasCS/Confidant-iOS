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
	public static let messagesDidUpdate = NSNotification.Name(rawValue: "MessagesDidUpdate")
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
// MARK: - Constructors
//*************************************************

	init() { self.listenMessages() }
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func listenMessages() {
		
		SocketLO.sharedInstance.socket.on("message") { (data, ack) in
			let json = JSON(data.first as Any)
			let message = MessageBO(JSON: json.dictionaryObject ?? [:])
			
			if let message = message {
				ChatLO.sharedInstance.current?.messages?.append(message)
				NotificationCenter.default.post(name: .messagesDidUpdate, object: nil)
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func startConversation(with chat: ChatBO, completionHandler: @escaping ((Bool) -> Void)) {
		
		SocketLO.sharedInstance.socket.emitWithAck("startConversation", chat.toJSON())
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
	
	public func sendMessage(with content: String?) {
		let userID = UsersLO.sharedInstance.current.id
		let chat = ChatLO.sharedInstance.current
		let recipientID = userID == chat?.userProfile?.id ? chat?.confidantProfile?.id : chat?.userProfile?.id
		
		let message = MessageBO(timestamp: Date().timeIntervalSince1970,
		                        recipientID: recipientID,
		                        senderID: userID,
		                        content: content)

		SocketLO.sharedInstance.socket.emit("sendMessage", message.toJSON())
		ChatLO.sharedInstance.current?.messages?.append(message)
		NotificationCenter.default.post(name: .messagesDidUpdate, object: nil)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

}

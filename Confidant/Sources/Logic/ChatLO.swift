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
				let user = UsersLO.sharedInstance.current
				let chat = ChatLO.sharedInstance.current
				
				if message.chatID == chat?.id {
					chat?.messages?.append(message)
					chat?.updatedDate = Date().timeIntervalSince1970
				} else {
					
					if let chat = user.profile.chats?.filter({ message.chatID == $0.id }).last {
						chat.messages?.append(message)
						chat.updatedDate = Date().timeIntervalSince1970
					}
				}
				
				NotificationCenter.default.post(name: .chatsDidUpdate, object: nil)
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func startConversation(with chat: ChatBO, completionHandler: @escaping ((Bool) -> Void)) {
		chat.id = UUID().uuidString
		
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
		
		let message = MessageBO(id: UUID().uuidString,
		                        chatID: chat?.id,
		                        timestamp: Date().timeIntervalSince1970,
		                        recipientID: recipientID,
		                        senderID: userID,
		                        content: content)

		SocketLO.sharedInstance.socket.emit("sendMessage", message.toJSON())
		
		chat?.messages?.append(message)
		chat?.updatedDate = Date().timeIntervalSince1970
		NotificationCenter.default.post(name: .chatsDidUpdate, object: nil)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

}

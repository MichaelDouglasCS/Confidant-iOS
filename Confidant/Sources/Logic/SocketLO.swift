//
//  SocketLO.swift
//  Confidant
//
//  Created by Michael Douglas on 23/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import Foundation
import SocketIO
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

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public final class SocketLO {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	static public let sharedInstance: SocketLO = SocketLO()
	
	public lazy var socket: SocketIOClient = {
		typealias domain = ServerRequest.Domain
		var url = URL(string: "")
		
		switch domain.mobile {
		case domain.local:
			url = URL(string: "http://localhost:3000")
		case domain.develop:
			url = URL(string: "https://confidant-api.herokuapp.com")
		default:
			break
		}
		
		return SocketIOClient(socketURL: url!)
	}()
	
//*************************************************
// MARK: - Constructors
//*************************************************
	
	private init() { }
	
//*************************************************
// MARK: - Protected Methods
//*************************************************

	private func updateSocket() {
		
		if let id = UsersLO.sharedInstance.current.id {
			self.socket.on("updateSocket") { (data, ack) in
				ack.with([id])
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	public func establishConnection() {
		self.socket.connect()
		self.updateSocket()
	}
	
	public func closeConnection() {
		self.socket.disconnect()
	}
	
	public func updateSocketUser() {
		
		if let id = UsersLO.sharedInstance.current.id {
			self.socket.emit("updateSocketUser", [id])
		}
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

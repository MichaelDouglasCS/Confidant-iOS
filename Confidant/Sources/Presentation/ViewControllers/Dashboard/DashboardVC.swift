//
//  DashboardVC.swift
//  Confidant
//
//  Created by Michael Douglas on 22/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
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

class DashboardVC: UITabBarController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	private enum TabBarVC: Int {
		case userVC = 1
		case confidantVC = 2
	}

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupTabBarItems() {
		
		if let typeOfUser = UsersLO.sharedInstance.current.profile.typeOfUser {
			
			switch typeOfUser {
			case .user:
				self.viewControllers?.remove(at: DashboardVC.TabBarVC.confidantVC.rawValue)
				self.selectedIndex = DashboardVC.TabBarVC.userVC.rawValue
			case .confidant:
				self.viewControllers?.remove(at: DashboardVC.TabBarVC.userVC.rawValue)
			}
		}
	}
	
	private func showConfidantAlertChat(by: ProfileBO?) {
		let alert = ConfidantChatAlertView(frame: self.view.frame, fromNib: true)
		
		self.view.addSubview(alert)
		alert.delegate = self
		alert.showingAnimate()
	}
	
	private func removeConfidantAlertChat() {
		self.view.subviews.forEach({ (subView) in
			
			if let view = subView as? ConfidantChatAlertView {
				
				view.hiddenAnimate(completion: { _ in
					view.removeFromSuperview()
				})
			}
		})
	}
	
	private func addNotificationsListener() {
		let currentUser = UsersLO.sharedInstance.current
		
		if let confidantID = currentUser.id, currentUser.profile.typeOfUser == .confidant {

			SocketLO.sharedInstance.socket.on("match: \(confidantID)") { (data, ack) in
				let json = JSON(data.first as Any)
				let profile = ProfileBO(JSON: json.dictionaryObject ?? [:])
				
				self.showConfidantAlertChat(by: profile)
			}
		}
	}
	
	fileprivate func handleConfidantSelection(_ isYes: Bool) {
		
		switch isYes {
		case true:
			self.removeConfidantAlertChat()
		case false:
			self.removeConfidantAlertChat()
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTabBarItems()
		self.addNotificationsListener()
		UIApplication.shared.statusBarStyle = .lightContent
    }
}

//**********************************************************************************************************
//
// MARK: - Extension - ConfidantChatAlertDelegate
//
//**********************************************************************************************************

extension DashboardVC: ConfidantChatAlertDelegate {
	
	func chatAlert(_ chatAlert: ConfidantChatAlertView, didSelectAnswer isYes: Bool) {
		self.handleConfidantSelection(isYes)
	}
}

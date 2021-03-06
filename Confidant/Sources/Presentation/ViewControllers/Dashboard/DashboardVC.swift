//
//  DashboardVC.swift
//  Confidant
//
//  Created by Michael Douglas on 22/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON

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
	
	private var confidantAlertChatCallback: SocketAckEmitter?

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupTabBarItems() {
		
		if let typeOfUser = UsersLO.sharedInstance.current.profile.typeOfUser {
			switch typeOfUser {
			case .user:
				self.viewControllers?.remove(at: DashboardVC.TabBarVC.confidantVC.rawValue)
			case .confidant:
				self.viewControllers?.remove(at: DashboardVC.TabBarVC.userVC.rawValue)
			}
			self.selectedIndex = 1
		}
	}
	
	private func showConfidantAlert(by model: ChatBO?) {
		let alert = ConfidantChatAlertView(frame: self.view.frame, fromNib: true)
		
		alert.updateLayout(for: model)
		alert.delegate = self
		self.view.addSubview(alert)
		alert.showingAnimate()
	}
	
	private func showConfidantAlert() {
		self.view.subviews.forEach({ (subView) in
			
			if let view = subView as? ConfidantChatAlertView {
				
				view.hiddenAnimate(completion: { _ in
					view.removeFromSuperview()
				})
			}
		})
	}
	
	private func addNotificationsListener() {
		
		SocketLO.sharedInstance.socket.on("match") { (data, ack) in
			let json = JSON(data.first as Any)
			let chat = ChatBO(JSON: json.dictionaryObject ?? [:])
			
			self.showConfidantAlert(by: chat)
			self.confidantAlertChatCallback = ack
		}
	}
	
	fileprivate func handleConfidantSelection(_ chat: ChatBO?) {
		self.confidantAlertChatCallback?.with([chat?.toJSON()])
		self.showConfidantAlert()
		
		if chat != nil {
			self.selectedIndex = 0
		}
	}
	
	@objc fileprivate func popToRootLogin() {
		UsersLO.sharedInstance.logout()
		self.performSegue(withIdentifier: "showLoginSegue", sender: self)
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
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.popToRootLogin),
		                                       name: .userDidLogout,
		                                       object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		NotificationCenter.default.removeObserver(self)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - ConfidantChatAlertDelegate
//
//**********************************************************************************************************

extension DashboardVC: ConfidantChatAlertDelegate {
	
	func chatAlert(_ chatAlert: ConfidantChatAlertView, didSelectAnswer chat: ChatBO?) {
		self.handleConfidantSelection(chat)
	}
}

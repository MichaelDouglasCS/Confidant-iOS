//
//  DashboardVC.swift
//  Confidant
//
//  Created by Michael Douglas on 22/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

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

//*************************************************
// MARK: - Exposed Methods
//*************************************************

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.setupTabBarItems()
		
		UIApplication.shared.statusBarStyle = .lightContent
    }
}

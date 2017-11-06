//
//  ChatVC.swift
//  Confidant
//
//  Created by Michael Douglas on 03/11/17.
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

class ChatVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var pictureView: CircularImage!
	@IBOutlet weak var nameLabel: LocalizedLabel!
	@IBOutlet weak var statusLabel: LocalizedLabel!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupLayout() {
		let user = UsersLO.sharedInstance.current
		let chat = ChatLO.sharedInstance.current
		
		if let typeOfUser = user.profile.typeOfUser {
			switch typeOfUser {
			case .user:
				self.pictureView.image = chat?.confidantProfile?.picture?.localImage
				self.nameLabel.text = chat?.confidantProfile?.nickname
				self.statusLabel.text = "Online"
			case .confidant:
				self.pictureView.image = chat?.userProfile?.picture?.localImage
				self.nameLabel.text = chat?.userProfile?.nickname
				self.statusLabel.text = "Online"
			}
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func backAction(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func finishAction(_ sender: LocalizedBarButton) {
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupLayout()
    }
}

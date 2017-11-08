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
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var sendButton: LocalizedButton!
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupTableView() {
		self.tableView.scrollsToTop = true
		self.tableView.rowHeight = UITableViewAutomaticDimension
		self.tableView.estimatedRowHeight = 30.0
	}
	
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
	
	@objc private func refreshData() {
		self.tableView.reloadSections(IndexSet(integer: 0), with: .bottom)
	}
	
	private func sendMessage() {
		ChatLO.sharedInstance.sendMessage(with: self.textField.text)
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func backAction(_ sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func sendAction(_ sender: LocalizedButton) {
		self.sendMessage()
	}
	

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupTableView()
		self.setupLayout()
		self.makeTapGestureEndEditing()
		self.addKeyboardObservers()
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.refreshData),
		                                       name: .messagesDidUpdate,
		                                       object: nil)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.removeObservers()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITableViewDataSource
//
//**********************************************************************************************************

extension ChatVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ChatLO.sharedInstance.current?.messages?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		
		if let userID = UsersLO.sharedInstance.current.id,
			let message = ChatLO.sharedInstance.current?.messages?[indexPath.row] {
			
			if userID == message.senderID {
				
				if let messageRight = tableView.cellFromXIB(withIdentifier: CellID.messageRight)
					as? MessageRightCell {
					messageRight.updateLayout(for: message)
					cell = messageRight
				}
			} else {
				
				if let messageLeft = tableView.cellFromXIB(withIdentifier: CellID.messageLeft)
					as? MessageLeftCell {
					messageLeft.updateLayout(for: message)
					cell = messageLeft
				}
			}
		}
		
		return cell
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - KeyboardSizeAdjuster
//
//**********************************************************************************************************

extension ChatVC: KeyboardSizeAdjuster {
	
	func keyboardWillTake(frame: CGRect) {
		let converted = self.view.convert(frame, from: nil)
		let distance = self.view.frame.size.height - converted.origin.y
		self.bottomConstraint.constant = distance
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
}


//
//  ChatsVC.swift
//  Confidant
//
//  Created by Michael Douglas on 01/11/17.
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

class ChatsVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var searchBar: LocalizedSearchBar!
	@IBOutlet weak var tableView: UITableView!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupTableView() {
		self.tableView.scrollsToTop = true
		self.tableView.rowHeight = 70.0
		self.tableView.tableFooterView = UIView()
	}
	
	@objc private func refreshData() {
		self.tableView.reloadSections(IndexSet(integer: 0), with: .top)
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupTableView()
		self.makeTapGestureEndEditing()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(self.refreshData),
		                                       name: .chatsDidUpdate,
		                                       object: nil)
	}
	
	deinit {
		self.removeObservers()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITableViewDataSource
//
//**********************************************************************************************************

extension ChatsVC: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return UsersLO.sharedInstance.current.profile.chats?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		
		if let chatCell = tableView.cellFromXIB(withIdentifier: CellID.chat) as? ChatCell {
			let chat = UsersLO.sharedInstance.current.profile.chats?[indexPath.row]
			
			chatCell.updateLayout(for: chat)
			cell = chatCell
		}
		
		return cell
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITableViewDelegate
//
//**********************************************************************************************************

extension ChatsVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
	}
}

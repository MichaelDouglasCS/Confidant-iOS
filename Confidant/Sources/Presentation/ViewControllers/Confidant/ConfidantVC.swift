//
//  ConfidantVC.swift
//  Confidant
//
//  Created by Michael Douglas on 30/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ConfidantVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var knowledgeData: [KnowledgeBO] = []
	private let searchSegue: String = "showSearchSegue"
	
	@IBOutlet weak var profilePictureView: CircularImage!
	@IBOutlet weak var isOnlineFlag: UIBox!
	@IBOutlet weak var nicknameLabel: LocalizedLabel!
	@IBOutlet weak var switchAvailability: UISwitch!
	@IBOutlet weak var collectionView: UICollectionView!
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupCollectionView() {
		self.collectionView.allowsMultipleSelection = true
		
		if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.estimatedItemSize = CGSize(width: 70.0, height: 35.0)
		}
	}
	
	fileprivate func searchAction() {
		self.performSegue(withIdentifier: self.searchSegue, sender: nil)
	}
	
	private func didUpdateAvailability() {
		let user = UsersLO.sharedInstance.current
		
		self.isOnlineFlag.isHidden = !(user.profile.isAvailable ?? true)
		self.switchAvailability.isOn = user.profile.isAvailable ?? false
	}
	
	private func loadData() {
		let user = UsersLO.sharedInstance.current
		
		if let profilePicture = user.profile.picture?.localImage {
			self.profilePictureView.image = profilePicture
		} else {
			
			self.profilePictureView.loadingIndicatorView(isShow: true)
			UsersLO.sharedInstance.downloadPicture() { (result) in
				
				switch result {
				case .success:
					self.profilePictureView.image = user.profile.picture?.localImage
				default:
					break
				}
				
				self.profilePictureView.loadingIndicatorView(isShow: false)
			}
		}
		
		self.didUpdateAvailability()
		self.nicknameLabel.text = user.profile.nickname
		self.collectionView.loadingIndicatorView(isShow: true, isLarge: true)
		
		KnowledgeLO.load() { (knowledges, result) in
			
			switch result {
			case .success:
				self.knowledgeData = knowledges
				self.didReloadData()
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.collectionView.loadingIndicatorView(isShow: false)
		}
	}
	
	fileprivate func didReloadData() {
		self.knowledgeData = self.knowledgeData.knowledgeSorted()
		self.collectionView.reloadSections(IndexSet(integer: 0))
	}
	
	private func updateUser() {
		let user = UsersLO.sharedInstance.current
		
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			switch result {
			case .success:
				self.collectionView.reloadSections(IndexSet(integer: 0))
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.collectionView.loadingIndicatorView(isShow: false, isLarge: true)
		}
	}
	
	fileprivate func updateKnowledges() {
		let newKnowledges = self.knowledgeData.filter({ $0.id == nil && $0.isSelected })
		
		self.collectionView.loadingIndicatorView(isShow: true, isLarge: true)
		
		if newKnowledges.count != 0 {
			
			KnowledgeLO.insert(knowledges: newKnowledges) { (knowledges, result) in
				
				switch result {
				case .success:
					self.knowledgeData = knowledges
					knowledges.forEach({ knowledge in
						UsersLO.sharedInstance.current.profile.knowledges?.update(knowledge)
					})
					self.updateUser()
				case .error(let error):
					self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
				}
			}
		} else {
			self.updateUser()
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func changeAvailabilityAction(_ sender: UISwitch) {
		self.switchAvailability.loadingIndicatorView(isShow: true)
		
		UsersLO.sharedInstance.changeAvailability() { (result) in
			
			switch result {
			case .success:
				self.didUpdateAvailability()
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.switchAvailability.loadingIndicatorView(isShow: false)
		}
	}
	
	@IBAction func refreshKnowledges(_ sender: UIBarButtonItem) {
		self.loadData()
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupCollectionView()
		self.loadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.statusBarStyle = .lightContent
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == self.searchSegue {
			
			if let searchVC = segue.destination as? SearchKnowledgesVC,
				let selectedKnowledges = UsersLO.sharedInstance.current.profile.knowledges{
				
				searchVC.delegate = self
				searchVC.knowledgeData = self.knowledgeData.filter({ !selectedKnowledges.contains($0) })
			}
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UISearchBarDelegate
//
//**********************************************************************************************************

extension ConfidantVC: UISearchBarDelegate {
	
	func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
		self.searchAction()
		return false
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - SearchKnowledgesDelegate
//
//**********************************************************************************************************

extension ConfidantVC: SearchKnowledgesDelegate {
	
	func search(_ search: SearchKnowledgesVC, didUpdateKnowledges newKnowledge: KnowledgeBO) {
		
		if self.knowledgeData.contains(newKnowledge) {
			
			if let index = self.knowledgeData.index(where: { $0.topic?.range(of: newKnowledge.topic ?? "",
			                                                                 options: .caseInsensitive) != nil }) {
				
				if !self.knowledgeData[index].isSelected {
					UsersLO.sharedInstance.current.profile.knowledges?.append(self.knowledgeData[index])
				}
			}
		} else {
			self.knowledgeData.append(newKnowledge)
			UsersLO.sharedInstance.current.profile.knowledges?.append(newKnowledge)
		}
		
		self.didReloadData()
		self.updateKnowledges()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension ConfidantVC: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.knowledgeData.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if let knowledgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.knowledgeCell,
		                                                          for: indexPath) as? KnowledgeCell {
			knowledgeCell.updateLayout(for: self.knowledgeData[indexPath.row])
			cell = knowledgeCell
		}
		
		if self.knowledgeData[indexPath.row].isSelected {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
			cell.isSelected = true
		}
		
		return cell
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDelegate
//
//**********************************************************************************************************

extension ConfidantVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		UsersLO.sharedInstance.current.profile.knowledges?.append(self.knowledgeData[indexPath.row])
		self.updateKnowledges()
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let knowledge = self.knowledgeData[indexPath.row]
		let knowledges = UsersLO.sharedInstance.current.profile.knowledges
		
		if let index = knowledges?.index(where: { $0.topic?.range(of: knowledge.topic ?? "",
		                                                          options: .caseInsensitive) != nil }) {
			UsersLO.sharedInstance.current.profile.knowledges?.remove(at: index)
			self.updateKnowledges()
		}
	}
}

//
//  KnowledgeVC.swift
//  Confidant
//
//  Created by Michael Douglas on 12/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class KnowledgeVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var knowledgeData: [KnowledgeBO] = []
	private let searchSegue: String = "showSearchSegue"
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var continueButton: IBDesigableButton!

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupCollectionView() {
		self.collectionView.allowsMultipleSelection = true
		
		if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.estimatedItemSize = CGSize(width: 70.0, height: 35.0)
		}
	}
	
	@objc private func loadData() {
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
	
	fileprivate func isContinueEnabled() {
		self.continueButton.isEnabled = UsersLO.sharedInstance.current.profile.knowledges?.count != 0
	}
	
	fileprivate func didReloadData() {
		self.knowledgeData = self.knowledgeData.knowledgeSorted()
		self.collectionView.reloadSections(IndexSet(integer: 0))
		self.isContinueEnabled()
	}
	
	fileprivate func searchAction() {
		self.performSegue(withIdentifier: self.searchSegue, sender: nil)
	}
	
	private func showNextVC() {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: "showGoOnlineSegue", sender: nil)
		}
	}
	
	private func updateUser() {
		let user = UsersLO.sharedInstance.current
		
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			switch result {
			case .success:
				self.showNextVC()
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.loadingIndicatorCustom(isShow: false)
		}
	}
	
	private func updateKnowledges() {
		self.loadingIndicatorCustom(isShow: true)
		let newKnowledges = self.knowledgeData.filter({ $0.id == nil && $0.isSelected })
		
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
	
	@IBAction func backAction(_ sender: LocalizedButton) {
		let knowledges = UsersLO.sharedInstance.current.profile.knowledges
		
		knowledges?.forEach({
			
			if $0.id == nil {
				
				if let index = knowledges?.index(of: $0) {
					UsersLO.sharedInstance.current.profile.knowledges?.remove(at: index)
				}
			}
		})
		
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func continueAction(_ sender: IBDesigableButton) {
		self.updateKnowledges()
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupCollectionView()
		self.loadData()
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

extension KnowledgeVC: UISearchBarDelegate {
	
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

extension KnowledgeVC: SearchKnowledgesDelegate {
	
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
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension KnowledgeVC: UICollectionViewDataSource {
	
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

extension KnowledgeVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		UsersLO.sharedInstance.current.profile.knowledges?.append(self.knowledgeData[indexPath.row])
		self.isContinueEnabled()
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let knowledge = self.knowledgeData[indexPath.row]
		let knowledges = UsersLO.sharedInstance.current.profile.knowledges
		
		if let index = knowledges?.index(where: { $0.topic?.range(of: knowledge.topic ?? "",
		                                                        options: .caseInsensitive) != nil }) {
			UsersLO.sharedInstance.current.profile.knowledges?.remove(at: index)
			self.isContinueEnabled()
		}
	}
}

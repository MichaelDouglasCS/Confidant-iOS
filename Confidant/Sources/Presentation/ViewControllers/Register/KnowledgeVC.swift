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

class KnowledgeVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var knowledgeData: [KnowledgeBO] = []
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var continueButton: IBDesigableButton!

//*************************************************
// MARK: - Constructors
//*************************************************

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
				self.didReload()
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue)
			}
			
			self.collectionView.loadingIndicatorView(isShow: false)
		}
	}
	
	private func didReload() {
		let selections = self.collectionView.indexPathsForSelectedItems
		
		self.collectionView.reloadSections(IndexSet(integer: 0))
		selections?.forEach {
			if $0.section < self.collectionView.numberOfSections &&
				$0.row < self.collectionView.numberOfItems(inSection: $0.section) {
				self.collectionView.selectItem(at: $0,
				                               animated: false,
				                               scrollPosition: .left)
			}
		}
	}
	
	fileprivate func isContinueEnabled() {
		self.continueButton.isEnabled = UsersLO.sharedInstance.current.profile.knowledges?.count != 0
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func backAction(_ sender: LocalizedButton) {
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func continueAction(_ sender: IBDesigableButton) {
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		self.setupCollectionView()
		self.loadData()
    }
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension KnowledgeVC : UICollectionViewDataSource {
	
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
		
		return cell
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDelegate
//
//**********************************************************************************************************

extension KnowledgeVC : UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if UsersLO.sharedInstance.current.profile.knowledges == nil {
			UsersLO.sharedInstance.current.profile.knowledges = []
		}
		
		UsersLO.sharedInstance.current.profile.knowledges?.append(self.knowledgeData[indexPath.row])
		self.isContinueEnabled()
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		let knowledge = self.knowledgeData[indexPath.row]
		
		if let index = UsersLO.sharedInstance.current.profile.knowledges?.index(where: {$0.topic == knowledge.topic}) {
			UsersLO.sharedInstance.current.profile.knowledges?.remove(at: index)
			self.isContinueEnabled()
		}
	}
}

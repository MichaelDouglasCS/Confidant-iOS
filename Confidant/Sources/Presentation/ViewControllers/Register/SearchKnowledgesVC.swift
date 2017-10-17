//
//  SearchKnowledgesVC.swift
//  Confidant
//
//  Created by Michael Douglas on 16/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class SearchKnowledgesVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var searchTopic: String = ""
	fileprivate var knowledgeFiltered: [KnowledgeBO] = []
	
	@IBOutlet weak var searchBar: LocalizedSearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var knowledgeData: [KnowledgeBO] = []

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
	
	private func setupLayout() {
		self.searchBar.setShowsCancelButton(true, animated: true)
		self.searchBar.becomeFirstResponder()
	}
	
	fileprivate func didReloadData() {
		UIView.performWithoutAnimation {
			self.collectionView.reloadSections(IndexSet(integer: 0))
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
		self.setupCollectionView()
		
		UIApplication.shared.statusBarStyle = .lightContent
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setupLayout()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		UIApplication.shared.statusBarStyle = .default
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UISearchBarDelegate
//
//**********************************************************************************************************

extension SearchKnowledgesVC: UISearchBarDelegate {
	
	fileprivate func enableCancelButton (searchBar : UISearchBar) {
		for searchSubview in searchBar.subviews {
			for view in searchSubview.subviews {
				if view.isKind(of: UIButton.self) {
					if let button = view as? UIButton {
						button.isEnabled = true
						button.isUserInteractionEnabled = true
					}
				}
			}
		}
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchTopic = searchText
		self.knowledgeFiltered = self.knowledgeData.filter({ (knowledge) in
			let topic = knowledge.topic as NSString?
			let range = topic?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
			
			return range?.location != NSNotFound
		})
		
		self.didReloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.view.endEditing(true)
		self.enableCancelButton(searchBar: searchBar)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.dismiss(animated: true, completion: nil)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension SearchKnowledgesVC: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		let numberOfItems = !self.knowledgeFiltered.isEmpty || self.searchTopic.isEmpty ? self.knowledgeFiltered.count : 1
		return numberOfItems
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if let knowledgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.knowledgeCell,
		                                                          for: indexPath) as? KnowledgeCell {
			var model: KnowledgeBO?
			
			if !self.knowledgeFiltered.isEmpty {
				model = self.knowledgeFiltered[indexPath.row]
			} else {
				model = KnowledgeBO(topic: self.searchTopic)
			}
			
			knowledgeCell.updateLayout(for: model)
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

extension SearchKnowledgesVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if UsersLO.sharedInstance.current.profile.knowledges == nil {
			UsersLO.sharedInstance.current.profile.knowledges = []
		}
		
		UsersLO.sharedInstance.current.profile.knowledges?.append(self.knowledgeData[indexPath.row])
	}
}

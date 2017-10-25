//
//  SearchTopicsVC.swift
//  Confidant
//
//  Created by Michael Douglas on 16/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

protocol SearchTopicsDelegate : class {
	func search(_ search: SearchTopicsVC, didUpdateKnowledges newKnowledge: KnowledgeBO)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class SearchTopicsVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var knowledgeFiltered: [KnowledgeBO] = []
	
	@IBOutlet weak var searchBar: LocalizedSearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var knowledgeData: [KnowledgeBO] = []
	
	weak var delegate: SearchTopicsDelegate?

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupCollectionView() {
		
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
// MARK: - Overridden Public Methods
//*************************************************
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupCollectionView()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.setupLayout()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UISearchBarDelegate
//
//**********************************************************************************************************

extension SearchTopicsVC: UISearchBarDelegate {
	
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
		let filtered = self.knowledgeData.filter({ (knowledge) in
			let topic = knowledge.topic as NSString?
			let range = topic?.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
			
			return range?.location != NSNotFound
		})

		self.knowledgeFiltered = filtered
		self.didReloadData()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		self.dismissKeyboard()
		self.enableCancelButton(searchBar: searchBar)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.dismissKeyboard()
		self.dismiss(animated: true, completion: nil)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension SearchTopicsVC: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.knowledgeFiltered.count
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		var cell = UICollectionViewCell()
		
		if let knowledgeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.knowledgeCell,
		                                                          for: indexPath) as? KnowledgeCell {
			knowledgeCell.updateLayout(for: self.knowledgeFiltered[indexPath.row])
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

extension SearchTopicsVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.dismissKeyboard()
		self.delegate?.search(self, didUpdateKnowledges: self.knowledgeFiltered[indexPath.row])
		self.dismiss(animated: true, completion: nil)
	}
}
//
//  UserVC.swift
//  Confidant
//
//  Created by Michael Douglas on 23/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class UserVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var knowledgeData: [KnowledgeBO] = []
	fileprivate var selectedKnowledge: KnowledgeBO?
	private let searchSegue: String = "showSearchSegue"
	
	@IBOutlet weak var searchBar: LocalizedSearchBar!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var reasonTextView: UITextView!
	@IBOutlet weak var findButton: IBDesigableButton!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var bottomConstraint: NSLayoutConstraint!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupCollectionView() {
		
		if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.estimatedItemSize = CGSize(width: 70.0, height: 35.0)
		}
	}
	
	fileprivate func isFindEnabled() {
		self.findButton.isEnabled = self.selectedKnowledge != nil
	}
	
	fileprivate func searchAction() {
		self.performSegue(withIdentifier: self.searchSegue, sender: nil)
	}
	
	private func proceedToNextVC() {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: "showGoOnlineSegue", sender: nil)
		}
	}
	
	private func showLoadingAlert() {
		let alert = UserSearchingAlertView(frame: self.view.frame, fromNib: true)
		
		alert.delegate = self
		self.tabBarController?.view.addSubview(alert)
		alert.showingAnimate()
	}
	
	fileprivate func removeLoadingAlert() {
		self.tabBarController?.view.subviews.forEach({ (subView) in
			
			if let view = subView as? UserSearchingAlertView {
				
				view.hiddenAnimate(completion: { _ in
					view.removeFromSuperview()
				})
			}
		})
	}
	
	private func loadData() {
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
		self.collectionView.reloadSections(IndexSet(integer: 0))
		self.isFindEnabled()
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func findAction(_ sender: IBDesigableButton) {
		self.showLoadingAlert()
		
		let user = UsersLO.sharedInstance.current
		let chat = ChatBO()
		
		chat.createdDate = Date().timeIntervalSince1970
		chat.updatedDate = Date().timeIntervalSince1970
		chat.userProfile = ChatProfileBO(id: user.id,
		                                 nickname: user.profile.nickname,
		                                 picture: user.profile.picture)
		chat.reason = self.reasonTextView.text
		chat.knowledge = self.selectedKnowledge
		
		ChatLO.sharedInstance.startConversation(with: chat) { (isStart) in
			
			self.removeLoadingAlert()
			
			if isStart {
				self.tabBarController?.selectedIndex = 0
			} else {
				self.showInfoAlert(title: String.Local.sorry, message: "No Confidant Available")
			}
		}
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
		self.addKeyboardObservers()
		self.makeTapGestureEndEditing()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.removeObservers()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == self.searchSegue {
			
			if let searchVC = segue.destination as? SearchTopicsVC {
				let selectedKnowledge = self.selectedKnowledge
				
				searchVC.delegate = self
				searchVC.knowledgeData = self.knowledgeData.filter({ $0 != selectedKnowledge })
			}
		}
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UISearchBarDelegate
//
//**********************************************************************************************************

extension UserVC: UISearchBarDelegate {
	
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

extension UserVC: SearchTopicsDelegate {
	
	func search(_ search: SearchTopicsVC, didUpdateKnowledges newKnowledge: KnowledgeBO) {
		
		if let index = self.knowledgeData.index(of: newKnowledge) {
			self.selectedKnowledge = self.knowledgeData[index]
		}
		
		self.didReloadData()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UICollectionViewDataSource
//
//**********************************************************************************************************

extension UserVC: UICollectionViewDataSource {
	
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
		
		if let selectedKnowledge = self.selectedKnowledge,
			selectedKnowledge == self.knowledgeData[indexPath.row] {
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

extension UserVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.selectedKnowledge = self.knowledgeData[indexPath.row]
		self.isFindEnabled()
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		self.selectedKnowledge = nil
		self.isFindEnabled()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UserSearchingAlertDelegate
//
//**********************************************************************************************************

extension UserVC: UserSearchingAlertDelegate {
	
	func didSelectCancel(_ searchingAlert: UserSearchingAlertView) {
		self.removeLoadingAlert()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - KeyboardSizeAdjuster
//
//**********************************************************************************************************

extension UserVC: KeyboardSizeAdjuster {
	
	func keyboardWillTake(frame: CGRect) {
		let converted = self.view.convert(frame, from: nil)
		let distance = self.view.frame.size.height - converted.origin.y
		self.bottomConstraint.constant = distance
		
		if distance != 0 {
			self.scrollView.scrollToOffset(for: self.reasonTextView)
		}
		
		self.view.layoutIfNeeded()
	}
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return !(touch.view?.isDescendant(of: self.collectionView) ?? false)
	}
}

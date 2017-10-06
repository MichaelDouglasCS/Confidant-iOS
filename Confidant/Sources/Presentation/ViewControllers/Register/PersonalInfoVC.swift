//
//  PersonalInfoVC.swift
//  Confidant
//
//  Created by Michael Douglas on 02/10/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import Alamofire

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class PersonalInfoVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var isUploading: Bool = false
	
	fileprivate var isConfirmEnabled: Bool {
		get {
			return self.continueButton.isEnabled
		}
		
		set {
			self.continueButton.isEnabled = newValue
		}
	}
	
	@IBOutlet weak var backButton: LocalizedButton!
	@IBOutlet weak var profilePictureView: UIStackView!
	@IBOutlet weak var profilePicture: IBDesigableImageView!
	@IBOutlet weak var nicknameTextField: LocalizedTextField!
	@IBOutlet weak var continueButton: IBDesigableButton!

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func loadData() {
		
		if let picture = UsersLO.sharedInstance.current.profile.picture {
			
			if let localImage = picture.localImage {
				self.profilePicture.image = localImage
			} else {
				self.profilePicture.loadingIndicatorView(isShow: true, at: nil)
				
				UsersLO.sharedInstance.downloadPicture() { (result) in
					
					switch result {
					case .success:
						self.profilePicture.image = picture.localImage
					case .error(let error):
						self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
					}
					
					self.profilePicture.loadingIndicatorView(isShow: false, at: nil)
				}
			}
		}
	}
	
	@objc private func choosePicture() {
		//TODO: Add "picture" to backend
		let camera = CameraController()
		let options = [.camera, .photoLibrary] as [UIImagePickerControllerSourceType]
		let hasPhoto = UsersLO.sharedInstance.current.profile.picture?.hasMedia ?? false
		
		camera.presentOptions(at: self, options: options, remove: hasPhoto) { (image: UIImage?) in
			self.profilePicture.loadingIndicatorView(isShow: true, at: nil)
			self.isConfirmEnabled = false

			if let image = image {
				self.isUploading = true
				UsersLO.sharedInstance.upload(picture: image) { (result) in
					
					switch result {
					case .success:
						self.profilePicture.image = image
					case .error(let error):
						self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
					}
					
					self.profilePicture.loadingIndicatorView(isShow: false, at: nil)
					self.isConfirmEnabled = self.nicknameTextField.hasText
					self.isUploading = false
				}
			} else {
				self.profilePicture.loadingIndicatorView(isShow: false, at: nil)
				self.isConfirmEnabled = self.nicknameTextField.hasText
				self.profilePicture.image = UIImage(named: "icn_anchor_gray")
				
				UsersLO.sharedInstance.current.profile.picture = nil
			}
		}
	}
	
	private func updateAndContinue() {
		let user = UsersLO.sharedInstance.current
		
		self.loadingIndicatorCustom(isShow: true)
		
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			switch result {
			case .success:
				
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "showKnowledgeSegue", sender: nil)
				}
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
			
			self.loadingIndicatorCustom(isShow: false)
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func backAction(_ sender: LocalizedButton) {
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func continueButtonAction(_ sender: IBDesigableButton) {
		self.updateAndContinue()
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.loadData()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.choosePicture))
		self.profilePictureView.addGestureRecognizer(tap)
		self.makeTapGestureEndEditing()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.removeObservers()
		self.profilePictureView.gestureRecognizers?.removeAll()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITextFieldDelegate
//
//**********************************************************************************************************

extension PersonalInfoVC: UITextFieldDelegate {
	
	func textField(_ textField: UITextField,
	               shouldChangeCharactersIn range: NSRange,
	               replacementString string: String) -> Bool {
		let textFill = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		
		switch textField {
		case self.nicknameTextField:
			self.isConfirmEnabled = !textFill.isEmpty && !self.isUploading
		default:
			break
		}
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case self.nicknameTextField:
			self.dismissKeyboard()
		default:
			break
		}
		
		return true
	}
}

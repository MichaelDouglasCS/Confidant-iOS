//
//  PersonalInformationVC.swift
//  Confidant
//
//  Created by Michael Douglas on 02/10/17.
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

class PersonalInformationVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var backButton: LocalizedButton!
	@IBOutlet weak var profilePictureView: UIStackView!
	@IBOutlet weak var profilePicture: IBDesigableImageView!
	@IBOutlet weak var nicknameTextField: LocalizedTextField!
	@IBOutlet weak var continueButton: IBDesigableButton!
	
	var isConfirmEnabled: Bool {
		get {
			return self.continueButton.isEnabled
		}
		
		set {
			self.continueButton.isEnabled = newValue
		}
	}

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	@objc private func choosePicture() {
		//TODO: Add "picture" to backend
		let camera = CameraController()
		let options = [.camera, .photoLibrary] as [UIImagePickerControllerSourceType]
		let hasPhoto = self.profilePicture.image != nil
		
		camera.presentOptions(at: self, options: options, remove: hasPhoto) { (image: UIImage?) in
			self.profilePicture.image = image
		}
	}
	
	fileprivate func continueAction() {
		UsersLO.sharedInstance.current.profile.nickname = self.nicknameTextField.text
		let user = UsersLO.sharedInstance.current
		
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			switch result {
			case .success:
				
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "showKnowledgeSegue", sender: nil)
				}
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func backAction(_ sender: LocalizedButton) {
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func continueButtonAction(_ sender: IBDesigableButton) {
		self.continueAction()
	}
	
//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.choosePicture))
		self.profilePictureView.addGestureRecognizer(tap)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		self.removeObservers()
		self.profilePictureView.gestureRecognizers?.removeAll()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - UITextFieldDelegate
//
//**********************************************************************************************************

extension PersonalInformationVC: UITextFieldDelegate {
	
	func textField(_ textField: UITextField,
	               shouldChangeCharactersIn range: NSRange,
	               replacementString string: String) -> Bool {
		let textFill = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		
		switch textField {
		case self.nicknameTextField:
			self.isConfirmEnabled = !textFill.isEmpty
		default:
			break
		}
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case self.nicknameTextField:
			self.continueAction()
		default:
			break
		}
		
		return true
	}
}

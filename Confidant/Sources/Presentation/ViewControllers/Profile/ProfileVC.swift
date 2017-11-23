//
//  ProfileVC.swift
//  Confidant
//
//  Created by Michael Douglas on 23/11/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class ProfileVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************

	fileprivate var isUploading: Bool = false
	
	fileprivate var isUpdateEnabled: Bool {
		get {
			return self.updateButton.isEnabled
		}
		set {
			self.updateButton.isEnabled = newValue
		}
	}
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var profilePicture: CircularImage!
	@IBOutlet weak var nameField: LocalizedTextField!
	@IBOutlet weak var nicknameField: LocalizedTextField!
	@IBOutlet weak var emailField: LocalizedTextField!
	@IBOutlet weak var birthdateField: LocalizedTextField!
	@IBOutlet weak var genderField: LocalizedTextField!
	@IBOutlet weak var updateButton: IBDesigableButton!
	
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	fileprivate func isUserInformationChanged() {
		
		if self.isUploading {
			self.isUpdateEnabled = false
		} else {
			let user = UsersLO.sharedInstance.current
			let isChanged = user.profile.name != self.nameField.text || user.profile.nickname != self.nicknameField.text
							|| user.email != self.emailField.text || user.profile.birthdate != self.birthdateField.text
							|| user.profile.gender != self.genderField.text
			
			self.isUpdateEnabled = isChanged
		}
	}
	
	@objc fileprivate func doneButton(barButton: UIBarButtonItem) {
		if self.birthdateField.isEditing {
			if let genderField = self.genderField.text, genderField.isEmpty {
				self.genderField.becomeFirstResponder()
			} else {
				self.view.endEditing(true)
			}
		} else if self.genderField.isEditing {
			self.view.endEditing(true)
		}
		
		self.isUserInformationChanged()
	}

	private func loadData() {
		let user = UsersLO.sharedInstance.current
		
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
						UsersLO.sharedInstance.current.profile.picture = nil
					}
					
					self.profilePicture.loadingIndicatorView(isShow: false, at: nil)
				}
			}
		}
		
		self.nameField.text = user.profile.name
		self.nicknameField.text = user.profile.nickname
		self.emailField.text = user.email
		self.birthdateField.text = user.profile.birthdate
		self.genderField.text = user.profile.gender
	}
	
	@objc private func choosePicture() {
		let camera = CameraController()
		let options = [.camera, .photoLibrary] as [UIImagePickerControllerSourceType]
		let hasPhoto = UsersLO.sharedInstance.current.profile.picture?.hasMedia ?? false
		
		camera.presentOptions(at: self, options: options, remove: hasPhoto) { (image: UIImage?) in
			self.profilePicture.loadingIndicatorView(isShow: true, at: nil)
			self.isUpdateEnabled = false
			
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
					self.isUserInformationChanged()
					self.isUploading = false
				}
			} else {
				self.profilePicture.image = UIImage(named: "icn_anchor_gray")
				self.isUserInformationChanged()
				self.profilePicture.loadingIndicatorView(isShow: false, at: nil)
				
				UsersLO.sharedInstance.current.profile.picture = nil
			}
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func logoutAction(_ sender: LocalizedBarButton) {
	}
	
	@IBAction func updateAction(_ sender: IBDesigableButton) {
		let user = UsersLO.sharedInstance.current
		
		user.profile.name = self.nameField.text
		user.profile.nickname = self.nicknameField.text
		user.profile.birthdate = self.birthdateField.text
		user.profile.gender = self.genderField.text
		
		self.loadingIndicatorCustomTabBar(isShow: true)
		UsersLO.sharedInstance.update(user: user) { (result) in
			
			self.loadingIndicatorCustomTabBar(isShow: false)
			switch result {
			case .error(let error):
				self.showInfoAlert(title: String.Local.sorry, message: error.rawValue.localized)
			default: break
			}
			self.isUserInformationChanged()
		}
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************

	override func viewDidLoad() {
		super.viewDidLoad()
		self.loadData()
		self.registerKeyboardObservers()
		self.setupDatePickerAndPickerViewKeyboard()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.choosePicture))
		self.profilePicture.addGestureRecognizer(tap)
		self.makeTapGestureEndEditing()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		self.removeObservers()
		self.deregisterKeyboardObservers()
		self.profilePicture.gestureRecognizers?.removeAll()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

extension ProfileVC: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textFill = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		let user = UsersLO.sharedInstance.current
		
		switch textField {
		case self.nameField:
			self.isUpdateEnabled = user.profile.name != textFill || user.profile.nickname != self.nicknameField.text
				|| user.email != self.emailField.text || user.profile.birthdate != self.birthdateField.text
				|| user.profile.gender != self.genderField.text
		case self.nicknameField:
			self.isUpdateEnabled = user.profile.name != self.nameField.text || user.profile.nickname != textFill
				|| user.email != self.emailField.text || user.profile.birthdate != self.birthdateField.text
				|| user.profile.gender != self.genderField.text
		case self.emailField:
			self.isUpdateEnabled = user.profile.name != self.nameField.text || user.profile.nickname != self.nicknameField.text
				|| user.email != textFill || user.profile.birthdate != self.birthdateField.text
				|| user.profile.gender != self.genderField.text
		default:
			break
		}
		
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case self.birthdateField:
			let datePickerView = self.birthdateField.inputView as? UIDatePicker
			let formatter = DateFormatter()
			
			formatter.dateStyle = .long
			self.birthdateField.text = datePickerView?.date.stringLocal(date: .short)
			self.isUserInformationChanged()
		case self.genderField:
			let genderPickerView = self.genderField.inputView as! UIPickerView
			let selectedRow = genderPickerView.selectedRow(inComponent: 0)
			let selectedText = genderPickerView.delegate?.pickerView!(genderPickerView, titleForRow: selectedRow, forComponent: 0)
			
			self.genderField.text = selectedText
			self.isUserInformationChanged()
		default:
			break
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case self.nameField:
			self.nicknameField.becomeFirstResponder()
		case self.nicknameField:
			self.emailField.becomeFirstResponder()
		case self.emailField:
			self.birthdateField.becomeFirstResponder()
		default:
			break
		}
		
		return true
	}
}

//**************************************************************************************************
//
// MARK: - Extension - ProfileVC - UIPickerViewDataSource + UIPickerViewDelegate
//
//**************************************************************************************************

extension ProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
	
	var pickerViewData: [String] {
		typealias local = String.Local
		return [local.female, local.male]
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return self.pickerViewData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.pickerViewData[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.genderField.text = self.pickerViewData[row]
		self.isUserInformationChanged()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - DatePicker and PickerView
//
//**********************************************************************************************************

extension ProfileVC {
	
	fileprivate func setupDatePickerAndPickerViewKeyboard() {
		let toolBar = UIToolbar()
		toolBar.sizeToFit()
		toolBar.isTranslucent = true
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
		                                    target: nil,
		                                    action: nil)
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
		                                 target: self,
		                                 action: #selector(self.doneButton(barButton:)))
		let titleAttributes: [String: Any] = [NSFontAttributeName: UIFont(name: "GothamMedium", size: 15) ?? UIFont.labelFontSize,
		                                      NSForegroundColorAttributeName: UIColor.black]
		
		doneButton.setTitleTextAttributes(titleAttributes, for: .normal)
		toolBar.setItems([flexibleSpace, doneButton], animated: false)
		
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		self.birthdateField.inputView = datePicker
		self.birthdateField.inputAccessoryView = toolBar
		datePicker.addTarget(self, action: #selector(self.datePickerDidChange(datePicker:)), for: .valueChanged)
		
		let pickerView = UIPickerView()
		pickerView.dataSource = self
		pickerView.delegate = self
		self.genderField.inputView = pickerView
		self.genderField.inputAccessoryView = toolBar
	}
	
	@objc private func datePickerDidChange(datePicker: UIDatePicker) {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		self.birthdateField.text = datePicker.date.stringLocal(date: .short)
		self.isUserInformationChanged()
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - ProfileVC - Keyboard
//
//**********************************************************************************************************

extension ProfileVC {
	
	fileprivate func registerKeyboardObservers() {
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(keyboardWasShown(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillShow,
		                                       object: nil)
		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(keyboardWillBeHidden(notification:)),
		                                       name: NSNotification.Name.UIKeyboardWillHide,
		                                       object: nil)
	}
	
	fileprivate func deregisterKeyboardObservers() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}
	
	@objc private func keyboardWasShown(notification: NSNotification){
		//Need to calculate keyboard exact size due to Apple suggestions
		if let info = notification.userInfo {
			let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size ?? CGSize.zero
			let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0,
			                                                   0.0,
			                                                   keyboardSize.height,
			                                                   0.0)
			self.scrollView.contentInset = contentInsets
			self.scrollView.scrollIndicatorInsets = contentInsets
		}
	}
	
	@objc private func keyboardWillBeHidden(notification: NSNotification){
		//Once keyboard disappears, restore original positions
		let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
		self.scrollView.contentInset = contentInsets
		self.scrollView.scrollIndicatorInsets = contentInsets
	}
}

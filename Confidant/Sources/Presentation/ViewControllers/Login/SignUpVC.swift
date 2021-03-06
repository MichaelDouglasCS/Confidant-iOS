//
//  SignUpVC.swift
//  Confidant
//
//  Created by Michael Douglas on 10/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import SafariServices

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class SignUpVC: UIViewController {
	
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var isSignUpEnabled: Bool {
		get {
			return self.signUpButton.isEnabled
		}
		
		set {
			self.signUpButton.isEnabled = newValue
		}
	}
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var birthdateTextField: UITextField!
	@IBOutlet weak var genderTextField: UITextField!
	@IBOutlet weak var signUpButton: UIButton!
	@IBOutlet weak var termsAndConditionsTextView: UITextView!

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	@objc fileprivate func doneButton(barButton: UIBarButtonItem) {
		if self.birthdateTextField.isEditing {
			if let genderTextField = self.genderTextField.text, genderTextField.isEmpty {
				self.genderTextField.becomeFirstResponder()
			} else {
				self.view.endEditing(true)
			}
		} else if self.genderTextField.isEditing {
			self.view.endEditing(true)
		}
	}
	
	private func showTermsAlert(completion: @escaping (Bool) -> Void) {
		typealias local = String.Local
		let termsAction = UIAlertAction(title: local.termsAndConditions, style: .default) { _ in
			self.performSegue(withIdentifier: "showTermsSegue", sender: nil)
		}
		let agreeAction = UIAlertAction(title: local.agree, style: .default) { _ in
			self.showPrivacyPolicyAlert() { (result) in completion(result) }
		}
		let declineAction = UIAlertAction(title: local.decline, style: .destructive) { _ in
			completion(false)
		}
		
		self.showActionAlert(title: local.terms,
		                     message: local.termsMessage,
		                     actions: termsAction, agreeAction, declineAction)
	}
	
	private func showPrivacyPolicyAlert(completion: @escaping (Bool) -> Void) {
		typealias local = String.Local
		let privacyPolicyAction = UIAlertAction(title: local.privacyPolicy, style: .default) { _ in
			self.performSegue(withIdentifier: "showPrivacyPolicy", sender: nil)
		}
		let agreeAction = UIAlertAction(title: local.agree, style: .default) { _ in
			completion(true)
		}
		let declineAction = UIAlertAction(title: local.decline, style: .destructive) { _ in
			completion(false)
		}
		
		self.showActionAlert(title: local.privacyPolicy,
		                     message: local.privacyPolicyMessage,
		                     actions: privacyPolicyAction, agreeAction, declineAction)
	}
	
	private func logged() {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: "showRegisterSegue", sender: nil)
		}
	}
	
//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func signUpWithFacebook(_ sender: UIButton) {
		self.showTermsAlert() { (canProceedLogin) in
			
			switch canProceedLogin {
			case true:
				self.loadingIndicatorCustom(isShow: true)
				
				if let url = URL(string: ServerRequest.User.facebookAuth.path) {
					let facebookVC = FacebookVC(url: url)
					
					facebookVC.auth(target: self) { (result) in
						
						switch result {
						case .success:
							self.logged()
						case .error:
							self.loadingIndicatorCustom(isShow: false)
							self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
						}
					}
				}
			default: break
			}
		}
	}
	
	@IBAction func signUpWithEmail(_ sender: UIButton) {
		self.dismissKeyboard()
		self.showTermsAlert() { (canProceedLogin) in
			
			switch canProceedLogin {
			case true:
				self.loadingIndicatorCustom(isShow: true)
				
				let user = UserBO()
				user.email = self.emailTextField.text ?? ""
				user.password = self.passwordTextField.text ?? ""
				user.profile.name = self.nameTextField.text ?? ""
				user.profile.birthdate = self.birthdateTextField.text ?? ""
				user.profile.gender = self.genderTextField.text ?? ""
				
				UsersLO.sharedInstance.register(user: user) { (result) in
					
					switch result {
					case .success:
						self.logged()
					case .error:
						self.loadingIndicatorCustom(isShow: false)
						self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
					}
				}
			default: break
			}
		}
	}

//*************************************************
// MARK: - Overriden Public Methods
//*************************************************

	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupDatePickerAndPickerViewKeyboard()
		self.setupTermsAndConditionsHyperLink()
		self.registerKeyboardObservers()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.loadingIndicatorCustom(isShow: false)
		self.deregisterKeyboardObservers()
	}
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpVC - UITextFieldDelegate
//
//**************************************************************************************************

extension SignUpVC: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textFill = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		
		switch textField {
		case self.emailTextField:
			self.isSignUpEnabled = (!textFill.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty)
		case self.nameTextField:
			self.isSignUpEnabled = (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty)
		case self.passwordTextField:
			self.isSignUpEnabled = (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty)
		default:
			break
		}
		
		return true
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		switch textField {
		case self.birthdateTextField:
			let datePickerView = self.birthdateTextField.inputView as? UIDatePicker
			let formatter = DateFormatter()
			
			formatter.dateStyle = .long
			self.birthdateTextField.text = datePickerView?.date.stringLocal(date: .short)
			self.isSignUpEnabled = (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty)
		case self.genderTextField:
			let genderPickerView = self.genderTextField.inputView as! UIPickerView
			let selectedRow = genderPickerView.selectedRow(inComponent: 0)
			let selectedText = genderPickerView.delegate?.pickerView!(genderPickerView, titleForRow: selectedRow, forComponent: 0)
			
			self.genderTextField.text = selectedText
			self.isSignUpEnabled = (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty)
		default:
			break
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case self.emailTextField:
			self.nameTextField.becomeFirstResponder()
		case self.nameTextField:
			self.passwordTextField.becomeFirstResponder()
		case self.passwordTextField:
			self.birthdateTextField.becomeFirstResponder()
		default:
			break
		}
		
		return true
	}
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpVC - UIPickerViewDataSource + UIPickerViewDelegate
//
//**************************************************************************************************

extension SignUpVC: UIPickerViewDataSource, UIPickerViewDelegate {
	
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
		self.genderTextField.text = self.pickerViewData[row]
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - DatePicker and PickerView
//
//**********************************************************************************************************

extension SignUpVC {
	
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
		self.birthdateTextField.inputView = datePicker
		self.birthdateTextField.inputAccessoryView = toolBar
		datePicker.addTarget(self, action: #selector(self.datePickerDidChange(datePicker:)), for: .valueChanged)
		
		let pickerView = UIPickerView()
		pickerView.dataSource = self
		pickerView.delegate = self
		self.genderTextField.inputView = pickerView
		self.genderTextField.inputAccessoryView = toolBar
	}
	
	@objc private func datePickerDidChange(datePicker: UIDatePicker) {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		self.birthdateTextField.text = datePicker.date.stringLocal(date: .short)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - Terms And Conditions
//
//**********************************************************************************************************

extension SignUpVC {
	
	fileprivate func setupTermsAndConditionsHyperLink() {
		typealias local = String.Local
		let attributedString = NSMutableAttributedString()
		attributedString.setAttributedString(self.termsAndConditionsTextView.attributedText)
		attributedString.addAttribute(NSLinkAttributeName,
		                              value: "",
		                              range:(attributedString.string as NSString).range(of: local.termsAndConditionsUse))
		attributedString.addAttribute(NSLinkAttributeName,
		                              value: "",
		                              range:(attributedString.string as NSString).range(of: local.privacyPolicy))
		
		let linkAttributes: [String: Any] = [NSForegroundColorAttributeName: UIColor.black,
		                                     NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
		self.termsAndConditionsTextView.linkTextAttributes = linkAttributes
		self.termsAndConditionsTextView.attributedText = attributedString
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - SignUpVC - Keyboard
//
//**********************************************************************************************************

extension SignUpVC {
	
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

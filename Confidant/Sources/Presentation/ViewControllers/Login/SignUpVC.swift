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

public class SignUpVC: UIViewController {
    
    fileprivate enum SignUpTextFieldsTag: Int {
        case email = 1
        case nickname = 2
        case password = 3
        case birthdate = 4
        case gender = 5
    }
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
//*************************************************
// MARK: - Constructors
//*************************************************
    
//*************************************************
// MARK: - Protected Methods
//*************************************************
    
    private func setupDatePickerAndPickerViewKeyboard() {
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
        self.birthdateTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func doneButton(barButton: UIBarButtonItem) {
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
    
    private func setupTermsAndConditionsHyperLink() {
		typealias local = String.Local
        let attributedString = NSMutableAttributedString()
        attributedString.setAttributedString(self.termsAndConditionsTextView.attributedText)
        attributedString.addAttribute(NSLinkAttributeName,
                                      value: "",
                                      range:(attributedString.string as NSString).range(of: local.termsAndConditions))
        attributedString.addAttribute(NSLinkAttributeName,
                                      value: "",
                                      range:(attributedString.string as NSString).range(of: local.privacyPolicy))
		
		let linkAttributes: [String: Any] = [NSForegroundColorAttributeName: UIColor.black,
		                                     NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        self.termsAndConditionsTextView.linkTextAttributes = linkAttributes
        self.termsAndConditionsTextView.attributedText = attributedString
    }
    
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDashboard", sender: nil)
        }
    }

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func signUpWithFacebook(_ sender: UIButton) {
		self.loadingIndicator(isShow: true)
		if let url = URL(string: ServerRequest.API.userFacebookAuth.path) {
			let facebookAuthVC = FacebookAuthVC(url: url)
			
			facebookAuthVC.open(target: self, completionHandler: { result in
				
			})
		}
//		self.authByFacebook()
//		UserLO.sharedInstance.authByFacebook() { (result) in
//			switch result {
//			case .success:
//				self.logged()
//			case .error:
//				self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
//				self.loadingIndicator(isShow: false)
//			}
//		}
	}
	
	@IBAction func signUpWithEmail(_ sender: UIButton) {
		self.dismissKeyboard()
		self.loadingIndicator(isShow: true)
		
		let user = UserVO()
		user.email = self.emailTextField.text ?? ""
		user.password = (self.passwordTextField.text ?? "").encryptedPassword
		user.profile.name = self.nameTextField.text ?? ""
		user.profile.birthdate = self.birthdateTextField.text ?? ""
		user.profile.gender = self.genderTextField.text ?? ""
		
		UserLO.sharedInstance.register(user: user) { (result) in
			
			switch result {
			case .success:
				self.logged()
			case .error:
				self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
			}
			self.loadingIndicator(isShow: false)
		}
	}
	
//*************************************************
// MARK: - Overriden Public Methods
//*************************************************
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDatePickerAndPickerViewKeyboard()
        self.setupTermsAndConditionsHyperLink()
		self.registerKeyboardObservers()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
		self.deregisterKeyboardObservers()
    }
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpVC - UITextFieldDelegate
//
//**************************************************************************************************

extension SignUpVC: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		
        switch textField.tag {
        case SignUpTextFieldsTag.email.rawValue:
            if (!textFill.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.nickname.rawValue:
            if (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.password.rawValue:
            if (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default:
			break
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case SignUpTextFieldsTag.birthdate.rawValue:
            let datePickerView = self.birthdateTextField.inputView as? UIDatePicker
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            self.birthdateTextField.text = formatter.string(from: datePickerView?.date ?? Date())
            if (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.gender.rawValue:
            let genderPickerView = self.genderTextField.inputView as! UIPickerView
            let selectedRow = genderPickerView.selectedRow(inComponent: 0)
            let selectedText = genderPickerView.delegate?.pickerView!(genderPickerView, titleForRow: selectedRow, forComponent: 0)
            self.genderTextField.text = selectedText
            if (!self.emailTextField.text!.isEmpty && !self.nameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.birthdateTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default:
			break
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case SignUpTextFieldsTag.email.rawValue:
            self.nameTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.nickname.rawValue:
            self.passwordTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.password.rawValue:
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
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewData.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewData[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.pickerViewData[row]
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

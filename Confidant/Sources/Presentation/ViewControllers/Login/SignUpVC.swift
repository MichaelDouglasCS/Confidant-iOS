//
//  SignUpVC.swift
//  Confidant
//
//  Created by Michael Douglas on 10/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

fileprivate let kSignUpToDashboardSegue = "signupToDashboardSegue"

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class SignUpVC : UIViewController {
    
    fileprivate enum SignUpTextFieldsTag: Int {
        case Email = 1
        case NickName = 2
        case Password = 3
        case DateOfBirth = 4
        case Gender = 5
    }
    
//*************************************************
// MARK: - Properties
//*************************************************
	
    let pickerViewGender = ["Female", "Male"]
    
    @IBOutlet weak var signInScrollView: UIScrollView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailCheckMessageLabel: UILabel!
    @IBOutlet weak var emailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkEmailImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
//*************************************************
// MARK: - Constructors
//*************************************************
    
//*************************************************
// MARK: - Protected Methods
//*************************************************
    
    //*************************************************
    // MARK: - Custom Keyboard Methods
    //*************************************************
    
    private func setDatePickerAndPickerViewKeyboard() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneButton(barButton:)))
        let titleAttributes: [String: Any] = [NSFontAttributeName: UIFont(name: "GothamMedium", size: 15)!,
                                              NSForegroundColorAttributeName: UIColor.black]
        
        doneButton.setTitleTextAttributes(titleAttributes, for: .normal)
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        self.dateOfBirthTextField.inputView = datePicker
        self.dateOfBirthTextField.inputAccessoryView = toolBar
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(datePicker:)), for: UIControlEvents.valueChanged)
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        self.genderTextField.inputView = pickerView
        self.genderTextField.inputAccessoryView = toolBar
    }
    
    @objc private func datePickerChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        self.dateOfBirthTextField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func doneButton(barButton: UIBarButtonItem) {
        if self.dateOfBirthTextField.isEditing {
            if (self.genderTextField.text?.isEmpty)! {
                self.genderTextField.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        } else if self.genderTextField.isEditing {
            self.view.endEditing(true)
        }
    }
    
    //*************************************************
    // MARK: - Keyboard Methods
    //*************************************************
    
    private func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        self.signInScrollView.contentInset = contentInsets
        self.signInScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.signInScrollView.contentInset = contentInsets
        self.signInScrollView.scrollIndicatorInsets = contentInsets
    }
    
    //*************************************************
    // MARK: - Setup Terms And Conditions Label
    //*************************************************
    
    private func setupTermsAndConditionsHyperLink() {
        let attributedString = NSMutableAttributedString()
        attributedString.setAttributedString(self.termsAndConditionsTextView.attributedText)
        attributedString.addAttribute(NSLinkAttributeName, value: "", range:(attributedString.string as NSString).range(of: "Terms and conditions of Use"))
        attributedString.addAttribute(NSLinkAttributeName, value: "", range:(attributedString.string as NSString).range(of: "Privacy Policy"))
        let linkAttributes: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.black,
            NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue]
        self.termsAndConditionsTextView.linkTextAttributes = linkAttributes
        self.termsAndConditionsTextView.attributedText = attributedString
    }
    
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: kSignUpToDashboardSegue, sender: nil)
        }
    }
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
    @IBAction func signUpWithFacebook(_ sender: UIButton) {
        self.loadingIndicator(isShow: true)
        let readPermissions = ["email", "public_profile", "user_birthday"]
        FBSDKLoginManager().logIn(withReadPermissions: readPermissions, from: self, handler: { (resultLoginManager, error) in
            if (resultLoginManager?.isCancelled)! == false {
                if error == nil {
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email, name, birthday, gender, picture"]).start(completionHandler: {
                        (connection, resultGraph, error) -> Void in
                        if error == nil {
                            guard let userJSON = resultGraph as? JSON else { return }
                            let facebookUser = UserVO()
                            
                            facebookUser.decodeJSON(fromFacebook: userJSON)
                            
                            let accessToken = resultLoginManager?.token
                            guard let accessTokenString = accessToken?.tokenString else { return }
                            let facebookCredentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                            let authentication = AuthenticationManager()
                            
                            authentication.createUserWith(credentials: facebookCredentials, accreditedUser: facebookUser, completion: {
                                (responseStatus, error) in
                                switch(responseStatus) {
                                case .Success:
                                    self.logged()
                                case .Failed:
                                    self.loadingIndicator(isShow: false)
                                    self.presentAlertOk(title: "SIGN UP FAILED", message: (error?.localizedDescription)!)
                                }
                            })
                        } else {
                            self.loadingIndicator(isShow: false)
                            self.presentAlertOk(title: "SIGN UP FAILED", message: (error?.localizedDescription)!)
                        }
                    })
                } else {
                    self.loadingIndicator(isShow: false)
                    self.presentAlertOk(title: "SIGN UP FAILED", message: (error?.localizedDescription)!)
                }
                
            } else {
                self.loadingIndicator(isShow: false)
            }
        })
    }
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        self.dismissKeyboard()
        self.loadingIndicator(isShow: true)
        
        let email = self.emailTextField.text!
        let nickName = self.nickNameTextField.text!
        let password = self.passwordTextField.text!
        let dateOfBirth = self.dateOfBirthTextField.text!
        let gender = self.genderTextField.text!
        let authentication = AuthenticationManager()
        
        authentication.createUserWith(email: email,
                                      nickName: nickName,
                                      password: password,
                                      dateOfBirth: dateOfBirth,
                                      gender: gender,
                                      completion: { (responseStatus, error) in
                                        switch(responseStatus) {
                                        case .Success:
                                            self.logged()
                                        case .Failed:
                                            self.loadingIndicator(isShow: false)
                                            self.presentAlertOk(title: "SIGN UP FAILED", message: (error?.localizedDescription)!)
                                        }
        })
    }
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDatePickerAndPickerViewKeyboard()
        self.setupTermsAndConditionsHyperLink()
        self.addHideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.deregisterFromKeyboardNotifications()
        self.removeAllGestureRecognizers()
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpVC - UITextFieldDelegate
//
//**************************************************************************************************

extension SignUpVC : UITextFieldDelegate {
    
    //*************************************************
    // MARK: - TextField Delegates
    //*************************************************
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case SignUpTextFieldsTag.Email.rawValue:
            self.checkEmailImageView.isHidden = true
            self.emailCheckMessageLabel.isHidden = true
            if (!textFill.isEmpty) && (!self.emailCheckMessageLabel.isHidden && !self.nickNameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.NickName.rawValue:
            if (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.emailCheckMessageLabel.isHidden && !self.passwordTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.Password.rawValue:
            if (!textFill.isEmpty) && (!self.emailTextField.text!.isEmpty && !self.emailCheckMessageLabel.isHidden && !self.nickNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default: break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case SignUpTextFieldsTag.DateOfBirth.rawValue:
            let datePickerView = self.dateOfBirthTextField.inputView as! UIDatePicker
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            self.dateOfBirthTextField.text = formatter.string(from: datePickerView.date)
            if (!self.emailTextField.text!.isEmpty && !self.nickNameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.Gender.rawValue:
            let genderPickerView = self.genderTextField.inputView as! UIPickerView
            let selectedRow = genderPickerView.selectedRow(inComponent: 0)
            let selectedText = genderPickerView.delegate?.pickerView!(genderPickerView, titleForRow: selectedRow, forComponent: 0)
            self.genderTextField.text = selectedText
            if (!self.emailTextField.text!.isEmpty && !self.nickNameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        switch textField.tag {
        case SignUpTextFieldsTag.Email.rawValue:
            if !(textField.text?.isEmpty)! {
                if !(self.emailTextField.isValidEmailAddress()) {
                    self.checkEmailImageView.image = #imageLiteral(resourceName: "email-incorrect")
                    self.emailCheckMessageLabel.text = "Invalid email address."
                    self.checkEmailImageView.isHidden = false
                    self.emailCheckMessageLabel.isHidden = false
                    self.signUpButton.isEnabled = false
                } else {
                    self.emailView.loadingIndicatorView(isShow: true, at: self.checkEmailImageView.center)
                    AuthenticationManager.userEmailExists(email: textField.text!, isExists: { isExistsResponse in
                        self.checkEmailImageView.isHidden = true
                        self.emailCheckMessageLabel.isHidden = true
                        if isExistsResponse {
                            self.emailView.loadingIndicatorView(isShow: false, at: nil)
                            self.checkEmailImageView.image = #imageLiteral(resourceName: "email-incorrect")
                            self.emailCheckMessageLabel.text = "That email address is already registered."
                            self.checkEmailImageView.isHidden = false
                            self.emailCheckMessageLabel.isHidden = false
                            self.signUpButton.isEnabled = false
                        } else {
                            self.emailView.loadingIndicatorView(isShow: false, at: nil)
                            self.checkEmailImageView.image = #imageLiteral(resourceName: "email-correct")
                            self.checkEmailImageView.isHidden = false
                            self.emailCheckMessageLabel.isHidden = true
                            if (!self.emailTextField.text!.isEmpty) && (!self.nickNameTextField.text!.isEmpty && !self.passwordTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty) {
                                self.signUpButton.isEnabled = true
                            } else {
                                self.signUpButton.isEnabled = false
                            }
                        }
                    })
                }
            }
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case SignUpTextFieldsTag.Email.rawValue:
            self.nickNameTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.NickName.rawValue:
            self.passwordTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.Password.rawValue:
            self.dateOfBirthTextField.becomeFirstResponder()
        default: break
        }
        return true
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpVC - UIPickerViewDataSource + UIPickerViewDelegate
//
//**************************************************************************************************

extension SignUpVC : UIPickerViewDataSource, UIPickerViewDelegate {
    
    //*************************************************
    // MARK: - UIPickerView Methods
    //*************************************************
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewGender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewGender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.pickerViewGender[row]
    }
    
}

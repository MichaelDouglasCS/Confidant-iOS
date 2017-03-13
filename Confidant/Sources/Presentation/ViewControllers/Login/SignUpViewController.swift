//
//  SignUpViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 10/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

fileprivate enum SignUpTextFields: Int {
    case Email = 1
    case Name = 2
    case ChoosePassword = 3
    case ChooseUsername = 4
    case DateOfBirth = 5
    case Gender = 6
}

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class SignUpViewController: UIViewController {
    
    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    
    @IBOutlet weak var signInScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var choosePasswordTextField: UITextField!
    @IBOutlet weak var chooseUserNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    
    //*************************************************
    // MARK: - UIViewController's Lifecycle Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTermsAndConditionsHyperLink()
        self.addHideKeyboardWhenTappedAround()
        self.registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        self.deregisterFromKeyboardNotifications()
        self.removeAllGestureRecognizers()
    }
    
    //*************************************************
    // MARK: - Setup Terms And Conditions Label
    //*************************************************
    
    private func setupTermsAndConditionsHyperLink() {
//        let attributedString = NSMutableAttributedString(string: self.termsAndConditionsLabel.text!)
//        attributedString.addAttribute(NSLinkAttributeName, value: "https://www.google.com.br/", range:(attributedString.string as NSString).range(of: "Terms and conditions of Use"))
//        self.termsAndConditionsLabel.attributedText = attributedString
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
    
    internal func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.signInScrollView.contentInset = contentInsets
        self.signInScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if (!aRect.contains(self.signUpButton.frame)){
            let spaceOfButtonToKeyboard = CGRect(x: self.signUpButton.frame.origin.x, y: self.signUpButton.frame.origin.y, width: self.signUpButton.frame.width, height: self.signUpButton.frame.height)
            self.signInScrollView.scrollRectToVisible(spaceOfButtonToKeyboard, animated: true)
        }
        
    }
    
    internal func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.signInScrollView.contentInset = contentInsets
        self.signInScrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    
    @IBAction func signUpWithFacebook(_ sender: UIButton) {
        print("Sign Up Facebook")
    }
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        print("Sign Up Email")
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

extension SignUpViewController: UITextFieldDelegate {
    
    //*************************************************
    // MARK: - TextField Methods
    //*************************************************
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case SignUpTextFields.Email.rawValue:
            if (!textFill.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFields.Name.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!textFill.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFields.ChoosePassword.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !textFill.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFields.ChooseUsername.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !textFill.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFields.DateOfBirth.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !textFill.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFields.Gender.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !textFill.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default: break
        }
        return true
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case SignUpTextFields.Email.rawValue:
            self.nameTextField.becomeFirstResponder()
        case SignUpTextFields.Name.rawValue:
            self.choosePasswordTextField.becomeFirstResponder()
        case SignUpTextFields.ChoosePassword.rawValue:
            self.chooseUserNameTextField.becomeFirstResponder()
        case SignUpTextFields.ChooseUsername.rawValue:
            self.dateOfBirthTextField.becomeFirstResponder()
        case SignUpTextFields.DateOfBirth.rawValue:
            self.genderTextField.becomeFirstResponder()
        case SignUpTextFields.Gender.rawValue:
            self.emailTextField.becomeFirstResponder()
        default: break
        }
        return true
    }
    
}

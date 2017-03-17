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

fileprivate enum SignUpTextFieldsTag: Int {
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
    @IBOutlet weak var termsAndConditionsTextView: UITextView!
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    
    @IBAction func signUpWithFacebook(_ sender: UIButton) {
        print("Sign Up Facebook")
    }
    
    @IBAction func signUpWithEmail(_ sender: UIButton) {
        print("Sign Up Email")
    }
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    internal let pickerViewGender = ["Female", "Male"]
    
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
    
//*************************************************
// MARK: - Private Methods
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
    
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpViewController - UITextFieldDelegate
//
//**************************************************************************************************

extension SignUpViewController: UITextFieldDelegate {
    
    //*************************************************
    // MARK: - TextField Delegates
    //*************************************************
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case SignUpTextFieldsTag.Email.rawValue:
            if (!textFill.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.Name.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!textFill.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.ChoosePassword.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !textFill.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.ChooseUsername.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !textFill.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.DateOfBirth.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !textFill.isEmpty && !self.genderTextField.text!.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        case SignUpTextFieldsTag.Gender.rawValue:
            if (!self.emailTextField.text!.isEmpty) && (!self.nameTextField.text!.isEmpty && !self.choosePasswordTextField.text!.isEmpty && !self.chooseUserNameTextField.text!.isEmpty && !self.dateOfBirthTextField.text!.isEmpty && !textFill.isEmpty){
                self.signUpButton.isEnabled = true
            } else {
                self.signUpButton.isEnabled = false
            }
        default: break
        }
        return true
    }
    
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case SignUpTextFieldsTag.DateOfBirth.rawValue:
            let datePickerView = self.dateOfBirthTextField.inputView as! UIDatePicker
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            self.dateOfBirthTextField.text = formatter.string(from: datePickerView.date)
            break
        case SignUpTextFieldsTag.Gender.rawValue:
            let genderPickerView = self.genderTextField.inputView as! UIPickerView
            let selectedRow = genderPickerView.selectedRow(inComponent: 0)
            let selectedText = genderPickerView.delegate?.pickerView!(genderPickerView, titleForRow: selectedRow, forComponent: 0)
            self.genderTextField.text = selectedText
        default: break
        }
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case SignUpTextFieldsTag.Email.rawValue:
            self.nameTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.Name.rawValue:
            self.choosePasswordTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.ChoosePassword.rawValue:
            self.chooseUserNameTextField.becomeFirstResponder()
        case SignUpTextFieldsTag.ChooseUsername.rawValue:
            self.dateOfBirthTextField.becomeFirstResponder()
        default: break
        }
        return true
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - SignUpViewController - UIPickerViewDataSource + UIPickerViewDelegate
//
//**************************************************************************************************

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //*************************************************
    // MARK: - UIPickerView Methods
    //*************************************************
    
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerViewGender.count
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerViewGender[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genderTextField.text = self.pickerViewGender[row]
    }
    
}

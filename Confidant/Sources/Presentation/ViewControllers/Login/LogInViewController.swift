//
//  LogInViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 07/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit
import FBSDKLoginKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

fileprivate let kLogInToDashboardSegue = "logInToDashboard"

//**************************************************************************************************
//
// MARK: - Definitions -
//
//**************************************************************************************************

//**************************************************************************************************
//
// MARK: - Enum -
//
//**************************************************************************************************

fileprivate enum LogInTextFieldsTag: Int {
    case Email = 1
    case Password = 2
}

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class LogInViewController : UIViewController {
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
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
        
        self.loginScrollView.contentInset = contentInsets
        self.loginScrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if (!aRect.contains(self.logInButton.frame)){
            let spaceOfButtonToKeyboard = CGRect(x: self.logInButton.frame.origin.x, y: self.logInButton.frame.origin.y + 20, width: self.logInButton.frame.width, height: self.logInButton.frame.height)
            self.loginScrollView.scrollRectToVisible(spaceOfButtonToKeyboard, animated: true)
        }
        
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.loginScrollView.contentInset = contentInsets
        self.loginScrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: kLogInToDashboardSegue, sender: nil)
        }
    }
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
    @IBAction func logInWithFacebook(_ sender: UIButton) {
        print("Login Facebook")
    }
    
    @IBAction func logInWithEmailAndPassword(_ sender: UIButton) {
        self.dismissKeyboard()
        self.loadingIndicator(true)
        guard
            let email = self.emailTextField.text,
            let password = self.passwordTextField.text else {
                return
        }
        let authentication = AuthenticationManager()
        authentication.logInWith(email: email, password: password, completion: { (responseStatus, error) in
            switch(responseStatus) {
            case .Success:
                self.loadingIndicator(false)
                self.logged()
            case .Failed:
                self.loadingIndicator(false)
                self.presentAlertOk(title: "LOG IN FAILED", message: (error?.localizedDescription)!)
            }
        })
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        print("Forgot Password")
    }

    
//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
// MARK: - Extension - LogInVC - UITextFieldDelegate
//
//**************************************************************************************************

extension LogInViewController : UITextFieldDelegate {
    
    //*************************************************
    // MARK: - TextField Methods
    //*************************************************
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        switch textField.tag {
        case LogInTextFieldsTag.Email.rawValue:
            if ((!textFill.isEmpty) && (!(self.passwordTextField.text!.isEmpty))){
                self.logInButton.isEnabled = true
            } else {
                self.logInButton.isEnabled = false
            }
        case LogInTextFieldsTag.Password.rawValue:
            if ((!textFill.isEmpty) && (!(self.emailTextField.text!.isEmpty))){
                self.logInButton.isEnabled = true
            } else {
                self.logInButton.isEnabled = false
            }
        default: break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case LogInTextFieldsTag.Email.rawValue:
            self.passwordTextField.becomeFirstResponder()
        case LogInTextFieldsTag.Password.rawValue:
            if self.emailTextField.text?.isEmpty == true {
                self.emailTextField.becomeFirstResponder()
            } else if self.passwordTextField.text?.isEmpty == true {
                return false
            } else {
                self.passwordTextField.resignFirstResponder()
                print("Log In")
            }
        default: break
        }
        return true
    }

}

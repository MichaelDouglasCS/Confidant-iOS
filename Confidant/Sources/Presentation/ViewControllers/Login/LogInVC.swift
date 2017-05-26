//
//  LogInVC.swift
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

class LogInVC : UIViewController {
    
    fileprivate enum TextField: Int {
        case email = 1
        case password = 2
    }
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
    
    @objc private func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        
        if (!aRect.contains(self.logInButton.frame)){
            let spaceOfButtonToKeyboard = CGRect(x: self.logInButton.frame.origin.x, y: self.logInButton.frame.origin.y + 20, width: self.logInButton.frame.width, height: self.logInButton.frame.height)
            self.scrollView.scrollRectToVisible(spaceOfButtonToKeyboard, animated: true)
        }
        
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginToDashboardSegue", sender: nil)
        }
    }
    
    fileprivate func loginWithEmail() {
        self.dismissKeyboard()
        self.loadingIndicator(isShow: true)
        
        let email = self.emailTextField.text!
        let password = self.passwordTextField.text!
        
		UsersLO.instance.authenticate(by: .logInBy(email: email, password: password)) { (result) in
			
			switch(result) {
			case .success:
				self.logged()
			case .failed(let error):
				self.loadingIndicator(isShow: false)
				self.presentAlertOk(title: "LOG IN FAILED", message: error?.localizedDescription ?? "")
			}
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
        self.loginWithEmail()
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        print("Forgot Password")
    }

//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
		self.removeObservers()
    }
}

//**************************************************************************************************
//
// MARK: - Extension - LogInVC - UITextFieldDelegate
//
//**************************************************************************************************

extension LogInVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		
		switch textField.tag {
        case TextField.email.rawValue:
            if !(textFill.isEmpty && self.passwordTextField.text!.isEmpty) {
                self.logInButton.isEnabled = true
            } else {
                self.logInButton.isEnabled = false
            }
        case TextField.password.rawValue:
            if !(textFill.isEmpty && self.emailTextField.text!.isEmpty) {
                self.logInButton.isEnabled = true
            } else {
                self.logInButton.isEnabled = false
            }
		default:
			break
        }
		
        return true
    }
    
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField.tag {
		case TextField.email.rawValue:
			self.passwordTextField.becomeFirstResponder()
		case TextField.password.rawValue:
			if self.emailTextField.text?.isEmpty == true {
				self.emailTextField.becomeFirstResponder()
			} else if self.passwordTextField.text?.isEmpty == true {
				return false
			} else {
				self.passwordTextField.resignFirstResponder()
				self.loginWithEmail()
			}
		default:
			break
		}
		
		return true
	}
}

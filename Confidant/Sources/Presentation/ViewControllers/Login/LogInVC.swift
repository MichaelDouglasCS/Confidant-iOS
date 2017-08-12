//
//  LogInVC.swift
//  Confidant
//
//  Created by Michael Douglas on 07/03/17.
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

public class LogInVC: UIViewController {
    
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
	
	fileprivate func loginWithEmail() {
		self.dismissKeyboard()
		self.loadingIndicator(isShow: true)
		
		let user = UserBO()
		user.email = self.emailTextField.text ?? ""
		user.password = (self.passwordTextField.text ?? "").encryptedPassword
	}
	
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginToDashboardSegue", sender: nil)
        }
    }
    
//*************************************************
// MARK: - Exposed Methods
//*************************************************
    
    @IBAction func logInWithFacebook(_ sender: UIButton) {
		self.loadingIndicator(isShow: true)
    }
    
    @IBAction func logInWithEmailAndPassword(_ sender: UIButton) {
        self.loginWithEmail()
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        print("Forgot Password")
    }

//*************************************************
// MARK: - Overriden Public Methods
//*************************************************
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardObservers()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
		self.deregisterKeyboardObservers()
    }
}

//**************************************************************************************************
//
// MARK: - Extension - LogInVC - UITextFieldDelegate
//
//**************************************************************************************************

extension LogInVC: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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

//**********************************************************************************************************
//
// MARK: - Extension - Keyboard
//
//**********************************************************************************************************

extension LogInVC {
	
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

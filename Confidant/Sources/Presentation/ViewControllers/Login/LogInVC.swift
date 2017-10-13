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
// MARK: - Class -
//
//**********************************************************************************************************

class LogInVC: UIViewController {
    
    fileprivate enum TextField: Int {
        case email = 1
        case password = 2
    }
    
//*************************************************
// MARK: - Properties
//*************************************************
	
	fileprivate var isLoginEnabled: Bool {
		get {
			return self.logInButton.isEnabled
		}
		
		set {
			self.logInButton.isEnabled = newValue
		}
	}
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	fileprivate func loginWithEmail() {
		self.dismissKeyboard()
		self.loadingIndicatorCustom(isShow: true)
		
		let user = UserBO()
		user.email = self.emailTextField.text ?? ""
		user.password = self.passwordTextField.text ?? ""
		
		UsersLO.sharedInstance.authenticate(user: user) { (result) in
			
			switch result {
			case .success:
				self.logged()
			case .error:
				self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
			}
			
			self.loadingIndicatorCustom(isShow: false)
		}
	}
	
    private func logged() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showDashboardSegue", sender: nil)
        }
    }
    
//*************************************************
// MARK: - Exposed Methods
//*************************************************
    
    @IBAction func logInWithFacebook(_ sender: UIButton) {
		self.loadingIndicatorCustom(isShow: true)
		if let url = URL(string: ServerRequest.User.facebookAuth.path) {
			let facebookVC = FacebookVC(url: url)
			
			facebookVC.auth(target: self) { (result) in
				
				switch result {
				case .success:
					self.logged()
				case .error:
					self.showInfoAlert(title: String.Local.sorry, message: result.localizedError)
				}
				
				self.loadingIndicatorCustom(isShow: false)
			}
		}
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerKeyboardObservers()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIApplication.shared.statusBarStyle = .lightContent
	}
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
		self.deregisterKeyboardObservers()
    }
}

//**************************************************************************************************
//
// MARK: - Extension - LogInVC - UITextFieldDelegate
//
//**************************************************************************************************

extension LogInVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFill = (textField.text! as NSString).replacingCharacters(in: range, with: string)
		
		switch textField {
        case self.emailTextField:
            self.isLoginEnabled = !textFill.isEmpty && !self.passwordTextField.text!.isEmpty
        case self.passwordTextField:
            self.isLoginEnabled = !textFill.isEmpty && !self.emailTextField.text!.isEmpty
		default:
			break
        }
		
        return true
    }
    
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case self.emailTextField:
			self.passwordTextField.becomeFirstResponder()
		case self.passwordTextField:
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

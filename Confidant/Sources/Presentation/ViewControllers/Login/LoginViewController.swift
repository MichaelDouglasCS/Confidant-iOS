//
//  LoginViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 07/03/17.
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

//**************************************************************************************************
//
// MARK: - Class -
//
//**************************************************************************************************

class LoginViewController: UIViewController {
    
    //*************************************************
    // MARK: - IBOutlets
    //*************************************************
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var userNameOrEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    //*************************************************
    // MARK: - Constructors
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //*************************************************
    // MARK: - IBActions
    //*************************************************
    
    @IBAction func logInWithFacebook(_ sender: UIButton) {
        print("Facebook")
    }
    
    @IBAction func logInWithUserAndPassword(_ sender: UIButton) {
        print("Log In")
    }

    @IBAction func forgotPassword(_ sender: UIButton) {
        print("Forgot Password")
    }
    
    
    
}

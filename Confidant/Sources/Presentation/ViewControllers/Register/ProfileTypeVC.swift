//
//  ProfileTypeVC.swift
//  Confidant
//
//  Created by Michael Douglas on 29/09/17.
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

class ProfileTypeVC: UIViewController {

//*************************************************
// MARK: - Properties
//*************************************************
	
	@IBOutlet weak var userButton: UIButton!
	@IBOutlet weak var confidantButton: UIButton!
	@IBOutlet weak var continueButton: IBDesigableButton!

//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func changeType(for sender: UIButton) {
		self.userButton.isSelected = false
		self.confidantButton.isSelected = false
		self.userButton.isUserInteractionEnabled = true
		self.confidantButton.isUserInteractionEnabled = true
		self.continueButton.isEnabled = true
		
		sender.isSelected = true
		sender.isUserInteractionEnabled = false
		
		switch sender {
			//TODO:
		case self.userButton: break
		case self.continueButton: break
		default: break
		}
	}

//*************************************************
// MARK: - Exposed Methods
//*************************************************
	
	@IBAction func userSelectedAction(_ sender: UIButton) {
		self.changeType(for: sender)
	}
	
	@IBAction func confidantSelectedAction(_ sender: UIButton) {
		self.changeType(for: sender)
	}

//*************************************************
// MARK: - Overridden Public Methods
//*************************************************
	
    override func viewDidLoad() {
        super.viewDidLoad()
		UIApplication.shared.statusBarStyle = .default
    }
}

//**********************************************************************************************************
//
// MARK: - Extension -
//
//**********************************************************************************************************

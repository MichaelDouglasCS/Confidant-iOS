//
//  WelcomeViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 02/03/17.
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

class WelcomeViewController: UIViewController {

    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    //*************************************************
    // MARK: - Setup Design Properties
    //*************************************************
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //*************************************************
    // MARK: - Override Public Methods
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //*************************************************
    // MARK: - Setup Methods
    //*************************************************
    

}

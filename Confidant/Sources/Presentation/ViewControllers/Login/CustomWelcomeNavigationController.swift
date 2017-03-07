//
//  CustomWelcomeNavigationController.swift
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

class CustomWelcomeNavigationController: UINavigationController {

    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //*************************************************
    // MARK: - Constructors
    //*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

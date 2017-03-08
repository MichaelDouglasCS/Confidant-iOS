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
    // MARK: - Override Properties
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
        self.setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    //*************************************************
    // MARK: - Setup
    //*************************************************
    
    private func setupNavigationBar() {
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBar-image"), for: .default)
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton")
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton")
    }

}

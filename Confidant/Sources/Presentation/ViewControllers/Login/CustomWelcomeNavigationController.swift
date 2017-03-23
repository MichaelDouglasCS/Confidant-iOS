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
    
    internal func setupNavigationBar() {
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBar-image"), for: .default)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton")
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton")
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "GothamMedium", size: 14)!, NSForegroundColorAttributeName: UIColor.white]
    }
    
//*************************************************
// MARK: - Private Methods
//*************************************************
    
//    PRINT FONTS EXISTENTS
    
//    private func printFonts() {
//        let fontFamilyNames = UIFont.familyNames
//        for familyName in fontFamilyNames {
//            print("------------------------------")
//            print("Font Family Name = [\(familyName)]")
//            let names = UIFont.fontNames(forFamilyName: familyName as! String)
//            print("Font Names = [\(names)]")
//        }
//    }
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        //        self.printFonts()
    }

}

//
//  ChatsNavigationViewController.swift
//  Confidant
//
//  Created by Michael Douglas on 25/03/17.
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

class ChatsNavigationViewController: UINavigationController {
    
//*************************************************
// MARK: - Properties
//*************************************************
    
//*************************************************
// MARK: - Constructors
//*************************************************

//*************************************************
// MARK: - Protected Methods
//*************************************************
    
//*************************************************
// MARK: - Internal Methods
//*************************************************
    
    func setupNavigationBar() {
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "navigationBar-image"), for: .default)
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "backButton")
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "backButton")
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "GothamMedium", size: 17)!, NSForegroundColorAttributeName: UIColor.white]
    }
    
//*************************************************
// MARK: - Public Methods
//*************************************************
    
//*************************************************
// MARK: - Override Public Methods
//*************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        // Do any additional setup after loading the view.
    }

}

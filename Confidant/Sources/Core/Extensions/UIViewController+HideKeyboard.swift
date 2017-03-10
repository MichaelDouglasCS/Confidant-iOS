//
//  UIViewController+HideKeyboard.swift
//  Confidant
//
//  Created by Michael Douglas on 10/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Extension -
//
//**************************************************************************************************

extension UIViewController {
    
    func addHideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func removeAllGestureRecognizers() {
        self.view.gestureRecognizers?.removeAll()
    }
    
}


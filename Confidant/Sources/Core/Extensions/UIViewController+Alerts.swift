//
//  UIViewController+Alerts.swift
//  Confidant
//
//  Created by Michael Douglas on 21/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Extension - UIViewController + Alerts
//
//**************************************************************************************************

extension UIViewController {
    
    func presentAlertOk(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

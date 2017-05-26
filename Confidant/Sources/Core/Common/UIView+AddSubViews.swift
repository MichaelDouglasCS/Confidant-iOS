//
//  UIView+UIView+AddSubViews.swift
//  Confidant
//
//  Created by Michael Douglas on 07/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Extension - UIView - AddSubViews
//
//**************************************************************************************************

extension UIView {
    
    func addSubViews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}

//
//  UIViewController+Loading.swift
//  Confidant
//
//  Created by Michael Douglas on 22/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

fileprivate let kLoadingViewTag = 100773

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

import UIKit

//**************************************************************************************************
//
// MARK: - Extension - UIViewController + Loading
//
//**************************************************************************************************

extension UIViewController {
    
    func addLoading() {
        var loading = [UIImage]()
        
        for i in 0...40 {
            let image = UIImage(named: "loading_\(i)")
            if let imageLoad = image {
                loading.append(imageLoad)
            }
        }
        let window = UIApplication.shared.keyWindow
        let opaqueWindow = UIView(frame: CGRect(x: 0, y: 0, width: (window?.frame.size.width)!, height: (window?.frame.size.height)!))
        opaqueWindow.backgroundColor = UIColor(white: 0, alpha: 0.1)
        opaqueWindow.center = CGPoint(x: (window?.frame.size.width)! / 2, y: (window?.frame.size.height)! / 2)
        opaqueWindow.tag = kLoadingViewTag
        let loadingAnimation = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        loadingAnimation.image = UIImage.animatedImage(with: loading, duration: 1.5)
        loadingAnimation.center = CGPoint(x: opaqueWindow.frame.size.width / 2, y: opaqueWindow.frame.size.height / 2)
        opaqueWindow.addSubview(loadingAnimation)
        window?.addSubview(opaqueWindow)
    }
    
    func removeLoading() {
        let window = UIApplication.shared.keyWindow
        window?.viewWithTag(kLoadingViewTag)?.removeFromSuperview()
    }
    
}

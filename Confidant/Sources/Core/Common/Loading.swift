//
//  Loading.swift
//  Confidant
//
//  Created by Michael Douglas on 22/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

fileprivate let kLoadingViewTag = 100773

//**************************************************************************************************
//
// MARK: - Extension - UIViewController
//
//**************************************************************************************************

extension UIViewController {
    
    func loadingIndicator(_ show: Bool) {
        if show {
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
        } else {
            let window = UIApplication.shared.keyWindow
            window?.viewWithTag(kLoadingViewTag)?.removeFromSuperview()
        }
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - UIButton
//
//**************************************************************************************************

extension UIButton {
    
    override func loadingIndicator(isShow: Bool, frame: CGRect) {
        if isShow {
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: ((buttonWidth/2) + 40), y: buttonHeight/2)
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}

//**************************************************************************************************
//
// MARK: - Extension - UIView
//
//**************************************************************************************************

extension UIView {
    
    func loadingIndicator(isShow: Bool, frame: CGRect) {
        if isShow {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = frame.height
            let buttonWidth = self.bounds.size.width
            
            indicator.center = CGPoint(x: ((buttonWidth/2) + 40), y: buttonHeight/2)
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
}

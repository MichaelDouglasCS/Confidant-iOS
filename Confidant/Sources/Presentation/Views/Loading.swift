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
	
	func loadingIndicatorCustom(isShow show: Bool) {
		
		DispatchQueue.main.async {
			if show {
				var loading = [UIImage]()
				for i in 0...40 {
					let image = UIImage(named: "loading_\(i)")
					if let imageLoad = image {
						loading.append(imageLoad)
					}
				}
				let window = self.navigationController?.view
				let opaqueWindow = UIView(frame: window?.frame ?? .zero)
				opaqueWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
				opaqueWindow.tag = kLoadingViewTag
				let loadingAnimation = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
				loadingAnimation.image = UIImage.animatedImage(with: loading, duration: 1.5)
				loadingAnimation.center = CGPoint(x: opaqueWindow.frame.size.width / 2, y: opaqueWindow.frame.size.height / 2)
				opaqueWindow.addSubview(loadingAnimation)
				window?.addSubview(opaqueWindow)
			} else {
				let window = self.navigationController?.view
				window?.viewWithTag(kLoadingViewTag)?.removeFromSuperview()
			}
		}
	}
	
	func loadingIndicatorCustomTabBar(isShow show: Bool) {
		
		DispatchQueue.main.async {
			if show {
				var loading = [UIImage]()
				for i in 0...40 {
					let image = UIImage(named: "loading_\(i)")
					if let imageLoad = image {
						loading.append(imageLoad)
					}
				}
				let window = self.tabBarController?.view
				let opaqueWindow = UIView(frame: window?.frame ?? .zero)
				opaqueWindow.backgroundColor = UIColor(white: 0, alpha: 0.5)
				opaqueWindow.tag = kLoadingViewTag
				let loadingAnimation = UIImageView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
				loadingAnimation.image = UIImage.animatedImage(with: loading, duration: 1.5)
				loadingAnimation.center = CGPoint(x: opaqueWindow.frame.size.width / 2, y: opaqueWindow.frame.size.height / 2)
				opaqueWindow.addSubview(loadingAnimation)
				window?.addSubview(opaqueWindow)
			} else {
				let window = self.tabBarController?.view
				window?.viewWithTag(kLoadingViewTag)?.removeFromSuperview()
			}
		}
	}
}

//**************************************************************************************************
//
// MARK: - Extension - UIButton
//
//**************************************************************************************************

extension UIButton {
	
	func loadingIndicatorButton(isShow: Bool, at point: CGPoint?) {
		
		DispatchQueue.main.async {
			if isShow {
				let viewHeight = self.bounds.size.height
				let viewWidth = self.bounds.size.width
				let indicator = UIActivityIndicatorView()
				
				indicator.tag = kLoadingViewTag
				indicator.color = UIColor.white
				indicator.center = CGPoint(x: point?.x ?? (viewWidth/2), y: point?.y ?? (viewHeight/2))
				self.isEnabled = false
				self.alpha = 0.5
				self.addSubview(indicator)
				
				indicator.startAnimating()
			} else {
				self.isEnabled = true
				self.alpha = 1.0
				if let indicator = self.viewWithTag(kLoadingViewTag) as? UIActivityIndicatorView {
					indicator.stopAnimating()
					indicator.removeFromSuperview()
				}
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
    
	func loadingIndicatorView(isShow: Bool,
	                          at point: CGPoint? = nil,
	                          isLarge: Bool = false, color: UIColor? = nil) {
		
		DispatchQueue.main.async {
			if isShow {
				let viewHeight = self.frame.height
				let viewWidth = self.frame.width
				let indicator = UIActivityIndicatorView()
				
				indicator.tag = kLoadingViewTag
				indicator.activityIndicatorViewStyle = isLarge ? .whiteLarge : .white
				indicator.color = color ?? UIColor.lightGray
				indicator.center = CGPoint(x: point?.x ?? (viewWidth/2), y: point?.y ?? (viewHeight/2))
				self.addSubview(indicator)
				indicator.startAnimating()
			} else {
				if let indicator = self.viewWithTag(kLoadingViewTag) as? UIActivityIndicatorView {
					indicator.stopAnimating()
					indicator.removeFromSuperview()
				}
			}
		}
	}
	
}

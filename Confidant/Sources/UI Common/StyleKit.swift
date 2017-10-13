/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2015 IBM Corp. All Rights Reserved.
 * 6949 - XXX
 *
 * IMPORTANT:  This IBM software is supplied to you by IBM
 * Corp. ("IBM") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import UIKit

extension UIColor {
	
	struct Confidant {
		static var pink: UIColor { return UIColor(hexadecimal: 0xE15AD7) }
		static var lightGray: UIColor { return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5) }
		static var condensedGray: UIColor { return UIColor(hexadecimal: 0xF0F0F0) }
	}
	
	convenience init(hexadecimal: Int) {
		let red = CGFloat((hexadecimal >> 16) & 0xff)
		let green = CGFloat((hexadecimal >> 8) & 0xff)
		let blue = CGFloat(hexadecimal & 0xff)
		
		self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
	}
}

extension UIView {
	
	func findSuperView<T>(_ type: T.Type) -> T? {
		
		if let superview = self.superview {
			if let found = superview as? T {
				return found
			} else {
				return superview.findSuperView(type)
			}
		}
		
		return nil
	}
	
	func addParallaxMotionEffect(range: Float = 20.0) {
		
		let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		horizontal.minimumRelativeValue = range
		horizontal.maximumRelativeValue = -range
		
		let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
		vertical.minimumRelativeValue = range
		vertical.maximumRelativeValue = -range
		
		let group = UIMotionEffectGroup()
		group.motionEffects = [horizontal, vertical]
		self.addMotionEffect(group)
	}
	
	func removeAllMotionEffects() {
		
		for effect in self.motionEffects {
			self.removeMotionEffect(effect)
		}
	}
	
	func snapshotImage() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
		
		self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
}

extension UIImage {
	
	public enum Format {
		case jpg
		case png
	}
	
	static public let placeholder: UIImage? = UIImage(named: "common_image_placeholder")
	
	public func nineSliced() -> UIImage {
		
		let size = self.size
		
		// Takes the roudend half size.
		let halfW = (Int)(size.width + 1) >> 1;
		let halfH = (Int)(size.height + 1) >> 1;
		
		// The two pixels in the middle will be stretched. Both horizontally and vertically.
		let edge = UIEdgeInsetsMake(CGFloat(halfH - 1),
		                            CGFloat(halfW - 1),
		                            CGFloat(halfH + 1),
		                            CGFloat(halfW + 1))
		
		return self.resizableImage(withCapInsets: edge)
	}
	
	/**
	Resizes the image to the size passed in.
	CGInterpolationQuality.Default is the interpolation quality used.
	
	- parameter size: New size that the image should assume.
	
	- returns: The resizd image.
	*/
	public func resize(_ size: CGSize) -> UIImage {
		
		if size.width < 0 || size.height < 0 {
			return UIImage()
		}
		
		UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
		
		self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let image = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext()
		
		return image ?? UIImage()
	}
	
	/**
	Resizes the image based on the scale passed in. A new size is computed from the scale and the method
	`resize(size: CGSize) -> UIImage` is called with the new calculated size.
	A scale of 2 produces an image with double the original size.
	
	- parameter scale: The scale to take the image.
	
	- returns: Returns image resized.
	*/
	public func resizeWithScale(_ scale: CGFloat) -> UIImage {
		
		let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
		
		return self.resize(newSize)
	}
	
	public func clamped(to value: CGFloat) -> UIImage {
		
		let largest = max(self.size.width, self.size.height)
		let limit = CGFloat(value)
		
		if largest > limit {
			let scale = limit / largest
			return self.resizeWithScale(scale)
		}
		
		return self
	}

	public func base64EncodedString(format: UIImage.Format = .jpg, quality: CGFloat = 0.8) -> String {
		let data: Data?
		
		switch format {
		case .jpg:
			data = UIImageJPEGRepresentation(self, quality)
		default:
			data = UIImagePNGRepresentation(self)
		}
		
		return data?.base64EncodedString() ?? ""
	}
	
	public convenience init?(base64EncodedString string: String) {
		if let data = Data(base64Encoded: string) {
			self.init(data: data)
		} else {
			return nil
		}
	}
	
	func tinted(with tintColor: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage {
		let bounds = CGRect(origin: .zero, size:self.size)
		
		UIGraphicsBeginImageContext(self.size)
		tintColor.setFill()
		UIRectFill(bounds)
		
		self.draw(in: bounds, blendMode: blendMode, alpha: 1.0)
		
		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return tintedImage ?? self
	}
}

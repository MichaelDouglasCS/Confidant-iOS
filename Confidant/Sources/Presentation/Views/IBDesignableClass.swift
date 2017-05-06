//
//  IBDesignableClass.swift
//  Confidant
//
//  Created by Michael Douglas on 1/04/16.
//  Copyright © 2016 Michael Douglas. All rights reserved.
//

import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - IBDesignable Classes
//
//**********************************************************************************************************

//*************************************************
// MARK: - UIView
//*************************************************

@IBDesignable public class IBDesigableView: UIView {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

//*************************************************
// MARK: - UIImageView
//*************************************************

@IBDesignable public class IBDesigableImageView: UIImageView {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

//*************************************************
// MARK: - UIButton
//*************************************************

@IBDesignable public class IBDesigableButton: UIButton {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
	private func setupView() {
		
		// Applying the localization for each preferred style
		let localizedStates: [UIControlState] = [ .normal, .disabled ]
		
		localizedStates.forEach {
			let localizedTitle = self.title(for: $0)?.localized
			
			self.setTitle(localizedTitle, for: $0)
			self.accessibilityHint = localizedTitle
			self.accessibilityLabel = localizedTitle
		}
		
		self.setBackgroundImage(self.backgroundImage(for: .normal)?.nineSliced(), for: .normal)
	}
	
//*************************************************
// MARK: - Override Public Methods
//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
    
}

//*************************************************
// MARK: - UITextField
//*************************************************

@IBDesignable public class IBDesigableTextField: UITextField {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

//*************************************************
// MARK: - UITextView
//*************************************************

@IBDesignable public class IBDesigableTextView: UITextView {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: self.textColor!, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    @IBInspectable var lineSpace: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineSpacing = lineSpace
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: self.textColor!, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString;
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

//*************************************************
// MARK: - UILabel
//*************************************************

@IBDesignable public class IBDesigableLabel: UILabel {
    
    //*************************************************
    // MARK: - Properties
    //*************************************************
    
    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            attributedString.addAttribute(NSKernAttributeName, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: self.textColor!, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    @IBInspectable var lineSpace: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineSpacing = lineSpace
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName, value: self.textColor!, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString;
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

//*************************************************
// MARK: - UINavigationBar
//*************************************************

@IBDesignable public class IBDesignableNavigationBar: UINavigationBar {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    @IBInspectable var navigationHeigh: CGFloat = 44 {
        didSet {
            self.frame.size.height = navigationHeigh
        }
    }
    
    @IBInspectable var backgroundImage: UIImage? {
        didSet{
            self.setBackgroundImage(backgroundImage, for: .default)
        }
    }
	
	//*************************************************
	// MARK: - Override Public Methods
	//*************************************************
	
	override public func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override public func awakeFromNib() {
		super.awakeFromNib()
	}
    
}

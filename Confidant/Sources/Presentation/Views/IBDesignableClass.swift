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

@IBDesignable
class IBDesigableView: UIView {
    
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
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

//*************************************************
// MARK: - UIImageView
//*************************************************

@IBDesignable
class IBDesigableImageView: UIImageView {
    
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
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

//*************************************************
// MARK: - UIButton
//*************************************************

@IBDesignable
class IBDesigableButton: LocalizedButton {
    
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
	
//*************************************************
// MARK: - Override Public Methods
//*************************************************
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

//*************************************************
// MARK: - UITextField
//*************************************************

@IBDesignable
class IBDesigableTextField: UITextField {
    
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
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

//*************************************************
// MARK: - UITextView
//*************************************************

@IBDesignable
class IBDesigableTextView: UITextView {
    
	//**************************************************
	// MARK: - Properties
	//**************************************************
	
	private var placeholderLabel: LocalizedLabel = LocalizedLabel()
	
	@IBInspectable var placeholder: String? {
		get {
			return self.placeholderLabel.text
		}
		
		set {
			self.placeholderLabel.text = "#\((newValue ?? "").localized)#"
		}
	}
	
	override var text: String! {
		didSet {
			self.placeholderLabel.isHidden = self.hasText
		}
	}
	
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	
	//**************************************************
	// MARK: - Protected Methods
	//**************************************************
	
	private func setupView() {
		let attributedString = NSMutableAttributedString(string: self.text.localized)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = self.textAlignment
		paragraphStyle.lineSpacing = 10
		attributedString.addAttribute(NSParagraphStyleAttributeName,
		                              value: paragraphStyle,
		                              range: NSRange(location: 0, length: attributedString.length))
		attributedString.addAttribute(NSFontAttributeName,
		                              value: self.font!,
		                              range: NSRange(location: 0, length: attributedString.length))
		attributedString.addAttribute(NSForegroundColorAttributeName,
		                              value: self.textColor!,
		                              range: NSRange(location: 0, length: attributedString.length))
		self.attributedText = attributedString
		
		self.placeholderLabel.font = self.font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)
		self.placeholderLabel.textColor = UIColor.Confidant.lightGray
		self.placeholderLabel.sizeToFit()
		self.placeholderLabel.frame.origin = CGPoint(x: 5, y: 7)
		self.placeholderLabel.isHidden = self.hasText
		self.addSubview(self.placeholderLabel)
	}
	
	//**************************************************
	// MARK: - Exposed Methods
	//**************************************************
	
	//**************************************************
	// MARK: - Overridden Methods
	//**************************************************
	
	override func becomeFirstResponder() -> Bool {
		self.placeholderLabel.isHidden = true
		return super.becomeFirstResponder()
	}
	
	override func resignFirstResponder() -> Bool {
		self.placeholderLabel.isHidden = self.hasText
		return super.resignFirstResponder()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setupView()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.setupView()
	}
}

//*************************************************
// MARK: - UILabel
//*************************************************

@IBDesignable
class IBDesigableLabel: UILabel {
    
//*************************************************
// MARK: - Properties
//*************************************************
    
    @IBInspectable var letterSpacing: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text?.localized ?? "")
            attributedString.addAttribute(NSKernAttributeName,
                                          value: letterSpacing,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName,
                                          value: self.font ?? UIFont(),
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName,
                                          value: self.textColor ?? UIColor(),
                                          range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
    }
    
    @IBInspectable var lineSpace: CGFloat = 0 {
        didSet {
            let attributedString = NSMutableAttributedString(string: self.text?.localized ?? "")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            paragraphStyle.lineSpacing = lineSpace
            attributedString.addAttribute(NSParagraphStyleAttributeName,
                                          value: paragraphStyle,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSFontAttributeName,
                                          value: self.font ?? UIFont(),
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedString.addAttribute(NSForegroundColorAttributeName,
                                          value: self.textColor ?? UIColor(),
                                          range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString;
        }
    }
	
//*************************************************
// MARK: - Protected Methods
//*************************************************
	
//*************************************************
// MARK: - Override Public Methods
//*************************************************
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

//*************************************************
// MARK: - UINavigationBar
//*************************************************

@IBDesignable
class IBDesignableNavigationBar: UINavigationBar {
    
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
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}

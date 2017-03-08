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
            self.attributedText = attributedString;
        }
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
    
}

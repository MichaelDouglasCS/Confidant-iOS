//
//  UILabel+WelcomeMessageFormat.swift
//  Confidant
//
//  Created by Michael Douglas on 07/03/17.
//  Copyright © 2017 Watermelon. All rights reserved.
//

import UIKit

//**************************************************************************************************
//
// MARK: - Constants -
//
//**************************************************************************************************

//TitleAttributes
fileprivate let kFontSizeTitle: CGFloat = 22
fileprivate let kLetterSpacingTitle: Double = -0.5

//TextAttributes
fileprivate let kLineSpacingText: CGFloat = 10
fileprivate let kFontSizeText: CGFloat = 12

//**************************************************************************************************
//
// MARK: - Extension - UILabel - WelcomeMessageFormat
//
//**************************************************************************************************

extension UILabel {
    
    func getMessageTitleFormat(title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSKernAttributeName, value: kLetterSpacingTitle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: kFontSizeTitle)
        self.textColor = UIColor.white
        self.textAlignment = .center
    }
    
    func getMessageTextFormat(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = kLineSpacingText
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
        self.font = UIFont(name: "Gotham-Bold", size: kFontSizeText)
        self.textColor = UIColor(white: 100, alpha: 0.7)
        self.textAlignment = .center
        self.numberOfLines = 0
    }
    
}


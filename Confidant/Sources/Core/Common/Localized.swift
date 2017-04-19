/*
 *	Local.swift
 *	Sapphire
 *
 *	Created by Michael Douglas on 05/12/16.
 *	Copyright 2017 Watermelon. All rights reserved.
 */

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
// MARK: - Extension - String Local
//
//**********************************************************************************************************

extension String {
	
	struct Local {
		//*************************
		// Labels
		//*************************
		static var carePlan: String { return "LB_CARE_PLAN".localized }
		
		//*************************
		// Strings
		//*************************
		static var hello: String { return "ST_HELLO".localized }
		static var ok: String { return "ST_OK".localized }
		static var today: String { return "ST_TODAY".localized }
		static var yesterday: String { return "ST_YESTERDAY".localized }
		
		//*************************
		// Messages
		//*************************
		static var fingerPrint: String { return "MSG_FINGER_PRINT".localized }
		static var invalidFingerPrint: String { return "MSG_INVALID_FINGER_PRINT".localized }
		
		//*************************
		// Plurals
		//*************************
		static var condition: String { return "PL_CONDITION".localized }
		static var barrier: String { return "PL_BARRIER".localized }
		static var prescription: String { return "PL_PRESCRIPTION".localized }
		static var symptom: String { return "PL_SYMPTOM".localized }
		static var familySupporting: String { return "PL_SUPPORT_SYSTEM".localized }
		static var issue: String { return "PL_ISSUE".localized }
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - String Localized
//
//**********************************************************************************************************

extension String {

//**************************************************
// MARK: - Protected Methods
//**************************************************
	
	private func attribute(for font: UIFont, with trait: UIFontDescriptorSymbolicTraits) -> [String: Any] {
		
		let size = font.pointSize
		var newFont: UIFont
		
		if let descriptor = font.fontDescriptor.withSymbolicTraits(trait) {
			
			newFont = UIFont(descriptor: descriptor, size: size)
			
			if trait == .traitBold {
				newFont = UIFont(name: "\(font.fontName)-Bold", size: size) ?? newFont
			}
		} else {
			newFont = UIFont.systemFont(ofSize: size)
		}
		
		return [ NSFontAttributeName : newFont ]
	}
	
//**************************************************
// MARK: - Exposed Methods
//**************************************************
	
	public var localized: String {
		return NSLocalizedString(self, comment: self)
	}
	
	public func pluralized(_ count: Int) -> String {
		return String.localizedStringWithFormat(self, count)
	}
	
	public func localizedAttributed(for font: UIFont, underline: CGFloat = 2.0) -> NSAttributedString {
		
		let boldStyle = self.attribute(for: font, with: .traitBold)
		let italicStyle = self.attribute(for: font, with: .traitItalic)
		let underlineStyle = [NSUnderlineStyleAttributeName : underline]
		let replacements = [
			"\\#.*?\\#" : boldStyle,
			"\\$.*?\\$" : italicStyle,
			"\\%.*?\\%" : underlineStyle
		]
		
		let att = NSMutableAttributedString(string: self)
		let firstRange = NSRange(location: 0, length: self.characters.count)
		att.setAttributes([ NSFontAttributeName : font ], range: firstRange)
		
		// Loop through all the replacements once to find every single occurence of the patterns.
		for (pattern, attributes) in replacements {
			if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
				var fullRange = NSRange(location: 0, length: att.string.characters.count)
				
				// Loop while there is a first match.
				while let match = regex.firstMatch(in: att.string, options: [], range: fullRange) {
					let range = match.range
					att.addAttributes(attributes, range: range)
					att.deleteCharacters(in: NSRange(location: range.location, length: 1))
					att.deleteCharacters(in: NSRange(location: range.location + range.length - 2, length: 1))
					fullRange = NSRange(location: 0, length: att.string.characters.count)
				}
			}
		}
		
		return att
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - String Validation
//
//**********************************************************************************************************

extension String {
	
	public var isValidEmail: Bool {
		
		let pattern = "\\b[\\w\\.-_]+@[\\w\\.\\-\\_]+\\.\\w{2,}\\b"
		let fullRange = NSRange(location: 0, length: self.characters.count)
		var result = false
		
		if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
			result = (regex.numberOfMatches(in: self, options: [], range: fullRange) > 0)
		}
		
		return result
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - Date Localized
//
//**********************************************************************************************************

extension Date {

	public var localizedFromNow: String {
		let string: String
		let today = Date()
		let yesterday = Date.yesterday
		let dateString = self.stringLocal(date: .medium)
		
		if self.isSameDay(as: today) {
			string = "\(String.Local.today) - \(dateString)"
		} else if self.isSameDay(as: yesterday) {
			string = "\(String.Local.yesterday) - \(dateString)"
		} else {
			string = self.stringLocal(date: .medium)
		}
		
		return string
	}
}

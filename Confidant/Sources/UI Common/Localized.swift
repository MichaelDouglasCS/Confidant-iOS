/*
 *	Local.swift
 *	Confidant
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
		static var welcome: String { return "ST_WELCOME".localized }
		static var anonymously: String { return "ST_ANONYMOUSLY".localized }
		static var randomly: String { return "ST_RANDOMLY".localized }
		static var voluntary: String { return "ST_VOLUNTARY".localized }
		static var score: String { return "ST_SCORE".localized }
		
		//*************************
		// Messages
		//*************************
		static var fingerPrint: String { return "MSG_FINGER_PRINT".localized }
		static var invalidFingerPrint: String { return "MSG_INVALID_FINGER_PRINT".localized }
		static var welcomeMessage: String { return "MSG_WELCOME".localized }
		static var anonymouslyMessage: String { return "MSG_ANONYMOUSLY".localized }
		static var randomlyMessage: String { return "MSG_RANDOMLY".localized }
		static var voluntaryMessage: String { return "MSG_VOLUNTARY".localized }
		static var scoreMessage: String { return "MSG_SCORE".localized }
		
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
	
	public var localized: String {
		return NSLocalizedString(self, comment: self)
	}
	
	public var localizedCountryName: String {
		return Locale.current.localizedString(forRegionCode: self) ?? ""
	}
	
	public var renderHTML: NSAttributedString? {
		guard let stringData = self.data(using: .utf8) else { return nil }
		let options: [String : Any] = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
		                               NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
		return try? NSAttributedString(data: stringData, options: options, documentAttributes: nil)
	}
	
	public func pluralize(_ count: Int) -> String {
		return String.localizedStringWithFormat(self, count)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - String
//
//**********************************************************************************************************

extension String {

	public var capitalizedFirst: String {
		
		if let char = self.characters.first {
			let first = String(char).uppercased()
			let others = self.substring(from: self.index(after: self.startIndex))
			
			return first + others
		}
		
		return self
	}
	
	public var isValidEmail: Bool {
		
		let pattern = "\\b[\\w\\.-_]+@[\\w\\.\\-\\_]+\\.\\w{2,}\\b"
		let fullRange = NSRange(location: 0, length: self.characters.count)
		var result = false
		
		if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
			result = (regex.numberOfMatches(in: self, options: [], range: fullRange) > 0)
		}
		
		return result
	}
	
	public var isStrongPassword: Bool {
		
		let pattern = "(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})"
		let fullRange = NSRange(location: 0, length: self.characters.count)
		var result = false
		
		if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
			result = (regex.numberOfMatches(in: self, options: [], range: fullRange) > 0)
		}
		
		return result
	}
	
	public var encryptedPassword: String {
		
		// MD5 3 times
		let phase1 = self.MD5().MD5().MD5()
		
		// Append a secret phrase
		let phase2 = phase1 + "confidant"
		
		// Run MD5 6 times
		let phase3 = phase2.MD5().MD5().MD5().MD5().MD5()
		
		return phase3
	}
	
	public var highlighted: String {
		
		var newValue = ""
		var skip = true
		let components = self.components(separatedBy: "#")
		
		components.forEach {
			if !skip {
				newValue += "\($0) "
				skip = true
			} else {
				skip = false
			}
		}
		
		let count = newValue.characters.count
		let index = (count > 0) ? newValue.index(before: newValue.endIndex) : newValue.endIndex
		
		return newValue.substring(to: index)
	}
	
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
	
	public func localizedAttributed(for font: UIFont, underline: CGFloat = 2.0) -> NSAttributedString {
		
		let boldStyle = self.attribute(for: font, with: .traitBold)
		let italicStyle = self.attribute(for: font, with: .traitItalic)
		let underlineStyle = [NSUnderlineStyleAttributeName : underline]
		let replacements = [
			"\\#.*?\\#" : boldStyle,
			"\\*.*?\\*" : italicStyle,
			"\\$.*?\\$" : underlineStyle
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
	
	public func halved(by pattern: String, keepFirst: Bool = true) -> String {
		let components = self.components(separatedBy: pattern)
		let midpoint = Int((Double(components.count) / 2.0).rounded(.up))
		let halved: ArraySlice<String>
		
		if keepFirst {
			halved = components.prefix(upTo: midpoint)
		} else {
			halved = components.suffix(from: midpoint)
		}
		
		return halved.joined(separator: pattern)
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

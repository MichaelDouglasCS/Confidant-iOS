/*
 *	MathKit.swift
 *	Confidant
 *
 *	Created by Michael Douglas on 14/11/16.
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
// MARK: - Extension - Int
//
//**********************************************************************************************************

extension Int {
	
	public var negative: Int {
		return self * -1
	}
	
	public var nanoseconds: DateComponents {
		return DateComponents(nanosecond: self)
	}
	
	public var seconds: DateComponents {
		return DateComponents(second: self)
	}
	
	public var minutes: DateComponents {
		return DateComponents(minute: self)
	}
	
	public var hours: DateComponents {
		return DateComponents(hour: self)
	}
	
	public var days: DateComponents {
		return DateComponents(day: self)
	}
	
	public var weeks: DateComponents {
		return DateComponents(weekOfMonth: self)
	}
	
	public var months: DateComponents {
		return DateComponents(month: self)
	}
	
	public var years: DateComponents {
		return DateComponents(year: self)
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - DateComponents
//
//**********************************************************************************************************

extension DateComponents {
	
	public var fromNow: Date {
		let now = Date()
		return Calendar.current.date(byAdding: self, to: now) ?? now
	}
	
	public var ago: Date {
		let now = Date()
		return Calendar.current.date(byAdding: -self, to: now) ?? now
	}
	
	prefix static public func -(components: DateComponents) -> DateComponents {
		var result = DateComponents()
		result.nanosecond = components.nanosecond?.negative
		result.second = components.second?.negative
		result.minute = components.minute?.negative
		result.hour = components.hour?.negative
		result.day = components.day?.negative
		result.weekday = components.weekday?.negative
		result.weekOfMonth = components.weekOfMonth?.negative
		result.weekOfYear = components.weekOfYear?.negative
		result.weekdayOrdinal = components.weekdayOrdinal?.negative
		result.yearForWeekOfYear = components.yearForWeekOfYear?.negative
		result.month = components.month?.negative
		result.quarter = components.quarter?.negative
		result.year = components.year?.negative
		result.era = components.era?.negative
		return result
	}
	
	public static func +(lhs: Date, rhs: DateComponents) -> Date {
		return Calendar.current.date(byAdding: rhs, to: lhs) ?? Date()
	}
	
	public static func -(lhs: Date, rhs: DateComponents) -> Date {
		return lhs + (-rhs)
	}
	
	public static func +=(lhs: inout Date, rhs: DateComponents) {
		lhs = lhs + rhs
	}
	
	public static func -=(lhs: inout Date, rhs: DateComponents) {
		lhs = lhs - rhs
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - Date
//
//**********************************************************************************************************

extension Date {
	
	public var nanosecond: Int {
		return Calendar.current.component(.nanosecond, from: self)
	}
	
	public var second: Int {
		return Calendar.current.component(.second, from: self)
	}
	
	public var minute: Int {
		return Calendar.current.component(.minute, from: self)
	}
	
	public var hour: Int {
		return Calendar.current.component(.hour, from: self)
	}
	
	public var day: Int {
		return Calendar.current.component(.day, from: self)
	}
	
	public var daysInMonth: Int {
		return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
	}
	
	public var weekday: Int {
		return Calendar.current.component(.weekday, from: self)
	}
	
	public var weekdayOrdinal: Int {
		return Calendar.current.component(.weekdayOrdinal, from: self)
	}
	
	public var weekOfMonth: Int {
		return Calendar.current.component(.weekOfMonth, from: self)
	}
	
	public var weekOfYear: Int {
		return Calendar.current.component(.weekOfYear, from: self)
	}
	
	public var month: Int {
		return Calendar.current.component(.month, from: self)
	}
	
	public var year: Int {
		return Calendar.current.component(.year, from: self)
	}
	
	public var startOfDay: Date {
		return Calendar.current.startOfDay(for: self)
	}
	
	public var endOfDay: Date {
		return self.startOfDay + 24.hours - 1.seconds
	}
	
	public static var yesterday: Date {
		return Date() - 1.days
	}
	
	public static var tomorrow: Date {
		return Date() + 1.days
	}
	
	public init?(year: Int = 0,
	            month: Int = 0,
	            day: Int = 0,
	            hour: Int = 0,
	            minute: Int = 0,
	            second: Int = 0) {
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		
		if let date = Calendar.current.date(from: components) {
			self = date
		} else {
			return nil
		}
	}
	
	/**
	Following http://nsdateformatter.com/
	*/
	public init?(string: String, format: String = "MM/dd/yyyy") {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		
		if let date = formatter.date(from: string) {
			self = date
		} else {
			return nil
		}
	}
	
	/**
	Following http://nsdateformatter.com/
	*/
	public func string(format:String = "MM/dd/yyyy") -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.string(from: self)
	}
	
	public func stringLocal(date: DateFormatter.Style = .none,
	                        time: DateFormatter.Style = .none,
	                        template: String? = nil) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = date
		formatter.timeStyle = time
		
		if let string = template {
			formatter.setLocalizedDateFormatFromTemplate(string)
		}
		
		return formatter.string(from: self)
	}
	
	public func isSameDay(as date: Date) -> Bool {
//		return Calendar.current.isDate(self, inSameDayAs: date)
		return self.day == date.day && self.month == date.month && self.year == date.year
	}
}

//**********************************************************************************************************
//
// MARK: - Extension - String
//
//**********************************************************************************************************

extension String {
	
	/**
	Following http://nsdateformatter.com/
	*/
	public func dateLocal(format:String = "MM/dd/yyyy") -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		return formatter.date(from: self)
	}
	
	public func dateLocal(date: DateFormatter.Style = .none, time: DateFormatter.Style = .none) -> Date? {
		let formatter = DateFormatter()
		formatter.dateStyle = date
		formatter.timeStyle = time
		return formatter.date(from: self)
	}
}

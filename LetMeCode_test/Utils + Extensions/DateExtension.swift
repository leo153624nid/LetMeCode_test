//
//  DateExtension.swift
//  LetMeCode_test
//
//  Created by macbook on 08.04.2023.
//

import Foundation
import UIKit

// MARK: - dateFromApiString
func dateFromApiString(_ eventDate: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter.date(from: eventDate)
}

// MARK: - dateFromMyFormatString
func dateFromMyFormatString(_ eventDate: String) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY/MM/dd"
    return formatter.date(from: eventDate)
}

// MARK: - Date
extension Date {
    // MARK: - toMyFormat
    var toMyFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        return formatter.string(from: self)
    }
    
    // MARK: - toApiString
    var toApiString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
    
    // MARK: - dayInt
    var dayInt: Int? {
        let components = Calendar.current.dateComponents([.day], from: self)
        return components.day
    }
    
    // MARK: - monthInt
    var monthInt: Int? {
        let components = Calendar.current.dateComponents([.month], from: self)
        return components.month
    }
    
    // MARK: - yearInt
    var yearInt: Int? {
        let components = Calendar.current.dateComponents([.year], from: self)
        return components.year
    }
    
    // MARK: - lastDayOfThisMonth
    var lastDayOfThisMonth: Int? {
        var components = Calendar.current.dateComponents([.month, .year], from: self)
        var nextMonth = 0
        if let currentMonth = components.month {
            if currentMonth < 12 {
                nextMonth = currentMonth + 1
            } else {
                nextMonth = 1
            }
        }
        components.day = 1
        components.month = nextMonth
        let oneDayInterval = TimeInterval(60 * 60 * 24)
        let lastDayOfThisMonth = Calendar.current.date(from: components)! - oneDayInterval
        let lastComponents = Calendar.current.dateComponents([.day], from: lastDayOfThisMonth)
        return lastComponents.day
    }
}

//
//  DateExtension.swift
//  LetMeCode_test
//
//  Created by macbook on 08.04.2023.
//

import Foundation
import UIKit

extension Date {
    var toMyFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        return formatter.string(from: self)
    }
    
    var toApiString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
}

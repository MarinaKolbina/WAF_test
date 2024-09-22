//
//  DateFormatterHelper.swift
//  TestAssigmentWAF
//
//  Created by Marina Kolbina on 22/09/2024.
//

import Foundation

class DateFormatterHelper {
    
    static func formattedDate(from dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM yyyy"
            outputFormatter.locale = Locale.current
            
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}


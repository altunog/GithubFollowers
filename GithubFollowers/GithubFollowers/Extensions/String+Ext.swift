//
//  String+Ext.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 14.01.2023.
//

import Foundation

extension String {
    
    func converToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    
    func convertToDisplayFormat() -> String {
        guard let date = self.converToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}

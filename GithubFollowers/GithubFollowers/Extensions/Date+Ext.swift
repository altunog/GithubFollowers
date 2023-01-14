//
//  Date+Ext.swift
//  GithubFollowers
//
//  Created by Oğuz Kaan Altun on 14.01.2023.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}

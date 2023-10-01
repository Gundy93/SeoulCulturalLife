//
//  DateFormatter+.swift
//  FreeSeoulCulturalLife
//
//  Created by Gundy on 2023/09/26.
//

import Foundation

extension DateFormatter {
    
    static let shared: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    func dateString(_ start: Date, _ end: Date) -> String {
        let startDate: String = DateFormatter.shared.string(from: start)
        let endDate: String = DateFormatter.shared.string(from: end)
        let dateText = startDate == endDate ? startDate : "\(startDate) ~ \(endDate)"
        
        return dateText
    }
}

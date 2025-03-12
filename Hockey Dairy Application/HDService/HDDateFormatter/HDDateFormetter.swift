//
//  HDDateFormetter.swift
//  Hockey Team Journal
//
//  Created by Den on 05/03/24.
//

import Foundation

extension Date {
    func dayOfWeek(withFormatter dateFormatter: DateFormatter) -> String? {
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
    func nameOfMonth(withFormatter dateFormatter: DateFormatter) -> String? {
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self).capitalized
    }
}

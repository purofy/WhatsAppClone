//
//  Date.swift
//  WhatsAppClone
//
//  Created by Kirill Lebedev on 21.07.24.
//

import Foundation

extension Date {
    var dateOrTimeRepresentation: String {
        let calender = Calendar.current
        let dateFormatter = DateFormatter()
        
        if calender.isDateInToday(self) {
            dateFormatter.dateFormat = "hh:mm"
            
            let formattedDate = dateFormatter.string(from: self)
            return formattedDate
        } else if calender.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
    
    var formatToTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let formattedTime = dateFormatter.string(from: self)
        return formattedTime
    }
}

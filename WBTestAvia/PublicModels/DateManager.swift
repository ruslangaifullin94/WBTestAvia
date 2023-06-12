//
//  DateManager.swift
//  WBTestAvia
//
//  Created by Руслан Гайфуллин on 10.06.2023.
//

import Foundation

final class DateManager {
    
    static let shared = DateManager()
    
   private init () {}
    
    func createDateFromString(from dateString: String, dateStringFormatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateStringFormatter
        return dateFormatter.date(from: dateString)
    }
    
    func getDateToString(from date: Date, timeZoneInSecondFromGMT: Int = 0, dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timeZoneInSecondFromGMT)
        return dateFormatter.string(from: date)
    }
}

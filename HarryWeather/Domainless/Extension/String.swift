//
//  String.swift
//  HarryWeather
//
//  Created by Hariyanto Lukman on 11/12/21.
//

import Foundation

extension String{
    func getDate(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateValue = dateFormatter.date(from:self) ?? Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let result = dateFormatter.string(from: dateValue)
        return result
    }
    
    func getTime(format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateValue = dateFormatter.date(from:self) ?? Date()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        let result = dateFormatter.string(from: dateValue)
        return result
    }
}

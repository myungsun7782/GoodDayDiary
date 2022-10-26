//
//  TimeManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit

class TimeManager {
    static let shared = TimeManager()
    
    private init() {}
    
    func dateToHourMinString(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
    
    func dateToYearMonthDay(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy. MM. dd"
        
        return formatter.string(from: date)
    }
}


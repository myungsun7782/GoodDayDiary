//
//  ColorManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    func getWhite() -> UIColor {
        return UIColor(named: "White")!
    }
    
    func getBlue() -> UIColor {
        return UIColor(named: "Blue")!
    }
    
    func getChineseSilver() -> UIColor {
        return UIColor(named: "ChineseSilver")!
    }
    
    func getDimGray() -> UIColor {
        return UIColor(named: "DimGray")!
    }
    
    func getPhilippineGray() -> UIColor {
        return UIColor(named: "PhilippineGray")!
    }
    
    func getVodka() -> UIColor {
        return UIColor(named: "Vodka")!
    }
}

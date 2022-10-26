//
//  FontManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit

class FontManager {
    static let shared = FontManager()
    
    private init() {}
    
    func getAppleSDGothicNeoHeavy(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeoH00", size: fontSize)!
    }
    
    func getAppleSDGothicNeoBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)!
    }
    
    func getAppleSDGothicNeoRegular(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)!
    }
    
    func getAppleSDGothicNeoLight(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Light", size: fontSize)!
    }
    
    func getAppleSDGothicNeoMedium(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: fontSize)!
    }
    
    func getAppleSDGothicNeoExtraBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeoEB00", size: fontSize)!
    }
    
    func getAppleSDGothicNeoSemiBold(fontSize: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-SemiBold", size: fontSize)!
    }
}


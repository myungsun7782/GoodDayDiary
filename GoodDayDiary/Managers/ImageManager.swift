//
//  ImageManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/26.
//

import UIKit

// Add ImageName
enum ImageName: String {
    case SPLASH_IMAGE = "SplashImage"
    case BUTTERFLY_IMAGE = "ButterFlyImage"
}

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    func getImage(_ imageName: ImageName) -> UIImage {
        return UIImage(named: imageName.rawValue)!
    }
}

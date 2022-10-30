//
//  UserDefaultsManager.swift
//  GoodDayDiary
//
//  Created by myungsun on 2022/10/30.
//

import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let IS_INITIALIZED = "isInitialized"
    private let USER_UID = "userUid"
    
    private init() {}
    
    func getIsInitialized() -> Bool {
        return UserDefaults.standard.bool(forKey: IS_INITIALIZED)
    }
    
    func setIsInitialized() {
        UserDefaults.standard.set(true, forKey: IS_INITIALIZED)
    }
    
    func getUserUid() -> String {
        return UserDefaults.standard.string(forKey: USER_UID)!
    }
    
    func setUserUid(userUid: String) {
        UserDefaults.standard.set(userUid, forKey: USER_UID)
    }
}

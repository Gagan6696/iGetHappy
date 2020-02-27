//
//  UserDefaults.swift
//
//  Created by Gagan
//  Copyright © 2019 Seasia. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults{
  
    func setAccessTokken(value: String?){
        set(value, forKey: UserDefaultsKeys.accessTokken.rawValue)
        //synchronize()
    }
    func setLocation(value: String?){
        set(value, forKey: UserDefaultsKeys.currentLocation.rawValue)
        //synchronize()
    }
    func setLastBreatheImage(value: Data?){
        set(value, forKey: UserDefaultsKeys.breatheImage.rawValue)
        //synchronize()
    }
    func setIsSelectedMusicFromGallery(value: Bool?){
        set(value, forKey: UserDefaultsKeys.lastGetDetailMusic.rawValue)
        //synchronize()
    }
    func setLastBreatheAudio(value: String?){
        set(value, forKey: UserDefaultsKeys.breatheAudio.rawValue)
        //synchronize()
    }
    func setLoggedIn(value: Bool){
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    func setUserId(value: String?){
        set(value, forKey: UserDefaultsKeys.userId.rawValue)
        //synchronize()
    }
    func setDeviceTokken(value: String?){
        set(value, forKey: UserDefaultsKeys.deviceTokken.rawValue)
        //synchronize()
    }
    
    
    func setRefreshTokken(value: String?){
        set(value, forKey: UserDefaultsKeys.refreshTokken.rawValue)
        //synchronize()
    }
    
    func setRememberMe(value:Bool) {
        set(value, forKey: UserDefaultsKeys.rememberMe.rawValue)
        
        
    }
    
    func setFirstName(value:String) {
        set(value, forKey: UserDefaultsKeys.firstName.rawValue)
        
    }
    func setAnonymous(value:String) {
        set(value, forKey: UserDefaultsKeys.anonymous.rawValue)
        
    }
    func setProfileImage(value:String) {
        set(value, forKey: UserDefaultsKeys.profileImage.rawValue)
        
    }
    func setLastName(value:String) {
        set(value, forKey: UserDefaultsKeys.lastName.rawValue)
        
    }
//    func setNickName(value:String) {
//        set(value, forKey: UserDefaultsKeys.nickName.rawValue)
//        
//    }
    func setPassword(value:String) {
        set(value, forKey: UserDefaultsKeys.password.rawValue)
    }
    func setEmail(value:String) {
        set(value, forKey: UserDefaultsKeys.email.rawValue)
    }
    
    //MARK: Retrieve User Data
    func getLastBreatheImage() -> Data?{
        if let value = self.value(forKey:UserDefaultsKeys.breatheImage.rawValue) as? Data
        {
            return value
        }
        return nil
    }
    func getLocation() -> String?{
        if let value = self.value(forKey:UserDefaultsKeys.currentLocation.rawValue) as? String
        {
            return value
        }
        return nil
    }
    
    func getIsSelectedMusicFromGallery() -> Bool?{
        if let value = self.value(forKey:UserDefaultsKeys.lastGetDetailMusic.rawValue) as? Bool
        {
            return value
        }
        return nil
    }
    
    func getLastBreatheMusic() -> String?{
        if let value = self.value(forKey:UserDefaultsKeys.breatheAudio.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getLoggedIn() -> Bool?{
        if let value = self.value(forKey:UserDefaultsKeys.isLoggedIn.rawValue) as? Bool
        {
            return value
        }
        return nil
    }
    
    func getProfileImage() -> String?{
        if let value = self.value(forKey:UserDefaultsKeys.profileImage.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getAnonymous() -> String?{
        if let value = self.value(forKey:UserDefaultsKeys.anonymous.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getUserId() -> String? {
        if let value = self.value(forKey:UserDefaultsKeys.userId.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getEmail() -> String? {
        if let value = self.value(forKey:UserDefaultsKeys.email.rawValue) as? String
        {
            return value
        }
        return nil
    }
   
    func getPassword() -> String? {
       // return string(forKey:UserDefaultsKeys.password.rawValue)!
        if let value = self.value(forKey:UserDefaultsKeys.password.rawValue) as? String
        {
            return value
        }
        return nil
    }
    
    
    func getFirstName() -> String? {
        if let value = self.value(forKey:UserDefaultsKeys.firstName.rawValue) as? String
        {
            return value
        }
        return ""
    }
    func getLastName() -> String? {
        if let value = self.value(forKey:UserDefaultsKeys.lastName.rawValue) as? String
        {
            return value
        }
        return ""
    }
//    func getNickname() -> String? {
//        if let value = self.value(forKey:UserDefaultsKeys.nickName.rawValue) as? String
//        {
//            return value
//        }
//        return nil
//    }
    
    func getAccessTokken() -> String? {
       // return string(forKey:UserDefaultsKeys.accessTokken.rawValue)!
        
        if let value = self.value(forKey:UserDefaultsKeys.accessTokken.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getDeivceTokken() -> String? {
        // return string(forKey:UserDefaultsKeys.accessTokken.rawValue)!
        
        if let value = self.value(forKey:UserDefaultsKeys.deviceTokken.rawValue) as? String
        {
            return value
        }
        return nil
    }
    func getRefreshTokken() -> String? {
        // return string(forKey:UserDefaultsKeys.accessTokken.rawValue)!
        
        if let value = self.value(forKey:UserDefaultsKeys.refreshTokken.rawValue) as? String
        {
            return value
        }
        return nil
    }
   
    
    
}


enum UserDefaultsKeys : String {
    case lastGetDetailMusic
    case breatheImage
    case breatheAudio
    case isLoggedIn
    case currentLocation
    case email
    case userId
    case password
    case firstName
    case lastName
    case nickName
    case profileImage
    case accessTokken
    case deviceTokken
    case refreshTokken
    case rememberMe
    case anonymous
}


extension UserDefaults {
    
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
}

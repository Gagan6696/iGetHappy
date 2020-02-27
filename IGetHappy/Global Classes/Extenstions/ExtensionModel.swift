//
//  Extensions.swift
//  Hark
//
//  Created by MAC-4 on 05/03/19.
//  Copyright © 2019 KBS. All rights reserved.
//

import UIKit
import SystemConfiguration

class ExtensionModel: NSObject
{
    static let shared = ExtensionModel()
    
//    let sharedUserDefault =
//        UserDefaults(suiteName: "group.com.pa.AppName")
    
    //MARK: USERID
    var userID: Int
    {
        get
        {
            let user_Id =  UserDefaults.standard.integer(forKey: defaultKeys.userID)
            return user_Id
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.userID)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    var stored_emoji_array: NSArray
    {
        get
        {
            if let stored_emoji_array =  UserDefaults.standard.array(forKey: "stored_emoji_array")
            {
                return stored_emoji_array as NSArray
            }
            else
            {
                let stored_emoji_array = NSArray ()
                return stored_emoji_array
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: "stored_emoji_array")
            UserDefaults.standard.synchronize()
        }
    }
    
    var Emoji_CurrentPage: Int
    {
        get
        {
            let page =  UserDefaults.standard.integer(forKey: defaultKeys.Emoji_CurrentPage)
            return page
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.Emoji_CurrentPage)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    
    
    var stored_happyMemories_array: NSArray
    {
        get
        {
            if let stored_happyMemories_array =  UserDefaults.standard.array(forKey: defaultKeys.stored_happyMemories_array)
            {
                return stored_happyMemories_array as NSArray
            }
            else
            {
                let stored_happyMemories_array = NSArray ()
                return stored_happyMemories_array
            }
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: defaultKeys.stored_happyMemories_array)
            UserDefaults.standard.synchronize()
        }
    }
    

    
}






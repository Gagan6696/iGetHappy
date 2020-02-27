//
//  Singleton.swift
//  Mysitti
//
//  Created by Mac Mini 102 on 5/10/19.
//  Copyright © 2019 Mysitti. All rights reserved.
//

import UIKit
import CoreLocation

@objc @objcMembers class Singleton: NSObject
{
    private class var swiftSharedInstance: Singleton
    {
        struct SingletonStruct
        {
            static let instance = Singleton()
        }
        return SingletonStruct.instance
    }
    
    private override init()
    {
        
    }
    
    class func shared() -> Singleton
    {
        return Singleton.swiftSharedInstance
    }
    
    var isPlayerDismissed : Bool = false
    var selectedIndex : Int?
    var setGoalDays = "3 Days"
    var totalDays = 3
    var currentDate_for_offline_emojy = ""
    var currentDate_for_offline_emojy_sorting = ""
    var updated_emojy_eventID = ""
    var videoURL:[URL]?
}


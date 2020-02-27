//
//  CompleteRegisterData.swift
//  IGetHappy
//
//  Created by Gagan on 7/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

class CompleteRegisterData
{
    static let sharedInstance:CompleteRegisterData? = CompleteRegisterData()
    var first_name:String?
    var last_name:String?
    var email:String?
    var password:String?
    var language_preferences:[String]?
    var profile_image:UIImage?
    var login_type:String?
    var gender:String?
    var phone:String?
    var social_id:String?
    var nick_name:String?
    var dob:String?
    var referral_code:String?
    var role:String?
    var isAnonymous:String?
    
    private init()
    {
    }
    deinit
    {
        print("Dealloc")
    }
    func Reinitilize()
    {
        CompleteRegisterData.sharedInstance?.first_name = nil
        CompleteRegisterData.sharedInstance?.isAnonymous = "No"
        CompleteRegisterData.sharedInstance?.last_name = nil
        CompleteRegisterData.sharedInstance?.email = nil
        CompleteRegisterData.sharedInstance?.password = nil
        CompleteRegisterData.sharedInstance?.language_preferences = nil
        CompleteRegisterData.sharedInstance?.profile_image = nil
        CompleteRegisterData.sharedInstance?.login_type = nil
        CompleteRegisterData.sharedInstance?.gender = nil
        CompleteRegisterData.sharedInstance?.phone = nil
        CompleteRegisterData.sharedInstance?.social_id = nil
        CompleteRegisterData.sharedInstance?.nick_name = nil
        CompleteRegisterData.sharedInstance?.dob = nil
        CompleteRegisterData.sharedInstance?.referral_code = nil
        CompleteRegisterData.sharedInstance?.role = nil
        
        
    }
}

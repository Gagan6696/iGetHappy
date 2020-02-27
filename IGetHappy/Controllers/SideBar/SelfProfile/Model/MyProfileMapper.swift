//
//  MyProfileMapper.swift
//  IGetHappy
//
//  Created by Gagan on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper

class MyProfileMapper: Mappable
{
    
    var status : Int?
    var message : String?
    var data : MyProfileMapperDetail?
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        status  <- map["status"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}

struct  MyProfileMapperDetail : Mappable
{
    var care_giver_id: String?
    var is_care_receiver_minor: String?
    var relationship: String?
    var language_preferences: [String]?
    var gender: String?
    var is_anonymous: String?
    var _id: String?
    var email: String?
    var password: String?
    var last_name : String?
    var nick_name : String?
    var dob : String?
    var profile_image: String?
    var phone : String?
    var phone_code : String?
    var first_name: String?
    var ventsCount : String?
    var meditationSessionCount : String?
    var happyTimesCount : String?
    var joinDate : String?
    var created_at : String?
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        care_giver_id <- map["care_giver_id"]
        is_care_receiver_minor <- map["is_care_receiver_minor"]
        relationship <- map["relationship"]
        language_preferences <- map["language_preferences"]
        gender <- map["gender"]
        is_anonymous <- map["is_anonymous"]
        _id <- map["_id"]
        email <- map["email"]
        password <- map["password"]
        last_name <- map["last_name"]
        nick_name <- map["nick_name"]
        dob <- map["dob"]
        profile_image <- map["profile_image"]
         phone <- map["phone"]
        phone_code <- map["phone_code"]
        first_name <- map["first_name"]
        ventsCount <- map["ventsCount"]
        meditationSessionCount <- map["meditationSessionCount"]
        happyTimesCount <- map["happyTimesCount"]
        joinDate <- map["joinDate"]
        created_at <- map["created_at"]
    }
    
}


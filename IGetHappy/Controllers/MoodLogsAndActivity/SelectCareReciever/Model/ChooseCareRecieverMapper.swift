//
//  ChooseCareRecieverMapper.swift
//  IGetHappy
//
//  Created by Gagan on 10/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//


import Foundation
import ObjectMapper


class ChooseCareRecieverMapper: Mappable
{
    
    var status : Int?
    var message : String?
    var data : [ChooseCareRecieverDetail]?
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

struct  ChooseCareRecieverDetail : Mappable
{
    
    var is_care_receiver_minor: String?
    var relationship: String?
    var _id: String?
    var care_giver_id: String?
    var name : String?
    var email: String?
    var password: String?
    var phone : String?
    var first_name: String?
    var profile_image: String?
    var __v : Int?
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        is_care_receiver_minor <- map["is_care_receiver_minor"]
        relationship <- map["relationship"]
        _id <- map["_id"]
        care_giver_id <- map["care_giver_id"]
        email <- map["email"]
        password <- map["password"]
        phone <- map["phone"]
        first_name <- map["first_name"]
        profile_image <- map["profile_image"]
        __v <- map["__v"]
    }
    
}


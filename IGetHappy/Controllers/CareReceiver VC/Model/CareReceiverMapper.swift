//
//  CareReceiverMapper.swift
//  IGetHappy
//
//  Created by Gagan on 11/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper

class CareReceiverMapper: Mappable {
    
    var status : Int?
    var message : String?
    var data : [CareReceiverDetail]?
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}

struct  CareReceiverDetail : Mappable {
    
    var care_giver_id: String?
    var is_care_receiver_minor: String?
    var relationship: String?
    var gender : String?
    var is_anonymous: String?
    var status: String?
    var _id : String?
    var first_name: String?
    var email : String?
    var phone : String?
    var profile_image: String?
    var last_name : String?
    var nick_name : String?
    var __v : Int?
    
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        
    care_giver_id <- map["care_giver_id"]
    is_care_receiver_minor <- map["is_care_receiver_minor"]
    relationship <- map["relationship"]
    gender <- map["gender"]
    is_anonymous <- map["is_anonymous"]
    status <- map["status"]
    _id <- map["_id"]
    first_name <- map["first_name"]
    last_name <- map["last_name"]
    nick_name <- map["nick_name"]
    email <- map["email"]
    phone <- map["phone"]
    profile_image <- map["profile_image"]
    __v <- map["__v"]
    }
    
}


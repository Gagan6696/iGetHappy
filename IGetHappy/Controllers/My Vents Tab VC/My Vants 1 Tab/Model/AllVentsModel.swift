//
//  AllVentsModel.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper


class AllVentsModel: Mappable
{
    
    var status : Int?
    var message : String?
    var data : AllVentsDetail?
    
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

struct AllVentsDetail : Mappable
{
    
    var created_at: String?
    var updated_at: String?
    var _id: String?
    var user_id : String?
    var moodTrack: String?
    var eventsActivity: String?
    var careReceiverId : String?
    var privacy_option: String?
    var description: String?
    var post_upload_type: String?
    var post_upload_file: String?
    var __v : Int?
    
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        _id <- map["_id"]
        user_id <- map["user_id"]
        moodTrack <- map["status"]
        eventsActivity <- map["_id"]
        careReceiverId <- map["email"]
        privacy_option <- map["is_anonymous"]
        description <- map["role"]
        post_upload_type <- map["first_name"]
        post_upload_file <- map["last_name"]
        __v <- map["__v"]
    }
    
}


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
    var data : [AllVentsModelDetail]?
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

struct  AllVentsModelDetail : Mappable
{
    
    var numOfShared : Int?
    var numOfComments :Int?
    var numOfLikes : Int?
    var like_type : [String]?
    var profile_image:String?
    var username : String?
    var status : String?
    var liked : String?
    var is_anonymous : String?
    var created_at: String?
    var updated_at: String?
    var _id: String?
    var user_id : String?
    var moodTrack: String?
    var eventsActivity: String?
    var careReceiverId : String?
    var privacy_option: String?
    var desc: String?
    var post_upload_type: String?
    var post_upload_file: String?
    var user_name: String?
    
    var __v : Int?
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        numOfShared <- map["numOfShared"]
        numOfComments <- map["numOfComments"]
        numOfLikes <- map["numOfLikes"]
        like_type <- map["like_type"]
        profile_image <- map["profile_image"]
        username <- map["username"]
        status <- map["status"]
        liked <- map["liked"]
        is_anonymous <- map["is_anonymous"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        _id <- map["_id"]
        user_id <- map["user_id"]
        moodTrack <- map["moodTrack"]
        eventsActivity <- map["eventsActivity"]
        careReceiverId <- map["careReceiverId"]
        privacy_option <- map["privacy_option"]
        desc <- map["description"]
        post_upload_type <- map["post_upload_type"]
        post_upload_file <- map["post_upload_file"]
        user_name <- map["user_name"]
        __v <- map["__v"]
    }
    
}


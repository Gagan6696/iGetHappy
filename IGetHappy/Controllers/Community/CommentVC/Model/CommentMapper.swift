//
//  CommentMapper.swift
//  IGetHappy
//
//  Created by Gagan on 11/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import ObjectMapper


class CommentsMapper: Mappable {
    
    var status : Int?
    var message : String?
    var data : [CommentsMapperDetail]?
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["status"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}

struct  CommentsMapperDetail : Mappable {
    
    var _id: String?
    var created_at: [String]?
    var user_id: String?
    var post_id: String?
    var comment : String?
    var username: String?
    var profile_image: String?
    
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        _id <- map["_id"]
        created_at <- map["created_at"]
        user_id <- map["user_id"]
        post_id <- map["post_id"]
        comment <- map["comment"]
        username <- map["username"]
        profile_image <- map["profile_image"]
        
    }
    
}


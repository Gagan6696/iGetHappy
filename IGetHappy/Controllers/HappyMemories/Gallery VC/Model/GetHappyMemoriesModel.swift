//
//  GetHappyMemoriesModel.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import ObjectMapper

class GetHappyMemoriesMapper: Mappable
{
    
    var status : Int?
    var message : String?
    var data : [HappyMemoriesDetails]?
    
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

struct HappyMemoriesDetails : Mappable
{
    
    var post_upload_type: String?
    var user_id: String?
    var _id: String?
    var desc : String?
    var location: String?
    var created_at: String?
    var updated_at : String?
    var __v : Int?
    var post_upload_file : [String]?
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        _id <- map["_id"]
        user_id <- map["user_id"]
        desc <- map["description"]
        location <- map["location"]
        post_upload_type <- map["post_upload_type"]
        post_upload_file <- map["post_upload_file"]
        __v <- map["__v"]
    }
    
}


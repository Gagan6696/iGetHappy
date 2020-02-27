//
//  ActivityCountMapper.swift
//  IGetHappy
//
//  Created by Gagan on 12/13/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import Foundation
import ObjectMapper

class ActivityCountMapper: Mappable
{
    var status : Int?
    var message : String?
    var data : [ActivityCountMapperDetail]?
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

struct  ActivityCountMapperDetail : Mappable
{

    var _id: String?
    var count: Int?

    init?(map: Map)
    {
        
    }
    mutating  func mapping(map: Map)
    {
        _id <- map["_id"]
        count <- map["count"]
    }
    
}


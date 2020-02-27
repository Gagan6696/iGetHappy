//
//  LanguagesMapper.swift
//  IGetHappy
//
//  Created by Gagan on 7/11/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper


class LanguagesMapper: Mappable {
    
    var status : Int?
    var message : String?
    var data : [LanguagesDetail]?
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["code"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}

struct LanguagesDetail : Mappable {
     var created_at: String?
    var updated_at: String?
    var status: String?
    var _id: String?
    var country_name: String?
    var country_code: String?
    var languages: [AllLanguages]?
    
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        status <- map["status"]
        _id <- map["_id"]
        country_name <- map["country_name"]
        country_code <- map["country_code"]
        languages <- map["languages"]
    }
    
}
struct AllLanguages : Mappable {
    var created_at: String?
    var updated_at: String?
    var status: String?
    var _id: String?
    var language_name: String?

    
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        status <- map["status"]
        _id <- map["_id"]
        language_name <- map["language_name"]
       
    }
    
}

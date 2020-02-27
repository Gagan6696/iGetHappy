//
//  ForgotMapper.swift
//  IGetHappy
//
//  Created by Gagan on 7/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper


class ForgotData: Mappable {
    
    var status : Int?
    var message : String?
    var data : String?
   
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["code"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}



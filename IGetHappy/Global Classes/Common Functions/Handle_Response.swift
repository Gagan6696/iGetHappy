//
//  Handle_Response.swift
//  Hark
//
//  Created by MAC-4 on 05/03/19.
//  Copyright © 2019 KBS. All rights reserved.
//

import UIKit
import ObjectMapper

class Handle_Response: NSObject,Mappable
{
    
    var status : Int?
    var id :Int?
    var messege : String?
    
    var  AllVentsData : [AllVentsModel]?

    override init()
    {
        super.init()
    }
    
    convenience required init?(map: Map)
    {
        self.init()
    }
    
    func mapping(map: Map)
    {
        status <- map["status"]
        messege <- map["message"]
        AllVentsData <- map["data"]
    }
}

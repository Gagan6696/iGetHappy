//
//  EditReminderMapper.swift
//  IGetHappy
//
//  Created by Gagan on 1/30/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper


class EditReminderMapper: Mappable
{
    
    var complete_date : Date?
    var day_for_recurring : String?
    var desc : String?
     var identifier : String?
     var notification_ids : String?
     var recurring_approach : String?
     var state : String?
     var table_id : String?
     var text_info : String?
     var title : String?
     var total_dates : String?
     var trigger_date : Date?
     var trigger_time : String?
     var type : String?
     var user_id : String?
   
    required init?(map: Map)
    {
        
    }
    
    
    func mapping(map: Map)
    {
        complete_date  <- map["complete_date"]
        day_for_recurring <- map["day_for_recurring"]
        desc  <- map["desc"]
        identifier  <- map["identifier"]
        notification_ids  <- map["notification_ids"]
        recurring_approach  <- map["recurring_approach"]
        state  <- map["state"]
        table_id  <- map["table_id"]
        text_info  <- map["text_info"]
        title  <- map["title"]
        total_dates  <- map["total_dates"]
        trigger_date  <- map["trigger_date"]
        trigger_time  <- map["trigger_time"]
        type  <- map["type"]
        user_id  <- map["user_id"]
    }
    
}


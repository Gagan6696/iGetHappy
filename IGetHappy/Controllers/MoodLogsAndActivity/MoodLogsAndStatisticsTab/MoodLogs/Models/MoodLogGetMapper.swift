//
//  MoodLogGetMapper.swift
//  IGetHappy
//
//  Created by Gagan on 11/18/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper

class MoodLogGetMapper: Mappable {
    
    var status : Int?
    var message : String?
    var data : [MoodLogDetails]?
   
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["code"]
        message <- map["message"]
        data  <- map["data"]
    }
    
}

struct MoodLogDetails : Mappable {
    
    var _id: String?
    var user_id: String?
    var moodTrack: String?
    var eventsActivity : String?
    var careReceiverId: String?
    var privacy_option: String?
    var description: String?
    var moodTrackResId: String?
    var post_upload_type: String?
    var post_upload_file : String?
    var updated_at: String?
    var mood_track_time: String?
   
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        _id <- map["_id"]
        user_id <- map["user_id"]
        moodTrack <- map["moodTrack"]
        eventsActivity <- map["eventsActivity"]
        careReceiverId <- map["careReceiverId"]
        privacy_option <- map["privacy_option"]
        description <- map["description"]
        moodTrackResId <- map["moodTrackResId"]
        post_upload_type <- map["post_upload_type"]
        post_upload_file <- map["post_upload_file"]
        updated_at <- map["updated_at"]
        mood_track_time <- map["mood_track_time"]
    }
    
}

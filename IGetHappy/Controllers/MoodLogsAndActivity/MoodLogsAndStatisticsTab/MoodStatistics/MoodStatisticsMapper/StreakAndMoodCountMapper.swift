//
//  StreakAndMoodCountMapper.swift
//  IGetHappy
//
//  Created by Gagan on 12/12/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import ObjectMapper


class StreakAndMoodCountMapper: Mappable
{
    var status : Int?
    var message : String?
    var data : StreakAndMoodCountMapperDetail?
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

struct  StreakAndMoodCountMapperDetail : Mappable
{
    
    var dayStatus: [StreakMapperDetail]?
    var streak: Int?
    var moodCount: [MoodCountMapperDetail]?
    
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        dayStatus <- map["dayStatus"]
        streak <- map["streak"]
        moodCount <- map["moodCount"]
       
    }
    
}


struct  StreakMapperDetail : Mappable
{
    
    var date: String?
    var status: Bool?
   
    
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        date <- map["date"]
        status <- map["status"]
    }
    
}

struct  MoodCountMapperDetail : Mappable
{
    
    var _id: String?
    var moodTrack: String?
    var count: Int?
    
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        count <- map["count"]
        moodTrack <- map["moodTrack"]
        _id <- map["_id"]
        
    }
    
}



//
//  MoodStatisticsMapper.swift
//  IGetHappy
//
//  Created by Gagan on 12/12/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

import ObjectMapper

class MoodStatisticsMapper: Mappable
{
    var status : Int?
    var message : String?
    var data : [MoodStatisticsDaysDetail]?
    var groupedByWeek : [MoodStatisticsWeekDetail]?
    required init?(map: Map)
    {
        
    }
    func mapping(map: Map)
    {
        status  <- map["status"]
        message <- map["message"]
        data  <- map["data"]
        groupedByWeek <- map["groupedByWeek"]
    }
    
}

struct  MoodStatisticsDaysDetail : Mappable
{
    
    
    var key : String?
    var catname: String?
    var count: String?
    
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        key <- map["key"]
        catname <- map["catname"]
        count <- map["count"]
    }
    
}

struct  MoodStatisticsWeekDetail : Mappable
{
    
    
    var key : String?
    var catname: String?
    var count: String?
    var mydate : String?
    var week :String?
    init?(map: Map)
    {
        
    }
    
    mutating  func mapping(map: Map)
    {
        key <- map["key"]
        catname <- map["catname"]
        count <- map["count"]
        mydate <- map["mydate"]
        week <- map["week"]
    }
    
}


//
//  ChatModel.swift
//  IGetHappy
//
//  Created by Gurleen Osahan on 2/12/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import Foundation

struct ChatDataFirst: Codable {
    var info: info
  
}
struct ChatData: Codable {
    var info: info
    var text:String
    
}
struct info: Codable  {
    
    var user_name: String
    var first_use:Bool
    var active_context: [String]?
    var last_context:  [String]?
    var care_giver:Bool
    var charge: String
    
    var mobile_command: String
    var dominant_emotion: String
    var num_missed_meditation: Int
    var missed_apt: String
    var cause: String
    var emotion: String
    var normalized: Int
    var location: String
    var relationship: String
    var last_requested:String
    
    
}

struct userDetails: MSGUser {
    var displayName: String
    var avatar: UIImage?
    var avatarUrl: URL?
    var isSender: Bool
    
}
struct chatBotOutput:Decodable{
    var message: String?
    var status: Int?
    var response: response?
}
struct response:Decodable{
    var info: infoDetails?
    var reply: String?
}
struct infoDetails:Decodable{
    var care_giver: Bool?
    var charge: String?
    var first_use: Bool?
    var mobile_command: String?
    var user_name: String?
  
}

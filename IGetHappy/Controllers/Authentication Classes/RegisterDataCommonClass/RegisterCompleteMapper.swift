//
//  RegisterCompleteMapper.swift
//  IGetHappy
//
//  Created by Gagan on 7/11/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import ObjectMapper

class RegisterCompleteMapper: Mappable{
    var status : Int?
    var message : String?
    var data : RegisterDetail?
    var token : String?
    required init?(map: Map) {
        
    }
    
    
    func mapping(map: Map) {
        status  <- map["code"]
        message <- map["message"]
        data  <- map["data"]
        token <- map["token"]
    }
    
}

struct RegisterDetail : Mappable {
    
    var speciality: String?
    var language_preferences: [String]?
    var gender: String?
    var login_type: String?
    var status : String?
    var _id: String?
    var email: String?
    var role : String?
    var first_name: String?
    var last_name: String?
    var nick_name: String?
    var dob: String?
    var work_experience: String?
    var profile_image : String?
    var phone: String?
    var referral_code: String?
    var social_id: String?
    var country: String?
    var isAnonymous:String?
    var __v : Int?
    
    init?(map: Map) {
        
    }
    
    mutating  func mapping(map: Map) {
        speciality <- map["speciality"]
        isAnonymous <- map["is_anonymous"]
        language_preferences <- map["language_preferences"]
        gender <- map["gender"]
        login_type <- map["login_type"]
        status <- map["status"]
        _id <- map["_id"]
        email <- map["email"]
        role <- map["role"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        nick_name <- map["nick_name"]
        dob <- map["dob"]
        work_experience <- map["work_experience"]
        profile_image <- map["profile_image"]
        phone <- map["phone"]
        referral_code <- map["referral_code"]
        social_id <- map["social_id"]
        country <- map["country"]
        __v <- map["__v"]
    }
}




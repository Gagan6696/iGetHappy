//
//  UrlStrings.swift
//  IGetHappy
//
//  Created by Gagan on 5/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class UrlStrings: NSObject
{
    
    static let sharedInstance = UrlStrings()
    
    //static let BASE_URL = "http://203.100.79.159:9054/"
    //Current Working For client
    static let BASE_URL = "https://np.seasiafinishingschool.com/igethappy/"
    //Current working for token Implementation
   // static let BASE_URL = "http://10.8.18.54:8063/"
    // static let BASE_URL = "http://10.8.18.54:9054/"
    
    struct  Login
    {
        static let loginUrl = "auth/login"
    }
    struct  Forgot
    {
        static let forgotUrl = "auth/forgotPassword"
    }
    
    //TEst
  
    struct ChooseCareReciever
    {
        static let getcarereceiver = "careReceivers/getcarereceiver"
    }
    struct Home
    {
        static let moodTracking = "moodTracking"
    }
    
    struct  Register
    {
        static let isEmailExist = "auth/users/isEmailExists/"
        static let registerNewUser = "auth/signup"
          static let isPhoneExist = "auth/users/isPhoneExists/"
    }
    struct  Languages {
        static let getLanguages = "auth/countries/getByCountryCode/"
        //static let getLanguages = "countries/getByCountryCode/"
       
    }
    struct  AddCareReciever {
        static let careReceivers = "careReceivers/"
        
    }
    
    struct  GetUserProfile {
        static let getUserProfile = "users/getUserProfile/"
        
    }
    
    struct  EditCareReciever {
        static let editCareReceivers = "careReceivers/"
        
    }
    
    struct UploadPost{
         //static let AllTypePost = "community/posts"
         static let AllTypePost = "community"
    }
    
    struct EditPost{
        static let textTypePost = "community/posts/"
    }
    
    struct LikePost{
        static let likePost = "community/posts/likes"
    }
    
    struct DeletePost{
        static let deletePost = "community/posts/"
    }
    
    struct SharePost{
        static let sharePost = "postComment/shairedPost"
    }
    
    struct PostAbuse{
        static let postAbuse = "postAbuse/addPostAbuse"
    }
    
    struct GetAllPost{
        static let getAllPost = "community/posts/?user_id="
    }
    
    struct GetPostedEvents{
        static let getShared = "eventPost/"
    }
    
    struct GetMyVents{
        static let getMyVents = "community/posts/getVents"
    }
    struct GetEmotion{
        static let getEmotion = "http://np.seasiafinishingschool.com:8090/upload"
    }
    
    struct HappyMemories
    {
        static let uploadHappyMemories = "uploadHappyMemories"
        static let getHappyMemories = "uploadHappyMemories/"
    }
   
    struct MyVents
    {
        static let deleteVents = "community/posts/"
        static let editVents = "uploadHappyMemories/"
    }
    
    
}

//
//  Post.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/16/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit

class Post {
    
    var isEditingMode: Bool?
    var userId : String?
    var userName : String?
    var userImageURL : String?
    var postImageURL : String?
    var postDescription : String? = nil
    var isAnonymous : String?
    var privacyOption : String?
    var postId : String?
    var postType : String?
    var postfile : String?
    var isLike : Int?
    var emojiType : String?
    var postTimeStamp : String? = nil
    
    //shared
    var isShared : Int?
    var post_post_upload_type : String?
    var shared_user_image : String?
    var post_username : String?
    var post_userimage : String?
    var post_postfile : String?
    var post_privacy_option : String?
    var post_description : String?
    var post_liked_type : String?
    var post_liked : Int?
    var post_id_post : String?
    
    //Comment Array
    var commentDataArray = [CommentListModel]()
    
    //Mood Log Data
    var is_file_exist: String?
//    var created_at:String?
    var updated_at: String?
//    var _id: String?
//    var user_id: String?
    var moodTrack: String?
    var eventsActivity: String?
    var careReceiverId: String?
//    var privacy_option: String?
 //   var description: String?
    var moodTrackResId: String?
//    var post_upload_type: String?
    var mood_track_time: String?
    var post_upload_file: String?
    var current_time: String?
    var isMoodLog: Int?
    
    //Share moodLog
    var post_is_file_exist: String?
    var post_moodTrack: String?
    var post_eventsActivity: String?
    var post_careReceiverId: String?
    var post_moodTrackResId: String?
    var post_mood_track_time: String?
    var post_current_time: String?
    var share_mood_log_id:String?
    
    
    init(postDetail: [String: Any]) {
        if let isEditingMode = postDetail["isEditingMode"] as? Bool{
            self.isEditingMode = isEditingMode
        }
        if let userId = postDetail["user_id"] as? String{
            self.userId = userId
        }
        if let userName = postDetail["username"] as? String{
            self.userName = userName
        }
        if let userImageURL = postDetail["userimage"] as? String{
            self.userImageURL = userImageURL
        }
        if let postDescription = postDetail["description"] as? String{
            self.postDescription = postDescription
        }
        if let postImageURL = postDetail["postimage"] as? String{
            self.postImageURL = postImageURL
        }
        if let isAnonymous = postDetail["is_anonymous"] as? String{
            self.isAnonymous = isAnonymous
        }
        if let privacyOption = postDetail["privacy_option"] as? String{
            self.privacyOption = privacyOption
        }
        if let postId = postDetail["_id"] as? String{
            self.postId = postId
        }
        if let postType = postDetail["post_upload_type"] as? String{
            self.postType = postType
        }
        if let postfile = postDetail["postfile"] as? String{
            self.postfile = postfile
        }
        if let isLike = postDetail["liked"] as? Int
        {
            self.isLike = isLike
        }
        if let emojiType = postDetail["liked_type"] as? String{
            self.emojiType = emojiType
        }
        if let postTimeStamp = postDetail["created_at"] as? String{
            self.postTimeStamp = postTimeStamp
        }
        
        
        //shared
        if let isshared = postDetail["isShared"] as? Int{
            self.isShared = isshared
        }
        if let typepost = postDetail["post_post_upload_type"] as? String
        {
            self.post_post_upload_type = typepost
        }
        if let usrimg = postDetail["profile_image"] as? String
        {
            self.shared_user_image = usrimg
        }
        if let nm = postDetail["post_username"] as? String
        {
            self.post_username = nm
        }
        if let img = postDetail["post_userimage"] as? String
        {
            self.post_userimage = img
        }
        
        if let postfile = postDetail["post_postfile"] as? String
        {
            self.post_postfile = postfile
        }
        
        if let privcy = postDetail["post_privacy_option"] as? String
        {
            self.post_privacy_option = privcy
        }
        if let desc = postDetail["post_description"] as? String
        {
            self.post_description = desc
        }
        
        if let ptype = postDetail["post_liked_type"] as? String
        {
            self.post_liked_type = ptype
        }
        if let lkd = postDetail["liked"] as? Int
        {
            self.post_liked = lkd
        }
        if let pid = postDetail["post_id"] as? String
        {
            self.post_id_post = pid
        }
        
        if let commentArr = postDetail["comment_arr"] as? [[String:Any]]{
            if commentArr.count > 0{
                commentDataArray.removeAll()
                _ = commentArr.map({ (value) in
                    let model = CommentListModel.init(dict: value)
                    commentDataArray.append(model)
                })
            }else{
                commentDataArray.removeAll()
            }
        }
        
        //Mood Logs
        
        if let is_file_exist = postDetail["is_file_exist"] as? String{
            self.is_file_exist = is_file_exist
        }
//        if let created_at = postDetail["created_at"] as? String{
//            self.created_at = created_at
//        }
        if let updated_at = postDetail["updated_at"] as? String{
            self.updated_at = updated_at
        }
//        if let _id = postDetail["_id"] as? String{
//            self._id = _id
//        }
//        if let user_id = postDetail["user_id"] as? String{
//            self.user_id = user_id
//        }
        if let moodTrack = postDetail["moodTrack"] as? String{
            self.moodTrack = moodTrack
        }
        if let eventsActivity = postDetail["eventsActivity"] as? String{
            self.eventsActivity = eventsActivity
        }
        if let careReceiverId = postDetail["careReceiverId"] as? String{
            self.careReceiverId = careReceiverId
        }

        if let moodTrackResId = postDetail["moodTrackResId"] as? String{
            self.moodTrackResId = moodTrackResId
        }

        if let mood_track_time = postDetail["mood_track_time"] as? String{
            self.mood_track_time = mood_track_time
        }
        if let post_upload_file = postDetail["post_upload_file"] as? String{
            self.post_upload_file = post_upload_file
        }
        if let current_time = postDetail["current_time"] as? String{
            self.current_time = current_time
        }
        if let isMoodLog = postDetail["isMoodLog"] as? Int{
            self.isMoodLog = isMoodLog
        }
        
        
        //Share Mood Log
        
 
        if let post_is_file_exist = postDetail["post_is_file_exist"] as? String{
            self.post_is_file_exist = post_is_file_exist
        }
        if let share_mood_log_id = postDetail["share_mood_log_id"] as? String{
            self.share_mood_log_id = share_mood_log_id
        }
       
        if let post_moodTrack = postDetail["post_moodTrack"] as? String{
            self.post_moodTrack = post_moodTrack
        }
        if let post_eventsActivity = postDetail["post_eventsActivity"] as? String{
            self.post_eventsActivity = post_eventsActivity
        }
        if let post_careReceiverId = postDetail["post_careReceiverId"] as? String{
            self.post_careReceiverId = post_careReceiverId
        }

        if let post_moodTrackResId = postDetail["post_moodTrackResId"] as? String{
            self.post_moodTrackResId = post_moodTrackResId
        }

        if let post_mood_track_time = postDetail["post_mood_track_time"] as? String{
            self.post_mood_track_time = post_mood_track_time
        }

        if let post_current_time = postDetail["post_current_time"] as? String{
            self.post_current_time = post_current_time
        }
       
        
    }
    
    internal struct CommentListModel {
        var id : String?
        var createdAt : String?
        var updatedAt : String?
        var userID: String?
        var postID : String?
        var comment : String?
        var commentLocalID: String?
        var username: String?
        var profileImage: String?
        
        init(dict:[String:Any]) {
            self.id = dict["_id"] as? String
            self.createdAt = dict["created_at"] as? String
            self.updatedAt = dict["updated_at"] as? String
            self.userID = dict["user_id"] as? String
            self.postID = dict["post_id"] as? String
            self.comment = dict["comment"] as? String
            self.commentLocalID = dict["commentLocalId"] as? String
            self.username = dict["username"] as? String
            self.profileImage = dict["profile_image"] as? String
        }
    
    }
    
    
}

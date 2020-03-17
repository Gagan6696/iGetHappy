//
//  CommunityViewModel.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/23/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit

class CommunityViewModel: NSObject
{
    static var postListingModelArray = [Post]()
    
    static func getAllPostService(params: [String: AnyObject], controller: UIViewController, completion: @escaping (_ success: Bool,_ responseArray: [Post?], _ error: String?) -> Void)
    {
        
        guard let userID = UserDefaults.standard.getUserId() else {return}
        let url = UrlStrings.BASE_URL + UrlStrings.GetAllPost.getAllPost
       
        ServiceCall.sharedManager.serviceApi(url, requestDict: params, method: .post, compBlock: { (response, dataResponse) in
            if response["status"] as? Int == 200
            {
                
                if let dataArray = response["data"] as? [[String : AnyObject]]
                {
                    var modelArray = [Post]()
                    for resultData in dataArray
                    {
                        var dict = [String: Any]()
                        dict["user_id"] = resultData["user_id"]
                        dict["username"] = resultData["username"]
                        dict["userimage"] = resultData["userimage"]
                        dict["description"] = resultData["description"]
                        dict["postimage"]  = resultData["postimage"]
                        dict["is_anonymous"]  = resultData["is_anonymous"]
                        dict["privacy_option"]  = resultData["privacy_option"]
                        dict["_id"]  = resultData["_id"]
                        dict["post_upload_type"]  = resultData["post_upload_type"]
                        dict["postfile"]  = resultData["postfile"]
                        dict["liked"]  = resultData["liked"]
                        dict["liked_type"]  = resultData["liked_type"]
                        dict["created_at"] = resultData["created_at"]
                        
                        //sharedPost
                        dict["isShared"] = resultData["isShared"]
                        dict["post_created_at"] = resultData["post_created_at"]
                        dict["post_post_upload_type"] = resultData["post_post_upload_type"]
                        dict["profile_image"] = resultData["profile_image"]
                        
                        dict["post_username"] = resultData["post_username"]
                        dict["post_userimage"] = resultData["post_userimage"]
                        dict["post_postfile"] = resultData["post_postfile"]
                        dict["post_mood_track_time"] = resultData["post_mood_track_time"]
                        
                        dict["post_privacy_option"] = resultData["post_privacy_option"]
                        dict["post_description"] = resultData["post_description"]
                        dict["post_liked_type"] = resultData["post_liked_type"]
                        dict["post_liked"] = resultData["post_liked"]
                        dict["post_id"] = resultData["post_id"]
                        dict["comment_arr"] = resultData["comment_arr"]
                        
                        //MoodLogs
                        dict["is_file_exist"] = resultData["is_file_exist"]
                        dict["updated_at"] = resultData["updated_at"]
                        dict["moodTrack"] = resultData["moodTrack"]
                        dict["eventsActivity"] = resultData["eventsActivity"]
                        dict["careReceiverId"] = resultData["careReceiverId"]
                        dict["post_moodTrackResId"] = resultData["post_moodTrackResId"]
                        dict["mood_track_time"] = resultData["mood_track_time"]
                        dict["current_time"] = resultData["current_time"]
                        dict["isMoodLog"] = resultData["isMoodLog"]
                        dict["post_upload_file"]  = resultData["post_upload_file"]
                        
                        //Shared MoodLogs
                        
                        dict["share_mood_log_id"] = resultData["share_mood_log_id"]
                        dict["post_is_file_exist"] = resultData["post_is_file_exist"]
                        dict["updated_at"] = resultData["updated_at"]
                        dict["post_moodTrack"] = resultData["post_moodTrack"]
                        dict["post_eventsActivity"] = resultData["post_eventsActivity"]
                        dict["post_careReceiverId"] = resultData["post_careReceiverId"]
                        dict["moodTrackResId"] = resultData["moodTrackResId"]
                        dict["mood_track_time"] = resultData["mood_track_time"]
                        dict["current_time"] = resultData["current_time"]
                        dict["isMoodLog"] = resultData["isMoodLog"]
                        dict["post_upload_file"]  = resultData["post_upload_file"]
                        dict["post_current_time"]  = resultData["post_current_time"]
                        
                        let tokenInfo = Post(postDetail: dict)
                        //Save for Video Edit functionality
                        //SingletonPost.sharedInstance.storeData(postDetail: dict)
                        modelArray.append(tokenInfo)
                    }
                    postListingModelArray = modelArray
                    completion(true ,postListingModelArray,nil)
                }
            }
            else if response["status"] as? Int == 401
            {
                ServiceCall.sharedManager.LOGOUT_VIEW()
                //completion(false,[Post(postDetail: [:])], nil)
            }else{
                print(response["message"])
                completion(false,[Post(postDetail: [:])], nil)
            }
        }) { (error) in
            print(error)
            completion(false,[Post(postDetail: [:])],(error as? String ?? ""))
        }
    }
    
    static func deletePostService(postId:String,isShared:Int,isMoodLog:Int, completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        var postType:String = ""
        if (isMoodLog == 1)
        {
            postType = "/moodlog"
            
        } else{
            postType = "/post"
        }

        
        let url = UrlStrings.BASE_URL + UrlStrings.DeletePost.deletePost + postId + "/" + "\(isShared)" + postType
        print(url)
        ServiceCall.sharedManager.serviceApi(url, requestDict: nil, method: .delete, compBlock: { (response, dataResponse) in
            if response["status"] as? Int == 200
            {
                if let dataDict = response["data"] as? [String : AnyObject]
                {
                    print(dataDict)
                    completion(true ,nil)
                }
            }
            else
            {
                completion(false, nil)
            }
        }) { (error) in
            print(error)
            completion(false,(error as? String ?? ""))
        }
    }
    
    
    static func likePostService(params: [String: AnyObject], completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let url = UrlStrings.BASE_URL + UrlStrings.LikePost.likePost
        
        ServiceCall.sharedManager.serviceApi(url, requestDict: params, method: .post, compBlock: { (response, dataResponse) in
            if response["status"] as? Int == 200
            {
                if let dataDict = response["data"] as? [String : AnyObject]
                {
                    print(dataDict)
                    completion(true ,nil)
                }
            }
            else
            {
                completion(false, nil)
            }
        }) { (error) in
            print(error)
            completion(false,(error as? String ?? ""))
        }
    }
    
    static func sharePostService(params: [String: AnyObject], completion: @escaping (_ success: Bool, _ error: String?,_ msg:String) -> Void)
    {
        
       // let url = UrlStrings.BASE_URL + UrlStrings.SharePost.sharePost
        let url = "community/posts/sharePost"
        print(url)
        
//        ServiceCall.sharedManager.serviceApi(url, requestDict: params, method: .post, compBlock: { (response, dataResponse) in
//            if response["status"] as? Int == 200 {
//                if let dataDict = response["data"] as? [String : AnyObject] {
//                    print(dataDict)
//                    completion(true ,nil)
//                }
//            }else{
//                completion(false, nil)
//            }
//        }) { (error) in
//            print(error)
//            completion(false,(error as? String ?? ""))
//        }
        
        ServiceCall.sharedManager.PostApi(url:url , parameter: params, completionResponse: { (response) in
            
            let messg = response["message"] as? String ?? "Success"
            
            completion(true, nil, messg)
            
        }, completionnilResponse: { (message) in
            completion(false, nil, "")
        }, completionError: { (error) in
            completion(false, nil, "")
        }, networkError: { (error) in
            completion(false, nil,"")
            
        })
        
        
    }
    
    static func reportAbuseService(params: [String: AnyObject], completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let url = UrlStrings.PostAbuse.postAbuse
        
//        ServiceCall.sharedManager.serviceApi(url, requestDict: params, method: .post, compBlock: { (response, dataResponse) in
//            if response["status"] as? Int == 200 {
//                if let dataDict = response["data"] as? [String : AnyObject] {
//                    print(dataDict)
//                    completion(true ,nil)
//                }
//            }else{
//                completion(false, nil)
//            }
//        }) { (error) in
//            print(error)
//            completion(false,(error as? String ?? ""))
//        }
        ServiceCall.sharedManager.PostApi(url:url , parameter: params, completionResponse: { (response) in
            completion(true, nil)
        }, completionnilResponse: { (message) in
            completion(false, nil)
        }, completionError: { (error) in
            completion(false, nil)
        }, networkError: { (error) in
            completion(false, nil)
            
        })
        
        
        
        
    }
    
    
    
}

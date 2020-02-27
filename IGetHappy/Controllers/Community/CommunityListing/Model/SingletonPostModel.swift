//
//  SingletonPostModel.swift
//  IGetHappy
//
//  Created by Gagan on 8/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

import UIKit

class SingletonPostModel
{
    static let sharedInstance:SingletonPostModel? = SingletonPostModel()
    var isEditingMode: Bool?
    var userId : String?
    var userName : String?
    var userImageURL : String?
    var postImageURL : String?
    var postDescription : String?
    var isAnonymous : String?
    var privacyOption : String?
    var postId : String?
    var postType : String?
    var postfile : URL?
    var isLike : Int?
    var emojiType : String?
    
    //shared
    var isShared : Int?
    var post_post_upload_type : String?
    var shared_user_image : String?
    
    private init()
    {
    }
    deinit
    {
        print("Dealloc")
    }
    func Reinitilize()
    {
        SingletonPostModel.sharedInstance?.isEditingMode = false
        SingletonPostModel.sharedInstance?.userId = nil
        SingletonPostModel.sharedInstance?.userName = nil
        SingletonPostModel.sharedInstance?.userImageURL = nil
        SingletonPostModel.sharedInstance?.postImageURL = nil
        SingletonPostModel.sharedInstance?.postDescription = nil
        SingletonPostModel.sharedInstance?.isAnonymous = nil
        SingletonPostModel.sharedInstance?.privacyOption = nil
        SingletonPostModel.sharedInstance?.postId = nil
        SingletonPostModel.sharedInstance?.postType = nil
        SingletonPostModel.sharedInstance?.postfile = nil
        SingletonPostModel.sharedInstance?.isLike = nil
        SingletonPostModel.sharedInstance?.emojiType = nil
        SingletonPostModel.sharedInstance?.isShared = nil
        SingletonPostModel.sharedInstance?.post_post_upload_type = nil
        SingletonPostModel.sharedInstance?.shared_user_image = nil
        
    }
}

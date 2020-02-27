//
//  AddVideoPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/21/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol AddVideoDelegate : class {
    func AddVideoDidSucceeed(message:String?)
    func AddVideoDidFailed(message:String?)
}

class AddVideoPresenter{
    //Login Delegate
    var delegate:AddVideoDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var AddVideoDelegateView: AddVideoViewDelegate?
    
    init(delegate:AddVideoDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: AddVideoViewDelegate) {
        AddVideoDelegateView = view
    }
    //Detaching login view
    func detachView() {
        AddVideoDelegateView = nil
    }
    
    
    func AddVideoPost(postText:String?,privacy:String?,isAnonymous:String?,MediaUrl:NSURL?){
        
        var reruestParameters = [String:AnyObject]()
        
        let userId = UserDefaults.standard.getUserId() ?? ""
        reruestParameters["user_id"] = userId as AnyObject
        reruestParameters["description"] = postText as AnyObject
        reruestParameters["privacy_option"] = privacy as AnyObject
        reruestParameters["is_anonymous"] = isAnonymous as AnyObject
        reruestParameters["post_upload_type"] = "Video" as AnyObject
        
        
        //self.AddVideoDelegateView?.showLoader()
        
        FeedServices.sharedInstance.AddVideoPostService(urlMedia: MediaUrl! as URL, url: UrlStrings.UploadPost.AllTypePost, postDict: reruestParameters, completionResponse: { (message) in
            
            self.delegate.AddVideoDidSucceeed(message: message)
        }, completionnilResponse: { (message) in
            self.delegate.AddVideoDidFailed(message: message)
        }, completionError: { (error) in
             self.delegate.AddVideoDidFailed(message: error?.localizedDescription)
        }) { (networkerror) in
            self.delegate.AddVideoDidFailed(message: Constants.Global.MessagesStrings.ServerError)
        }
    }
    
    func editVideoPost(postText:String?,privacy:String?,isAnonymous:String?,MediaUrl:NSURL?, withPostID:String){
        
        let userId = UserDefaults.standard.getUserId() ?? ""
        
        parm["user_id"] = userId
        parm["description"] = postText
        parm["privacy_option"] = privacy
        parm["is_anonymous"] = isAnonymous
        parm["post_upload_type"] = "Video"
        
        FeedServices.sharedInstance.editVideoPatchService(url: UrlStrings.EditPost.textTypePost + withPostID, fileUrl: MediaUrl! as URL, postDict: parm as [String : AnyObject], completionResponse: { (message) in
            
            self.delegate.AddVideoDidSucceeed(message: message)
        }, completionnilResponse: { (message) in
            self.delegate.AddVideoDidFailed(message: message)
        }, completionError: { (error) in
            self.delegate.AddVideoDidFailed(message: error?.localizedDescription)
        }) { (networkerror) in
            self.delegate.AddVideoDidFailed(message: Constants.Global.MessagesStrings.ServerError)
        }
    }
    
    
    func Validations(postText:String?,privacy:String?,isAnonymous:String?) throws{
//        guard let PostText = postText,  !PostText.isEmpty, !PostText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.AddPost.emptyText
//        }
        if(!((postText?.postMaxLength)!)){
            throw ValidationError.AddPost.textMaxLength
        }
        
        guard let Privacy = privacy,  !Privacy.isEmpty, !Privacy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddPost.emptyPrivacy
        }
        
        guard let IsAnonymous = isAnonymous,  !IsAnonymous.isEmpty, !IsAnonymous.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddPost.emptyisAnonymous
        }
        
        
        
    }
}

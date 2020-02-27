//
//  WriteThoughtsPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/17/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol WriteThoughtsDelegate : class {
    func WriteThoughtsDidSucceeed(message:String?)
    func WriteThoughtsDidFailed(message:String?)
}

class WriteThoughtsPresenter{
    //Login Delegate
    var delegate:WriteThoughtsDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var WriteThoughtsDelegateView: WriteThoughtsViewDelegate?
    
    init(delegate:WriteThoughtsDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: WriteThoughtsViewDelegate) {
        WriteThoughtsDelegateView = view
    }
    //Detaching login view
    func detachView() {
        WriteThoughtsDelegateView = nil
    }
    
    
    func AddTextPost(postText:String?,privacy:String?,isAnonymous:String?){
        
        if let userId = UserDefaults.standard.getUserId()
        {
            parm["user_id"] = userId
        }
        
        parm["description"] = postText
        parm["privacy_option"] = privacy
        parm["is_anonymous"] = isAnonymous
        parm["post_upload_type"] = "Text"
        //parm["post_upload_file"] = ""
        
        self.WriteThoughtsDelegateView?.showLoader()
        FeedServices.sharedInstance.AddTextPostService(url: UrlStrings.UploadPost.AllTypePost, postDict: parm, completionResponse: { (message) in
            
            self.WriteThoughtsDelegateView?.hideLoader()
            self.delegate.WriteThoughtsDidSucceeed(message: message)
        }, completionnilResponse: { (message) in
            self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
             self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
             self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
        
    }
    
    func editTextPost(postText:String?,privacy:String?,isAnonymous:String?, postID:String){
        
        if let userId = UserDefaults.standard.getUserId(){
            parm["user_id"] = userId
        }
        
        parm["description"] = postText
        parm["privacy_option"] = privacy
        parm["is_anonymous"] = isAnonymous
        parm["post_upload_type"] = "Text"
        
        FeedServices.sharedInstance.editTextPatchService(url: UrlStrings.BASE_URL + UrlStrings.EditPost.textTypePost + postID, postDict: parm as [String : AnyObject], completionResponse: { (message) in
            self.WriteThoughtsDelegateView?.hideLoader()
            self.delegate.WriteThoughtsDidSucceeed(message: message)
        }, completionnilResponse: { (message) in
            self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: "\(String(describing: error))")
        }) { (networkerror) in
            self.WriteThoughtsDelegateView?.hideLoader()
            self.WriteThoughtsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
    }
    
    
    func Validations(postText:String?,privacy:String?,isAnonymous:String?) throws{
        
        
        
//        guard let PostText = postText,  !PostText.isEmpty, !PostText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.AddPost.emptyText
//        }
        if !(postText?.postMaxLength)! {
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

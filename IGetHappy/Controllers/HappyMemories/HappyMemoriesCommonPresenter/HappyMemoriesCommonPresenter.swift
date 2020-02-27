//
//  HappyMemoriesCommonPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/21/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol HappyMemoriesCommonDelegate : class
{
    func HappyMemoriesCommonDidSucceeed(message:String)
    func HappyMemoriesCommonDidFailed(message:String)
}
class HappyMemoriesCommonPresenter
{
    //Register Delegate
    var delegate:HappyMemoriesCommonDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var HappyMemoriesCommonDelegateView: HappyMemoriesCommonViewDelegate?
    
    init(delegate:HappyMemoriesCommonDelegate)
    {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: HappyMemoriesCommonViewDelegate)
    {
        HappyMemoriesCommonDelegateView = view
    }
    //Detaching login view
    func detachView()
    {
        HappyMemoriesCommonDelegateView = nil
    }
    
    func uploadHappyMemoriesData(mediaType:DataType,mediaData:[String],imageData:[UIImage],location:String?,description:String?){
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        parm["user_id"] = userID
        parm["description"] = description
        parm["location"] = location
        parm["created_at"] = ""
        parm["post_upload_file"] = ""
        
        
        
        if (mediaType == .Image)
        {
           parm["post_upload_type"] = "IMAGE"
        }
        if (mediaType == .Audio)
        {
            parm["post_upload_type"] = "AUDIO"
        }
        if (mediaType == .Video)
        {
            parm["post_upload_type"] = "VIDEO"
        }
        
        
        ServiceCall.sharedManager.MultipartMultipleFilesServiceApi(type: mediaType , fileData: mediaData, imageDataArr: imageData, requestDict: parm, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                self.HappyMemoriesCommonDelegateView?.hideLoader()
                self.delegate.HappyMemoriesCommonDidSucceeed(message: message)
                
                if (message.contains("success"))
                {
                    CommonVc.AllFunctions.clear_database_for_uploaded_files_happy_memories()
                }
            }
            else
            {
                 self.HappyMemoriesCommonDelegateView?.hideLoader()
                self.delegate.HappyMemoriesCommonDidFailed(message: "Something went wrong please try after sometime!")
            }
            //let message = responseDict["message"] as! String
            
            //completionResponse(response.error)
        }) { (networkError) in
             self.HappyMemoriesCommonDelegateView?.hideLoader()
            self.delegate.HappyMemoriesCommonDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(networkError)
        }
        
    }
    
    
    
    //facing problem in uploding videos on happy memories on ios 13 thats why i have created this function
    func uploadHappyMemoriesData_with_url_array(mediaType:DataType,mediaData:[URL],imageData:[UIImage],location:String?,description:String?){
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        parm["user_id"] = userID
        parm["description"] = description
        parm["location"] = location
        parm["created_at"] = ""
        parm["post_upload_file"] = ""
        
        
        
        if (mediaType == .Image)
        {
            parm["post_upload_type"] = "IMAGE"
        }
        if (mediaType == .Audio)
        {
            parm["post_upload_type"] = "AUDIO"
        }
        if (mediaType == .Video)
        {
            parm["post_upload_type"] = "VIDEO"
        }
        
        
        ServiceCall.sharedManager.MultipartMultipleFilesServiceApi_with_url_array(type: mediaType , fileData: mediaData, imageDataArr: imageData, requestDict: parm, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                self.HappyMemoriesCommonDelegateView?.hideLoader()
                self.delegate.HappyMemoriesCommonDidSucceeed(message: message)
                
                if (message.contains("success"))
                {
                    CommonVc.AllFunctions.clear_database_for_uploaded_files_happy_memories()
                }
            }
            else
            {
                self.HappyMemoriesCommonDelegateView?.hideLoader()
                self.delegate.HappyMemoriesCommonDidFailed(message: "Something went wrong please try after sometime!")
            }
            //let message = responseDict["message"] as! String
            
            //completionResponse(response.error)
        }) { (networkError) in
            self.HappyMemoriesCommonDelegateView?.hideLoader()
            self.delegate.HappyMemoriesCommonDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(networkError)
        }
        
    }
    
   
}

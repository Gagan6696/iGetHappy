//
//  JournelYourThoughtsPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol JournelYourThoughtsDelegate : class {
    func JournelYourThoughtsDidSucceeed(data:String?)
    func JournelYourThoughtsDidFailed(message:String?)
}


class JournelYourThoughtsPresenter
{
    //ChooseCareRecieverPresenter Delegate
    var delegate:JournelYourThoughtsDelegate
    var parm = [String:Any]()
    static var ref_Journal:JournelThoughtsVC?
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var JournelYourThoughtsDelegateView: JournelYourThoughtsViewDelegate?
    
    init(delegate:JournelYourThoughtsDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: JournelYourThoughtsViewDelegate) {
        JournelYourThoughtsDelegateView = view
    }
    //Detaching login view
    func detachView()
    {
        JournelYourThoughtsDelegateView = nil
    }
    func callApiWithType(type:String?)
    {
        
    }
    
    func GetAllListCareReciever()
    {
        
        //Remove this and add to global class //Reminder
      //  let user = UserDefaults.standard.getUserId() ?? ""
        let evntID = EditMoodActivityData.sharedInstance?.evnt_id ?? "0"
        let url = "eventPost/updateLogs/\(evntID)"
        
        if(EditMoodActivityData.sharedInstance?.user_id?.count ?? 0 > 0)
        {
           parm["user_id"] = EditMoodActivityData.sharedInstance?.user_id
        }
        
        if(EditMoodActivityData.sharedInstance?.moodTrack?.count ?? 0 > 0)
        {
            parm["moodTrack"] = EditMoodActivityData.sharedInstance?.moodTrack
        }
        
        if(EditMoodActivityData.sharedInstance?.eventsActivity?.count ?? 0 > 0)
        {
            parm["eventsActivity"] = EditMoodActivityData.sharedInstance?.eventsActivity
        }
        
        if(EditMoodActivityData.sharedInstance?.careReceiverId?.count ?? 0 > 0)
        {
            parm["careReceiverId"] = EditMoodActivityData.sharedInstance?.careReceiverId
        }
        
        if(EditMoodActivityData.sharedInstance?.privacy_option?.count ?? 0 > 0)
        {
            parm["privacy_option"] = EditMoodActivityData.sharedInstance?.privacy_option
        }
        
        
        if(EditMoodActivityData.sharedInstance?.description?.count ?? 0 > 0)
        {
            parm["description"] = EditMoodActivityData.sharedInstance?.description
        }
        
    if(EditMoodActivityData.sharedInstance?.post_upload_file?.absoluteString.count ?? 0 > 0)
        {
            parm["post_upload_file"] = EditMoodActivityData.sharedInstance?.post_upload_file
    }else{
        parm["post_upload_file"] = ""
        }
        
        if(EditMoodActivityData.sharedInstance?.post_upload_type?.count ?? 0 > 0)
        {
            parm["post_upload_type"] = EditMoodActivityData.sharedInstance?.post_upload_type?.uppercased()
        }
        
        if(EditMoodActivityData.sharedInstance?.icon_name?.count ?? 0 > 0)
        {
            parm["moodTrackResId"] = EditMoodActivityData.sharedInstance?.icon_name
        }
        
      //  parm["mood_track_time"] = ""
        

        if (JournelYourThoughtsPresenter.ref_Journal?.Edit_Data_Journal?.count ?? 0 > 0)//MEANS I AM EDITING OLD EVENT
        {
            parm["is_file_exist"] = EditMoodActivityData.sharedInstance?.change_file_status
            self.UPDATE_OLD_EVENT_WITH_NEW_MODIFICATIONS(prmtrs: parm)
        }
        else
        {
            if (CommonVc.AllFunctions.have_internet() == true)
            {
                 //MARK: CONTINUE SELECTED EMOJY (WHEN USER TAB ON EMOJY FROM HOME VC)
                self.JournelYourThoughtsDelegateView?.showLoader()
                if(EditMoodActivityData.sharedInstance?.post_upload_type == "AUDIO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: parm, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String
                        {
                            print(message)
                            self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                        }
                        //let message = responseDict["message"] as! String
                        
                        //completionResponse(response.error)
                    }) { (networkError) in
                        self.JournelYourThoughtsDelegateView?.hideLoader()
                        self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
                else if(EditMoodActivityData.sharedInstance?.post_upload_type == "VIDEO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: parm, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String
                        {
                            print(message)
                            self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                        }
                        //let message = responseDict["message"] as! String
                        
                        //completionResponse(response.error)
                    }) { (networkError) in
                         self.JournelYourThoughtsDelegateView?.hideLoader()
                        self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        //            print(error)
                        print(networkError)
                    }
                }
                else
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: parm, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String{
                            print(message)
                            self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                        }
                        //let message = responseDict["message"] as! String
                        
                        //completionResponse(response.error)
                    }) { (networkError) in
                          self.JournelYourThoughtsDelegateView?.hideLoader()
                        self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        //            print(error)
                        print(networkError)
                    }
                    
                    
                }
            }
            else
            {
                //SAVING MOOD LOG EVENT IN DATABASE------------------------------->>>>>>>>>>>>
                self.ADD_EVENT_IN_DATABASE()
            }
        }
        
        
        self.make_sources_nil()

    }
    
    
  
    
    func UPDATE_OLD_EVENT_WITH_NEW_MODIFICATIONS(prmtrs:[String:Any])
    {
        
        
           // let user = UserDefaults.standard.getUserId() ?? ""
            let evnt_ID = EditMoodActivityData.sharedInstance?.evnt_id ?? ""
            let url = "eventPost/updateLogs/\(evnt_ID)"
            
            if (JournelYourThoughtsPresenter.ref_Journal?.editEvent_has_attached_new_file == "1")
            {
                
                if (CommonVc.AllFunctions.have_internet() == true)
                {
                    self.JournelYourThoughtsDelegateView?.showLoader()
                    if(EditMoodActivityData.sharedInstance?.post_upload_type == "AUDIO")
                    {
                        ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: prmtrs, method: .patch, compBlock: { (responseDict, response) in
                            if let message  = responseDict["message"] as? String
                            {
                                print(message)
                                self.JournelYourThoughtsDelegateView?.hideLoader()
                                self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                            }
                            //let message = responseDict["message"] as! String
                            
                            //completionResponse(response.error)
                        }) { (networkError) in
                              self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                            print(networkError)
                        }
                    }
                    else if(EditMoodActivityData.sharedInstance?.post_upload_type == "VIDEO")
                    {
                        print("Gagan",prmtrs)
                      //  prmtrs.removeValue(forKey: "bar")
                        ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: prmtrs, method: .patch, compBlock: { (responseDict, response) in
                            if let message  = responseDict["message"] as? String{
                                print(message)
                                self.JournelYourThoughtsDelegateView?.hideLoader()
                                self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                            }
                            //let message = responseDict["message"] as! String
                            
                            //completionResponse(response.error)
                        }) { (networkError) in
                            self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                            //            print(error)
                            print(networkError)
                        }
                    }
                    else
                    {
                        ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: prmtrs, method: .patch, compBlock: { (responseDict, response) in
                            if let message  = responseDict["message"] as? String{
                                print(message)
                                self.JournelYourThoughtsDelegateView?.hideLoader()
                                self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                            }
                            //let message = responseDict["message"] as! String
                            
                            //completionResponse(response.error)
                        }) { (networkError) in
                             self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                            //            print(error)
                            print(networkError)
                        }
                        
                        
                    }
                }
                else
                {
                    self.ADD_EVENT_IN_DATABASE()
                }
            }
            else
            {
                
                if (CommonVc.AllFunctions.have_internet() == true)
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: EditMoodActivityData.sharedInstance?.post_upload_file, urlString: url, fileData: nil, requestDict: prmtrs, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String
                        {
                            print(message)
                            self.JournelYourThoughtsDelegateView?.hideLoader()
                            self.delegate.JournelYourThoughtsDidSucceeed(data: message)
                        }
                        //let message = responseDict["message"] as! String
                        
                        //completionResponse(response.error)
                    }) { (networkError) in
                         self.JournelYourThoughtsDelegateView?.hideLoader()
                        self.delegate.JournelYourThoughtsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        //            print(error)
                        print(networkError)
                    }
                }
                else
                {
                    self.ADD_EVENT_IN_DATABASE()
                }
                
            }
        
            
    }
    
    
    func ADD_EVENT_IN_DATABASE()
    {
        
        let file = EditMoodActivityData.sharedInstance?.post_upload_file?.absoluteString
        
        if (file?.count ?? 0 > 0)
        {
            self.ADD_FILE_IN_DOCUMNET_DIRECTORY(fileURL: URL(string:file!)!, type: (EditMoodActivityData.sharedInstance?.post_upload_type)!)
            { (fileName) in
                
                if (fileName == "error")
                {
                   print("file not saved in document directory")
                }
                else
                {
                    self.ADD_MOOD_LOG_IN_DB(fileNAME:fileName)
                }
            }
        }
        else
        {
            self.ADD_MOOD_LOG_IN_DB(fileNAME:"")
        }
        
    }
    
    
    func ADD_MOOD_LOG_IN_DB(fileNAME:String)
    {
        let dic = NSMutableDictionary()
        let tableID = "0"
        let location = UserDefaults.standard.getLocation()
        let cdate = CommonVc.AllFunctions.getCurrentDate_InString()
        
        print(EditMoodActivityData.sharedInstance?.icon_name as Any)
        dic.setValue(EditMoodActivityData.sharedInstance?.evnt_id, forKey: coreDataKeys_MoodLog_Events.event_id)
        dic.setValue(EditMoodActivityData.sharedInstance?.change_file_status, forKey: coreDataKeys_MoodLog_Events.change_file_status)
        //   dic.setValue(EditMoodActivityData.sharedInstance?.icon_name, forKey: coreDataKeys_MoodLog_Events.icon_name)
        dic.setValue(ExtensionModel.shared.Emoji_CurrentPage, forKey: coreDataKeys_MoodLog_Events.mood_index)
        dic.setValue(EditMoodActivityData.sharedInstance?.user_id, forKey: coreDataKeys_MoodLog_Events.user_id)
        dic.setValue(tableID, forKey: coreDataKeys_MoodLog_Events.table_id)
        dic.setValue(EditMoodActivityData.sharedInstance?.privacy_option, forKey: coreDataKeys_MoodLog_Events.privacy)
        dic.setValue(EditMoodActivityData.sharedInstance?.description, forKey: coreDataKeys_MoodLog_Events.desc)
        dic.setValue(location, forKey: coreDataKeys_MoodLog_Events.location)
        dic.setValue(cdate, forKey: coreDataKeys_MoodLog_Events.date)
        dic.setValue(EditMoodActivityData.sharedInstance?.icon_name, forKey: coreDataKeys_MoodLog_Events.image_name)
        dic.setValue(EditMoodActivityData.sharedInstance?.moodTrack, forKey: coreDataKeys_MoodLog_Events.mood_name)
        dic.setValue("0", forKey: coreDataKeys_MoodLog_Events.is_posted)
        dic.setValue(EditMoodActivityData.sharedInstance?.careReceiverId, forKey: coreDataKeys_MoodLog_Events.care_rcvr_id)
        dic.setValue("", forKey: coreDataKeys_MoodLog_Events.video_path)
        dic.setValue("", forKey: coreDataKeys_MoodLog_Events.audio_path)
        dic.setValue(EditMoodActivityData.sharedInstance?.post_upload_type, forKey: coreDataKeys_MoodLog_Events.upload_type)
        dic.setValue(fileNAME, forKey: coreDataKeys_MoodLog_Events.file_name_audio)
        dic.setValue(fileNAME, forKey: coreDataKeys_MoodLog_Events.file_name_video)
        dic.setValue(EditMoodActivityData.sharedInstance?.eventsActivity, forKey: coreDataKeys_MoodLog_Events.events_activity)
        
        
        CoreData_Model.UPDATE_MOOD_LOG_EVENTS_offline_in_coreData(data_for_save: dic, success: { (result) in
            
            print(result)
            
            self.delegate.JournelYourThoughtsDidSucceeed(data: "Internet is not available. Your event is saved offline!")
            self.DELETE_OFFLINE_STORED_MOOD_EMOJY()
            //BCS there shud be one post on server, eighter only emojy or event. So if you have create Mood Log event then Offline emojy shud be deleted.
        })
        { (err) in
            print(err)
            
            self.delegate.JournelYourThoughtsDidFailed(message: "Sorry! Something went wrong while saving event offline")
        }
    }
    
    
    func ADD_FILE_IN_DOCUMNET_DIRECTORY(fileURL:URL,type:String,success: @escaping (String) -> Void)
    {
        
        if (fileURL.absoluteString.count == 0)
        {
            success("")
        }
        else
        {
            let fileName_random = CommonVc.AllFunctions.generateRandomString()
            var fileName = ""
            if (type == "AUDIO")
            {
                fileName = "\(fileName_random).wav"
            }
            else if (type == "VIDEO")
            {
                fileName = "\(fileName_random).mp4"
            }
            
            
            let videoData = NSData(contentsOf: fileURL)
            let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
            let newPath = path.appendingPathComponent(fileName)
            do
            {
                try videoData?.write(to: newPath)
                print(newPath)
                success(fileName)
            }
            catch
            {
                print(error)
                success("error")
            }
        }
        
        
    }
   
    
    func DELETE_OFFLINE_STORED_MOOD_EMOJY()
    {
        CoreData_Model.delete_emoji_offline_in_coreData(success: { (rslt) in
            print(rslt)
        })
        { (err) in
            print(err)
        }
    }
    
    
    func make_sources_nil()
    {
        EditMoodActivityData.sharedInstance?.icon_name = ""
        EditMoodActivityData.sharedInstance?.evnt_id = ""
        EditMoodActivityData.sharedInstance?.change_file_status = ""
        EditMoodActivityData.sharedInstance?.user_id = ""
        EditMoodActivityData.sharedInstance?.privacy_option = ""
        EditMoodActivityData.sharedInstance?.description = ""
        EditMoodActivityData.sharedInstance?.icon_name = ""
        EditMoodActivityData.sharedInstance?.moodTrack = ""
        EditMoodActivityData.sharedInstance?.careReceiverId = ""
        EditMoodActivityData.sharedInstance?.post_upload_type = ""
        EditMoodActivityData.sharedInstance?.eventsActivity = ""
       
    }
    
}


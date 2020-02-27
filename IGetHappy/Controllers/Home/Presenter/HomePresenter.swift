//
//  HomePresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol HomeDelegate : class
{
    func HomeDidSucceeed(message:String?)
    func HomeDidFailed(message:String?)
    func AIDidSucceeed(message:String?)
 
}

class HomePresenter
{
    //Login Delegate
    var delegate:HomeDelegate
    var parm = [String:Any]()
    var updating_database = false
    var parms = [String:Any]()
    var eventID = ""
    
    // Login Controllers weak object to save from being retain cycle
    weak var HomeDelegateView: HomeViewDelegate?
    
    init(delegate:HomeDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: HomeViewDelegate) {
        HomeDelegateView = view
    }
    //Detaching login view
    func detachView() {
        HomeDelegateView = nil
    }
    
    //get mood from server when user come in home and set cuurent mood in mood slider
    func getMoodFromServer()
    {
        self.HomeDelegateView?.showLoader()
        
        if let userId = UserDefaults.standard.getUserId(){
            let urlfinal = UrlStrings.Home.moodTracking + "/" + userId
            
            ServiceCall.sharedManager.GetApi(url: urlfinal, completionResponse: { response
                in
                self.HomeDelegateView?.hideLoader()
                //Reminder
                // let dict = response["data"] as! NSArray
                //let dict2  = dict[0] as! NSDictionary
                // let mood_type = dict2.value(forKey: "mood_type")
                // print("mood_type",response["mood_type"])
                // print(response)
                self.delegate.HomeDidSucceeed(message: "Happy")
            }, completionnilResponse: { (message) in
                print(message)
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: message)
            }, completionError: { (error) in
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            }) { (error) in
                print(error)
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            }
        }else{
            self.HomeDelegateView?.hideLoader()
            self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        
    }
    
    //set mood to server when user tap on smiley
    func setMoodFromServer(moodType:String?,dateTime:String?,iconName:String)
    {
        let sendDateForSort = Singleton.shared().currentDate_for_offline_emojy_sorting
         //let sendDateForSort = self.dateFromISOStringToSort(string: dateTime ?? "") ?? ""
        
        self.CREATE_ONLY_EMOJI_MOOD_EVENT(moodName: moodType ?? "",icName:iconName,dateTime: dateTime ?? "\(Date())",sendTimeForSort:sendDateForSort)
    }
    
   
    
    func getFaceEmotion(image:UIImage?)
    {
        
        self.HomeDelegateView?.showLoader()
        
        HomeService.sharedInstance.GetEmaotionService(image:image, url: UrlStrings.GetEmotion.getEmotion,completionResponse: { (message) in
            
            self.HomeDelegateView?.hideLoader()
            self.TRACK_MOOD_USING_AI(mood: message)
            self.delegate.AIDidSucceeed(message: "Mood tracked successfully!")
        }, completionnilResponse: { (message) in
            self.HomeDelegateView?.hideLoader()
            self.HomeDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error as Any)
            self.HomeDelegateView?.hideLoader()
            self.HomeDelegateView?.showAlert(alertMessage: "\(String(describing: error))")
        }) { (networkerror) in
            self.HomeDelegateView?.hideLoader()
            self.HomeDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
        
    }
    
    var moodID = "0"
    func get_emoji_offline()
    {
        CoreData_Model.get_offline_saved_emoji(success: { (data) in
            print(data)
            
            let status = data.value(forKey: coreDataKeys_SavedEmoji.is_posted) as? String ?? ""
            let mood = data.value(forKey: coreDataKeys_SavedEmoji.mood_name) as? String ?? ""
            let time = data.value(forKey: coreDataKeys_SavedEmoji.date) as? String ?? ""
            let ic_name = data.value(forKey: coreDataKeys_SavedEmoji.image_name) as? String ?? ""
            self.moodID = data.value(forKey: coreDataKeys_SavedEmoji.mood_id) as? String ?? ""
            let cTime = data.value(forKey: coreDataKeys_SavedEmoji.current_time) as? String ?? ""
            Singleton.shared().currentDate_for_offline_emojy_sorting = cTime
            if (status == "0")
            {
                self.CHECK_MOOD_LOG_HAVE_DATA(success: { (sccs) in
                    if (sccs == "1" && self.eventID.count > 0)
                    {
                        self.get_MOOD_LOG_EVENT(approach: "edit")
                    }
                    if (sccs == "1" && self.eventID.count == 0)
                    {
                        self.get_MOOD_LOG_EVENT(approach: "create")
                    }
                    else
                    {
                        self.updating_database = true
                        self.setMoodFromServer(moodType: mood, dateTime: time,iconName: ic_name)
                    }
                })
            }
            else if (status == "1")//now we have mood id
            {
                self.CHECK_MOOD_LOG_HAVE_DATA(success: { (sccs) in
                    if (sccs == "1")
                    {
                        self.get_MOOD_LOG_EVENT(approach: "edit")//Edit event bcs we have already mood id
                    }
                    else
                    {
                        // self.updating_database = true
                        // self.setMoodFromServer(moodType: mood, dateTime: time)
                    }
                })
            }
            else
            {
                self.get_MOOD_LOG_EVENT(approach: "create")//create new event bcs we dont have mood id
            }
            
        })
        { (error) in
            print(error)
            self.get_MOOD_LOG_EVENT(approach: "create")//create new event bcs we dont have mood id
        }
    }
    
    
    func update_emoji_offline(imageName:String,feel:String,indx:Int,iconName:String)
    {
        
        let dic = NSMutableDictionary()
       // let currentDate = CommonVc.AllFunctions.getCurrentDate_InString()
        let user = UserDefaults.standard.getUserId()
        
        
        
        dic.setValue(iconName, forKey: coreDataKeys_SavedEmoji.icon_name)
        dic.setValue(imageName, forKey: coreDataKeys_SavedEmoji.image_name)
        dic.setValue(Singleton.shared().currentDate_for_offline_emojy, forKey: coreDataKeys_SavedEmoji.date)
        dic.setValue(indx, forKey: coreDataKeys_SavedEmoji.index)
        dic.setValue(feel, forKey: coreDataKeys_SavedEmoji.mood_name)
        dic.setValue("0", forKey: coreDataKeys_SavedEmoji.is_posted)
        dic.setValue(user, forKey: coreDataKeys_SavedEmoji.user_id)
        
        dic.setValue(Singleton.shared().currentDate_for_offline_emojy_sorting, forKey: coreDataKeys_SavedEmoji.current_time)
        
        
       // Singleton.shared().currentDate_for_offline_emojy = dateToSend
     //   Singleton.shared().currentDate_for_offline_emojy_sorting = setDateForSort
    
        
        
        
        let dic2 : NSDictionary = dic
        
        CoreData_Model.update_emoji_offline_in_coreData(data_for_save: dic2, success:
            { (result) in
                
                // print(result)
                
        }) { (error) in
            
            // print(error)
        }
    }
    
    
    func get_MOOD_LOG_EVENT(approach:String)
    {
        CoreData_Model.get_offline_MOOD_LOG_EVENTS(success: { (data) in
            print(data)
            
            if (data.count > 0)
            {
                
                if (approach == "create")
                {
                    self.POST_OFFLINE_SAVED_EVENT_TO_SERVER(dic:data)
                }
                else
                {
                    self.UPDATE_OFFLINE_SAVED_EVENT_TO_SERVER(dic: data)
                }
                
                
            }
        })
        { (error) in
            print(error)
        }
    }
    
    
    func CHECK_MOOD_LOG_HAVE_DATA(success: @escaping (String) -> Void)
    {
        CoreData_Model.get_offline_MOOD_LOG_EVENTS(success: { (data) in
            print(data)
            
            if (data.count > 0)
            {
                self.eventID = data.value(forKey: coreDataKeys_MoodLog_Events.event_id) as? String ?? ""
                success("1")
            }
            else
            {
                self.eventID = ""
                success("0")
            }
        })
        { (error) in
            print(error)
            success("0")
            self.eventID = ""
        }
    }
    
    //MARK: <-------------- CREATE NEW POST FOR MOOD EVENTS --------------->
    func POST_OFFLINE_SAVED_EVENT_TO_SERVER(dic:NSDictionary)
    {
        
        //Remove this and add to global class //Reminder
       // let user = UserDefaults.standard.getUserId() ?? ""
        let url = "eventPost"
        
        let type = dic.value(forKey: coreDataKeys_MoodLog_Events.upload_type)as? String ?? ""
        let uploadFile = dic.value(forKey: coreDataKeys_MoodLog_Events.file_name_audio)as? String ?? ""
        
        
            let filePATH = self.GET_FILE_PATH(fileName: uploadFile)
        
            parms["user_id"] = dic.value(forKey: coreDataKeys_MoodLog_Events.user_id)
            parms["moodTrack"] = dic.value(forKey: coreDataKeys_MoodLog_Events.mood_name)
            parms["eventsActivity"] = dic.value(forKey: coreDataKeys_MoodLog_Events.events_activity)
        let careRcvrId = "\(dic.value(forKey: coreDataKeys_MoodLog_Events.care_rcvr_id) ?? "")"
        if (careRcvrId != ""){
            parms["careReceiverId"] = dic.value(forKey: coreDataKeys_MoodLog_Events.care_rcvr_id)
        }
            parms["privacy_option"] = dic.value(forKey: coreDataKeys_MoodLog_Events.privacy)
            parms["description"] = dic.value(forKey: coreDataKeys_MoodLog_Events.desc)
            parms["post_upload_type"] = type
            parms["moodTrackResId"] = dic.value(forKey: coreDataKeys_MoodLog_Events.image_name)
            //  parms["post_upload_file"] = uploadFile
        
        if (filePATH.count > 0)
        {
            let fileURl = URL(string: filePATH)
            if (CommonVc.AllFunctions.have_internet() == true)
            {
                self.HomeDelegateView?.showLoader()
                
                if(type == "AUDIO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .post, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String
                        {
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                         self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
                else if(type == "VIDEO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .post, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String{
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                        self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
                else
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .post, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String{
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                        self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
            }
        }
        else
        {
            ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: nil, urlString: url, fileData: nil, requestDict: parms, method: .post, compBlock: { (responseDict, response) in
                if let message  = responseDict["message"] as? String{
                    print(message)
                    self.HomeDelegateView?.hideLoader()
                    self.delegate.HomeDidSucceeed(message: message)
                    self.DELETE_MOOD_LOG_FROM_COREDATA()
                }
                
            }) { (networkError) in
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                print(networkError)
            }
        }
        
    }
    
    
    
    //MARK: <-------------- UPDATE EXISTING POST FOR MOOD EVENTS --------------->
    func UPDATE_OFFLINE_SAVED_EVENT_TO_SERVER(dic:NSDictionary)
    {
        
        //Remove this and add to global class //Reminder
      //  let user = UserDefaults.standard.getUserId() ?? ""
        let evnt_id = dic.value(forKey: coreDataKeys_MoodLog_Events.event_id)as? String ?? ""
        
        let url = "eventPost/updateLogs/\(evnt_id)"
        
        let type = dic.value(forKey: coreDataKeys_MoodLog_Events.upload_type)as? String ?? ""
        let uploadFile = dic.value(forKey: coreDataKeys_MoodLog_Events.file_name_audio)as? String ?? ""
        let fileStatus = dic.value(forKey: coreDataKeys_MoodLog_Events.change_file_status)as? String ?? "NO"
        
//        if(evnt_id.count > 0)
//        {
//            url = "eventPost/updateLogs/\(evnt_id)"
//        }
        
        
          let filePATH = self.GET_FILE_PATH(fileName: uploadFile)
        
        
            
            parms["user_id"] = dic.value(forKey: coreDataKeys_MoodLog_Events.user_id)
            parms["moodTrack"] = dic.value(forKey: coreDataKeys_MoodLog_Events.mood_name)
            parms["eventsActivity"] = dic.value(forKey: coreDataKeys_MoodLog_Events.events_activity)
        if (dic.value(forKey: coreDataKeys_MoodLog_Events.care_rcvr_id) != nil){
            parms["careReceiverId"] = dic.value(forKey: coreDataKeys_MoodLog_Events.care_rcvr_id)
        }
            parms["privacy_option"] = dic.value(forKey: coreDataKeys_MoodLog_Events.privacy)
            parms["description"] = dic.value(forKey: coreDataKeys_MoodLog_Events.desc)
            parms["post_upload_type"] = type
          //  parms["moodTrackResId"] = self.moodID
            parms["moodTrackResId"] = dic.value(forKey: coreDataKeys_MoodLog_Events.image_name)
            parms["mood_track_time"] = ""
            parms["change_file_status"] = fileStatus
            
            
            //  parms["post_upload_file"] = uploadFile
        
        if (filePATH.count > 0)
        {
            let fileURl = URL(string: filePATH)
            
            if (CommonVc.AllFunctions.have_internet() == true)
            {
                self.HomeDelegateView?.showLoader()
                
                if(type == "AUDIO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Audio, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String
                        {
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                         self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
                else if(type == "VIDEO")
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .Video, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String{
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                        self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                }
                else
                {
                    ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: fileURl, urlString: url, fileData: nil, requestDict: parms, method: .patch, compBlock: { (responseDict, response) in
                        if let message  = responseDict["message"] as? String{
                            print(message)
                            self.HomeDelegateView?.hideLoader()
                            self.delegate.HomeDidSucceeed(message: message)
                            self.DELETE_MOOD_LOG_FROM_COREDATA()
                        }
                        
                    }) { (networkError) in
                        self.HomeDelegateView?.hideLoader()
                        self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                        print(networkError)
                    }
                    
                }
            }
            
        }
        else
        {
            ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: nil, urlString: url, fileData: nil, requestDict: parms, method: .patch, compBlock: { (responseDict, response) in
                if let message  = responseDict["message"] as? String{
                    print(message)
                    self.HomeDelegateView?.hideLoader()
                    self.delegate.HomeDidSucceeed(message: message)
                    self.DELETE_MOOD_LOG_FROM_COREDATA()
                }
                
            }) { (networkError) in
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                print(networkError)
            }
        }
        
    }
    
    
    
    //MARK: <-------------- CREATE NEW POST FOR MOOD EVENTS ONLY MOOD NO ADDITION FILES LIKE AUDIO OR VIDEO --------------->
    func CREATE_ONLY_EMOJI_MOOD_EVENT(moodName:String,icName:String,dateTime:String,sendTimeForSort:String)
    {
        
        //Remove this and add to global class //Reminder
        let user = UserDefaults.standard.getUserId() ?? ""
        let url = "eventPost"
        
        parms["user_id"] = user
        parms["moodTrack"] = moodName
        parms["moodTrackResId"] = icName
        parms["mood_track_time"] = dateTime//add time here
        parms["current_time"] = sendTimeForSort
        parms["created_at"] = sendTimeForSort
        
        self.HomeDelegateView?.showLoader()
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .none, urlMedia: nil, urlString: url, fileData: nil, requestDict: parms, method: .post, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                self.HomeDelegateView?.hideLoader()
                
                if let result = responseDict["data"] as? NSDictionary
                {
                    if (result.count > 0)
                    {
                        let moood_id = result.value(forKey: "_id")as? String ?? "0"
                        Singleton.shared().updated_emojy_eventID = moood_id
                        CoreData_Model.update_emoji_status_posted(status:"1", moodID: moood_id)
                    }
                }
                
                self.delegate.HomeDidSucceeed(message: message)
            }
            else
            {
                self.HomeDelegateView?.hideLoader()
                self.delegate.HomeDidFailed(message: "Error in updating mood!")
            }
            
        }) { (networkError) in
            self.HomeDelegateView?.hideLoader()
            self.delegate.HomeDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(networkError)
        }
        
        
    }
    
    
    func GET_FILE_PATH(fileName:String) -> String
    {
        if (fileName.count > 0)
        {
            let fm = FileManager.default
            let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let path = docsurl.appendingPathComponent(fileName)
            return path.absoluteString
        }
        else
        {
            return ""
        }
    }
    
    func DELETE_MOOD_LOG_FROM_COREDATA()
    {
        CoreData_Model.delete_MOOD_LOG_FROM_coreData(success: { (result) in
            print(result)
        })
        { (err) in
            print(err)
        }
    }
    
    
    func TRACK_MOOD_USING_AI(mood:String)
    {
        if (mood == "Fear")
        {
           ExtensionModel.shared.Emoji_CurrentPage = 0
        }
        else if (mood == "Happy")
        {
           ExtensionModel.shared.Emoji_CurrentPage = 4
        }
        else if (mood == "Angry")
        {
           ExtensionModel.shared.Emoji_CurrentPage = 5
        }
        else if (mood == "Surprise")
        {
            ExtensionModel.shared.Emoji_CurrentPage = 3
        }
        else if (mood == "Sad")
        {
            ExtensionModel.shared.Emoji_CurrentPage = 6
        }
        else
        {
           ExtensionModel.shared.Emoji_CurrentPage = 1
        }
    }
    
}

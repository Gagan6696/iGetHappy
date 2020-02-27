//
//  MoodLogPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol MoodLogDelegate : class
{
    func MoodLogDidSucceeed(data:Any?)
    func MoodLogDidFailed(message:String?)
    func MoodLog_success_data(response:MoodLogGetMapper?)
}

class MoodLogPresenter
{
    //ChooseCareRecieverPresenter Delegate
    var delegate:MoodLogDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var MoodLogDelegateView: MoodLogViewDelegate?
    
    init(delegate:MoodLogDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: MoodLogViewDelegate) {
        MoodLogDelegateView = view
    }
    //Detaching login view
    func detachView() {
        MoodLogDelegateView = nil
    }
    
    func getAllMoodLogsByCareRecieverId(careRecieverId:String?)
    {
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        parm.removeAll()
        parm["user_id"] = userID
        if(careRecieverId == ""){
            
        }else{
             parm["careReceiverId"] = careRecieverId
        }
        parm["limit"] = "100"
        parm["skip"] = "0"
        
      //  let url = "eventPost/\(userID)"
        
        let url = "eventPost/getMoodLogs"
        
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            self.MoodLogDelegateView?.hideLoader()
            print(response)
            //Design Model and append
            self.MoodLogDataJSON(data: response, completionResponse: { (moodLogData) in
                self.delegate.MoodLog_success_data(response: moodLogData)
                //send data to delegate
                
            }, completionError: { (error) in
                  self.MoodLogDelegateView?.hideLoader()
                self.delegate.MoodLogDidFailed(message: error?.localizedDescription)
                //print(error!)
            })

        }, completionnilResponse: { (message) in
            print(message)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: message)
            //send data to delegate

        }, completionError: { (error) in
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate

        }) { (error) in
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)

        }
        
        
//        ServiceCall.sharedManager.GetApi(url: url, completionResponse: { (response) in
//            self.MoodLogDelegateView?.hideLoader()
//            print(response)
//        }, completionnilResponse: { (message) in
//            print(message)
//            self.MoodLogDelegateView?.hideLoader()
//            self.delegate.MoodLogDidFailed(message: message)
//        }, completionError: { (error) in
//            self.MoodLogDelegateView?.hideLoader()
//            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
//        }) { (error) in
//            self.MoodLogDelegateView?.hideLoader()
//            if (error.count > 0)
//            {
//                self.delegate.MoodLogDidFailed(message: error)
//            }
//            else
//            {
//                self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
//            }
//
//            print(error)
//        }
        
    }
    
    func deleteMoodLogByMoodId(moodId:String?)
    {
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "eventPost/deleteMoodLogs"
        if let userID = UserDefaults.standard.getUserId()
        {
            parm["user_id"] = userID
        }
        else
        {
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        parm["mood_log_id"] = moodId
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidSucceeed(data: response)//mohit
        }, completionnilResponse: { (message) in
            print(message)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
             self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
    }
    
    func shareMoodLogByMoodId(moodId:String?)
    {
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "eventPost/shareMoodLogs"
        if let userID = UserDefaults.standard.getUserId()
        {
            parm["user_id"] = userID
        }
        else
        {
             self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        parm["mood_log_id"] = moodId
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.MoodLogDelegateView?.hideLoader()
            
            self.delegate.MoodLogDidSucceeed(data: response)
            
        }, completionnilResponse: { (message) in
            print(message)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
    }
    
    private func MoodLogDataJSON(data: [String : Any],completionResponse:  @escaping (MoodLogGetMapper) -> Void,completionError: @escaping (Error?) -> Void)
    {
        let careRecieverData = MoodLogGetMapper(JSON: data)
        completionResponse(careRecieverData!)
    }
}


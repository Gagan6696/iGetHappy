//
//  MoodLogPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol MoodLogDelegate : class {
    func MoodLogDidSucceeed(data:String?)
    func MoodLogDidFailed(message:String?)
}

class MoodLogPresenter{
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
    
    func getAllMoodLogsByCareRecieverId(careRecieverId:String?){
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "eventPost"
        if let userID = UserDefaults.standard.getUserId(){
            parm["user_id"] = userID
            
        }else{
            self.delegate.MoodLogDidFailed(message: "")
        }
       parm["careReceiverId"] = careRecieverId
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            self.MoodLogDelegateView?.hideLoader()
            print(response)
            //Design Model and append
            
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
    
    func deleteMoodLogByMoodId(moodId:String?){
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "eventPost/deleteMoodLogs"
        if let userID = UserDefaults.standard.getUserId(){
            parm["user_id"] = userID
        }else{
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        //Reminder
         parm["mood_log_id"] = "5ddf953f7c6396744655c2ff"
        //parm["mood_log_id"] = moodId
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidSucceeed(data: "Mood Log deleted succesfully.")
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
    
    func shareMoodLogByMoodId(moodId:String?){
        self.MoodLogDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "eventPost/shareMoodLogs"
        if let userID = UserDefaults.standard.getUserId(){
            parm["user_id"] = userID
        }else{
            self.delegate.MoodLogDidFailed(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        parm["mood_log_id"] = moodId
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.MoodLogDelegateView?.hideLoader()
            self.delegate.MoodLogDidSucceeed(data: "Mood Log shared succesfully")
            
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
}


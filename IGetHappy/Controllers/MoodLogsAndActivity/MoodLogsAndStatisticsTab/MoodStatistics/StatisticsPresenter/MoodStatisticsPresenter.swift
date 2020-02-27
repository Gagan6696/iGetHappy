//
//  MoodStatisticsPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 12/12/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol MoodStatisticsDelegate : class {
    func MoodStatisticsDidSucceeed(data:StreakAndMoodCountMapper?)
    func MoodStatisticsActivityDidSucceeed(data:ActivityCountMapper?)
    func MoodStatisticsChartDidSucceeed(data:MoodStatisticsMapper?)
    func MoodStatisticsDidFailed(message:String?)
}

class MoodStatisticsPresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:MoodStatisticsDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var MoodStatisticsDelegateView: MoodStatisticsViewDelegate?
    
    init(delegate:MoodStatisticsDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: MoodStatisticsViewDelegate) {
        MoodStatisticsDelegateView = view
    }
    //Detaching login view
    func detachView() {
        MoodStatisticsDelegateView = nil
    }
    
    func GetSreakAndMoodCount(careReceiverId:String?){
        
        self.MoodStatisticsDelegateView?.showLoader()
        //Reminder
        let userId = UserDefaults.standard.getUserId() ?? ""
        
        parm["user_id"] = userId
        parm["filter"] = "daily"
        if (careReceiverId != ""){
            parm["careReceiverId"] = careReceiverId
        }
        
        let url = "eventPost/moodStats"
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response
            in
            print(response)
            self.StreakAndMoodCountDataJSON(data: response, completionResponse: { (moodStatisticsData) in
                self.MoodStatisticsDelegateView?.hideLoader()
                
                
                self.delegate.MoodStatisticsDidSucceeed(data: moodStatisticsData)
                

                //send data to delegate
                
            }, completionError: { (error) in
                self.MoodStatisticsDelegateView?.hideLoader()
                self.delegate.MoodStatisticsDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }

    }

    func GetChartDetails(careReceiverId:String?){
        
        self.MoodStatisticsDelegateView?.showLoader()
        //Reminder
        let userId = UserDefaults.standard.getUserId() ?? ""
        
        
        
        parm["user_id"] = userId
        
        //parm["filter"] = "daily"
        let url = "eventPost/getMoodChartForStats"
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response
            in
            print(response)
            self.ChartDataJSON(data: response, completionResponse: { (moodStatisticsData) in
                self.MoodStatisticsDelegateView?.hideLoader()
                self.delegate.MoodStatisticsChartDidSucceeed(data: moodStatisticsData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.MoodStatisticsDelegateView?.hideLoader()
                self.delegate.MoodStatisticsDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
    }
    func GetActivityCount(careReceiverId:String?,resourceId:String){
        
        self.MoodStatisticsDelegateView?.showLoader()
        //Reminder
        let userId = UserDefaults.standard.getUserId() ?? ""
        
        parm["user_id"] = userId
        if (careReceiverId != ""){
            parm["careReceiverId"] = careReceiverId
        }
        parm["moodTrackResId"] = resourceId
        let url = "eventPost/getEventsByMood"
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response
            in
            print(response)
            
            self.ActivityCountDataJSON(data: response, completionResponse: { (activityCountData) in
                self.MoodStatisticsDelegateView?.hideLoader()

                self.delegate.MoodStatisticsActivityDidSucceeed(data: activityCountData)
                
                
                //send data to delegate
                
            }, completionError: { (error) in
                self.MoodStatisticsDelegateView?.hideLoader()
                self.delegate.MoodStatisticsDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.MoodStatisticsDelegateView?.hideLoader()
            self.delegate.MoodStatisticsDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
        
        
    }
    private func ChartDataJSON(data: [String : Any],completionResponse:  @escaping (MoodStatisticsMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let moodStatisticsData = MoodStatisticsMapper(JSON: data)
        completionResponse(moodStatisticsData!)
    }
    private func StreakAndMoodCountDataJSON(data: [String : Any],completionResponse:  @escaping (StreakAndMoodCountMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let streakAndMoodCountData = StreakAndMoodCountMapper(JSON: data)
        completionResponse(streakAndMoodCountData!)
    }
    private func ActivityCountDataJSON(data: [String : Any],completionResponse:  @escaping (ActivityCountMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let activityCountData = ActivityCountMapper(JSON: data)
        completionResponse(activityCountData!)
    }
}

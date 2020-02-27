//
//  ChooseCareRecieverPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 10/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol ChooseCareRecieverDelegate : class {
    func ChooseCareRecieverDidSucceeed(data:ChooseCareRecieverMapper?)
    func ChooseCareRecieverDidFailed(message:String?)
}


class ChooseCareRecieverPresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:ChooseCareRecieverDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var ChooseCareRecieverDelegateView: ChooseCareRecieverViewDelegate?
    
    init(delegate:ChooseCareRecieverDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ChooseCareRecieverViewDelegate) {
        ChooseCareRecieverDelegateView = view
    }
    //Detaching login view
    func detachView() {
        ChooseCareRecieverDelegateView = nil
    }
   
    func GetAllListCareReciever(){

        self.ChooseCareRecieverDelegateView?.showLoader()
        //Reminder
        let userId = UserDefaults.standard.getUserId() ?? ""
        
        parm["user_id"] = userId
        
        
        let url = "careReceivers/getApprovedCareReceiver" // UrlStrings.ChooseCareReciever.getcarereceiver
   
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response
            in
            print(response)
            self.CareRecieverDataJSON(data: response, completionResponse: { (careRecieverData) in
                self.ChooseCareRecieverDelegateView?.hideLoader()
               self.delegate.ChooseCareRecieverDidSucceeed(data: careRecieverData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.ChooseCareRecieverDelegateView?.hideLoader()
                self.delegate.ChooseCareRecieverDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.ChooseCareRecieverDelegateView?.hideLoader()
            self.delegate.ChooseCareRecieverDidFailed(message: message)
             //send data to delegate
            
        }, completionError: { (error) in
            self.ChooseCareRecieverDelegateView?.hideLoader()
            self.delegate.ChooseCareRecieverDidFailed(message: Constants.Global.MessagesStrings.ServerError)
             //send data to delegate
            
        }) { (error) in
            self.ChooseCareRecieverDelegateView?.hideLoader()
            self.delegate.ChooseCareRecieverDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
      
//        ChooseCareRecieverService.sharedInstance.GetEmaotionService(urlMedia: url as! URL, url: UrlStrings.UploadPost.AllTypePost,completionResponse: { (message) in
//
//            self.BaseTabDelegateView?.hideLoader()
//            self.delegate.BaseTabDidSucceeed(message: message)
//        }, completionnilResponse: { (message) in
//            self.BaseTabDelegateView?.hideLoader()
//            self.BaseTabDelegateView?.showAlert(alertMessage: message)
//        }, completionError: { (error) in
//            print(error)
//            self.BaseTabDelegateView?.showAlert(alertMessage: "\(error)")
//        }) { (networkerror) in
//
//            self.BaseTabDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
//
//        }
        
        
    }
    private func CareRecieverDataJSON(data: [String : Any],completionResponse:  @escaping (ChooseCareRecieverMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let careRecieverData = ChooseCareRecieverMapper(JSON: data)
        completionResponse(careRecieverData!)
    }
    
}

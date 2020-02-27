//
//  MyAllVentsPresenter.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol AllVentsDelegate : class
{
    func AllVentsDidSucceeed(eventModel:[AllVentsModel])
    func AllVentsDidFailed(message:String?)
   
}


class AllVentsPresenter
{
    //Login Delegate
    var delegate:AllVentsDelegate
    
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var allVentsDelegateView: AllVentsViewDelegate?
    
    init(delegate:AllVentsDelegate)
    {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: AllVentsViewDelegate)
    {
        allVentsDelegateView = view
    }
    //Detaching login view
    func detachView()
    {
        allVentsDelegateView = nil
    }
    
    
    func CALL_API_GET_SHARED_POSTS()
    {
        
        let userID = UserDefaults.standard.getUserId() ?? "0"
        self.allVentsDelegateView?.showLoader()
        
        let urlfinal = UrlStrings.BASE_URL + UrlStrings.GetPostedEvents.getShared + userID
        
        ServiceCall.sharedManager.GetApi(url: urlfinal, completionResponse: { (result) in
            
           print(result)
          
            self.allVentsDataJSON(data: result, completionResponse: { (ventData) in
              self.allVentsDelegateView?.hideLoader()
               self.delegate.AllVentsDidSucceeed(eventModel: ventData)
                //send data to delegate
                
            }, completionError: { (error) in
                print(error!)
            })
           
            
        }, completionnilResponse: { (String) in
            
            self.allVentsDelegateView?.hideLoader()
            self.allVentsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.SomethingWentWrong)
            print(String)
            
        }, completionError: { (Error) in
            self.allVentsDelegateView?.hideLoader()
            self.allVentsDelegateView?.showAlert(alertMessage:  Constants.Global.MessagesStrings.SomethingWentWrong)
            print(Error as Any)
            
        }) { (networkerror) in
            self.allVentsDelegateView?.hideLoader()
            self.allVentsDelegateView?.showAlert(alertMessage:  Constants.Global.MessagesStrings.SomethingWentWrong)
            print(networkerror)
        }
        
        
        
    }
    private func allVentsDataJSON(data: [String : Any],completionResponse:  @escaping ([AllVentsModel]) -> Void,completionError: @escaping (Error?) -> Void)  {
        let ventsData = AllVentsModel(JSON: data)
        completionResponse([ventsData!])
    }
}


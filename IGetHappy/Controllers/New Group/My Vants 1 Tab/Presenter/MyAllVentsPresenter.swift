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
    func AllVentsDidSucceeed(eventModel:[AllVentsModelDetail])
    func AllVentsDidFailed(message:String?)
    func AllVentsDidSucceeedDelete(message:String)
    func AllVentsDidFailedDelete(message:String?)
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
    
    
    func CALL_API_GET_SHARED_POSTS(searchKeyword:String,startDate:String,endDate:String,limit:String,skip:String)
    {
        let userID = UserDefaults.standard.getUserId() ?? "0"
        self.allVentsDelegateView?.showLoader()
        
        let urlfinal =  UrlStrings.GetMyVents.getMyVents
        var param : [String:Any] = [:]
        
        param["user_id"] = userID
        param["limit"] = "100"
        param["skip"] = "0"
        param["searchKeyword"] = searchKeyword
        param["privacy_option"] = "PUBLIC"
        
        if(startDate.count > 0 || endDate.count > 0)
        {
            param["startDate"] = startDate
            param["endDate"] = endDate
        }
        
        
            
        
        
//        CommonVc.AllFunctions.HeaderWithGETRequestToken_MODEL(forURL: urlfinal, params: param as [String : AnyObject], success: { (response, error) in
//
//            if((error == nil))
//            {
//                self.getResponse = response
//                if self.getResponse?.status == 200
//                {
//                    if let getData = self.getResponse?.AllVentsData
//                    {
//                        self.allVentsDelegateView?.hideLoader()
//                        self.delegate.AllVentsDidSucceeed(eventModel: getData)
//                    }
//                    else
//                    {
//                        self.allVentsDelegateView?.hideLoader()
//                        self.allVentsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.SomethingWentWrong)
//                    }
//                }
//                else
//                {
//                    let msg = self.getResponse?.messege ?? "Internal Error!"
//                    self.allVentsDelegateView?.hideLoader()
//                    self.allVentsDelegateView?.showAlert(alertMessage: msg)
//                }
//
//            }
//            else
//            {
//                self.allVentsDelegateView?.hideLoader()
//                self.allVentsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.SomethingWentWrong)
//            }
//        })
        
        ServiceCall.sharedManager.PostApi(url: urlfinal, parameter: param, completionResponse: { response
            in
            print(response)
            
            self.allVentsDataJSON(data: response, completionResponse: { (ventsData) in
              self.allVentsDelegateView?.hideLoader()
                //self.delegate.CareReceiverDidSucceeed(data: careRecieverData)
                self.delegate.AllVentsDidSucceeed(eventModel: ventsData)
                //send data to delegate

            }, completionError: { (error) in
               self.allVentsDelegateView?.hideLoader()
                self.delegate.AllVentsDidFailed(message: error?.localizedDescription)
               
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.allVentsDelegateView?.hideLoader()
             self.allVentsDelegateView?.showAlert(alertMessage:message)
           
            //send data to delegate
            
        }, completionError: { (error) in
            self.allVentsDelegateView?.hideLoader()
             self.allVentsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
           
            //send data to delegate
            
        }) { (error) in
            self.allVentsDelegateView?.hideLoader()
             self.allVentsDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
          
            print(error)
            
        }

            
    }
        
    private func allVentsDataJSON(data: [String : Any],completionResponse:  @escaping ([AllVentsModelDetail]) -> Void,completionError: @escaping (Error?) -> Void)
    {
        let data = AllVentsModel(JSON: data)
        let allVentsModelData = data?.data
        completionResponse(allVentsModelData!)
    }
        
    func deletePostVents(post_id:String){
        
        let appendIdUrl = UrlStrings.MyVents.deleteVents + "\(post_id)" + "/0/post"
        ServiceCall.sharedManager.deleteApi(url: appendIdUrl, completionResponse: { (message) in
            self.delegate.AllVentsDidSucceeedDelete(message: message)
        }, completionnilResponse: { (message) in
            print(message)
            self.delegate.AllVentsDidFailedDelete(message: message)
        }, completionError: { (error) in
             self.delegate.AllVentsDidFailedDelete(message: Constants.Global.MessagesStrings.SomethingWentWrong)
        }) { (error) in
             self.delegate.AllVentsDidFailedDelete(message: Constants.Global.MessagesStrings.ServerError)
            //print(error)
        }

    }
}





//
//  CareReceiverPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol CareReceiverDelegate : class {
    func CareReceiverDidSucceeed(data:CareReceiverMapper)
    func CareReceiverDidFailed(message:String?)
}


class CareReceiverPresenter
{
    //ChooseCareRecieverPresenter Delegate
    var delegate:CareReceiverDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var CareReceiverDelegateView: CareReceiverViewDelegate?
    
    init(delegate:CareReceiverDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: CareReceiverViewDelegate) {
        CareReceiverDelegateView = view
    }
    //Detaching login view
    func detachView() {
        CareReceiverDelegateView = nil
    }
    
    func getCareRecieverListWithStatus(){
        
        self.CareReceiverDelegateView?.showLoader()
        if let userId = UserDefaults.standard.getUserId(){
            parm["user_id"] = userId
        }
        
        ServiceCall.sharedManager.PostApi(url: UrlStrings.ChooseCareReciever.getcarereceiver, parameter: parm, completionResponse: { response
            in
            print(response)
            
            self.CareRecieverDataJSON(data: response, completionResponse: { (careRecieverData) in
                self.CareReceiverDelegateView?.hideLoader()
                self.delegate.CareReceiverDidSucceeed(data: careRecieverData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.CareReceiverDelegateView?.hideLoader()
                self.delegate.CareReceiverDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.CareReceiverDelegateView?.hideLoader()
            self.delegate.CareReceiverDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.CareReceiverDelegateView?.hideLoader()
            self.delegate.CareReceiverDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.CareReceiverDelegateView?.hideLoader()
            self.delegate.CareReceiverDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
        
        
    }
    
    
    private func CareRecieverDataJSON(data: [String : Any],completionResponse:  @escaping (CareReceiverMapper) -> Void,completionError: @escaping (Error?) -> Void)
    {
        let careRecieverData = CareReceiverMapper(JSON: data)
        completionResponse(careRecieverData!)
    }
    
}

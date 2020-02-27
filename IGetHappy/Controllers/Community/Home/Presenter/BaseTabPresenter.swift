//
//  BaseTabPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/22/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol BaseTabDelegate : class {
    func BaseTabDidSucceeed(message:String?)
    func BaseTabDidFailed(message:String?)
}


class BaseTabPresenter{
    //Login Delegate
    var delegate:BaseTabDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var BaseTabDelegateView: BaseTabViewDelegate?
    
    init(delegate:BaseTabDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: BaseTabViewDelegate) {
        BaseTabDelegateView = view
    }
    //Detaching login view
    func detachView() {
        BaseTabDelegateView = nil
    }
    
    
    func Login(url:URL?){
        
       
        self.BaseTabDelegateView?.showLoader()
        
        BaseTabService.sharedInstance.GetEmaotionService(urlMedia: url as! URL, url: UrlStrings.UploadPost.AllTypePost,completionResponse: { (message) in
            
            self.BaseTabDelegateView?.hideLoader()
            self.delegate.BaseTabDidSucceeed(message: message)
        }, completionnilResponse: { (message) in
            self.BaseTabDelegateView?.hideLoader()
            self.BaseTabDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.BaseTabDelegateView?.hideLoader()
            self.BaseTabDelegateView?.showAlert(alertMessage: "\(error?.localizedDescription)")
        }) { (networkerror) in
             self.BaseTabDelegateView?.hideLoader()
            self.BaseTabDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
        
    }
   
    
}

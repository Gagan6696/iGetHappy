//
//  MyProfilePresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol MyProfileDelegate : class {
    func MyProfileDidSucceeed(data:MyProfileMapper?)
    func MyProfileDidFailed(message:String?)
}

class MyProfilePresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:MyProfileDelegate
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var MyProfileDelegateView: MyProfileViewDelegate?
    
    init(delegate:MyProfileDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: MyProfileViewDelegate) {
        MyProfileDelegateView = view
    }
    //Detaching login view
    func detachView() {
        MyProfileDelegateView = nil
    }
    
    func getMyProfile(){
        
        self.MyProfileDelegateView?.showLoader()
        let userId = UserDefaults.standard.getUserId() ?? ""
        let url =  UrlStrings.GetUserProfile.getUserProfile + userId
        
        ServiceCall.sharedManager.GetApi(url: url, completionResponse: { response
            in
            self.MyProfileDataJSON(data: response, completionResponse: { (myProfileData) in
                self.MyProfileDelegateView?.hideLoader()
                self.delegate.MyProfileDidSucceeed(data: myProfileData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.MyProfileDelegateView?.hideLoader()
                self.delegate.MyProfileDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
            
        }, completionnilResponse: { (message) in
            print(message)
            self.MyProfileDelegateView?.hideLoader()
            self.delegate.MyProfileDidFailed(message: message)
        }, completionError: { (error) in
            self.MyProfileDelegateView?.hideLoader()
            self.delegate.MyProfileDidFailed(message: Constants.Global.MessagesStrings.ServerError)
        }) { (error) in
            self.MyProfileDelegateView?.hideLoader()
            self.delegate.MyProfileDidFailed(message: Constants.Global.MessagesStrings.ServerError)
        }

    }
    private func MyProfileDataJSON(data: [String : Any],completionResponse:  @escaping (MyProfileMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let myProfileData = MyProfileMapper(JSON: data)
        completionResponse(myProfileData!)
    }
    
}

//
//  ForgotPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol ForgotDelegate : class {
    func ForgotDidSucceeed(message:String?)
    func ForgotDidFailed()
}
class ForgotPresenter{
    var delegate:ForgotDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var forgotDelegateView: ForgotViewDelegate?
    
    init(delegate:ForgotDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ForgotViewDelegate) {
        forgotDelegateView = view
    }
    //Detaching login view
    func detachView() {
        forgotDelegateView = nil
    }
    
    func Forgot(email:String?,phCode:String){
        if((email?.isNumber)!){
            parm["phone"] = email! //"+1"
            parm["phone_code"] = phCode
        }else{
            parm["email"] = email
        }
       
        self.forgotDelegateView?.showLoader()
        AuthenticationService.sharedInstance.UserForgotService(url: UrlStrings.Forgot.forgotUrl, postDict: parm, completionResponse: { (ForgotData) in
            self.forgotDelegateView?.hideLoader()
            self.delegate.ForgotDidSucceeed(message:ForgotData.message)
        }, completionnilResponse: { (message) in
            self.forgotDelegateView?.hideLoader()
            self.forgotDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.forgotDelegateView?.hideLoader()
            self.forgotDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
            self.forgotDelegateView?.hideLoader()
            self.forgotDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
    }
    
    
    func Validations(email:String?) throws{
        guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.Forgot.emptyEmail
        }
            if((email?.isNumber)!){
                if(!((email?.phoneMinLength)!)){
                    throw ValidationError.Login.minPhoneNumber
                }
            }else if((email?.isEmail)!){
                if(!((email?.emailMinLength)!)){
                    throw ValidationError.Login.emailMinLength
                }
            }else{
                throw ValidationError.Login.invalidEmailPhone
            }
        
//        if(!(email?.isEmail)!){
//           throw ValidationError.Forgot.wrongEmail
//        }
//        guard let PhoneNumber = phoneNumber,  !PhoneNumber.isEmpty, !PhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.Forgot.emptyPhoneNumber
//        }
//        if(!((phoneNumber?.phoneMinLength)!)){
//            throw ValidationError.Forgot.phoneMinLength
//        }
//        if(!((phoneNumber?.isNumber)!)){
//            throw ValidationError.Forgot.invalidPhoneNumber
//        }
//        if(!((email?.emailMinLength)!)){
//            throw ValidationError.Forgot.emailMinLength
//        }
        
        
       
    }
    
}

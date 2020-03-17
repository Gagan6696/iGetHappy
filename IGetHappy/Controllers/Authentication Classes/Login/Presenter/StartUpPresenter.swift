//
//  StartUpPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation


protocol StartUpDelegate : class {
    func CheckEmailPassed()
    func CheckEmailFailed(message:String?)
    func LoginDidSucceeed()
    func LoginDidFailed(message:String?)
    
}

class StartUpPresenter{
    //StartUpPresenter Delegate
    var delegate:StartUpDelegate
    
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var StartUpDelegateView: StartUpViewDelegate?
    
    init(delegate:StartUpDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: StartUpViewDelegate) {
        StartUpDelegateView = view
    }
    //Detaching login view
    func detachView() {
        StartUpDelegateView = nil
    }
    
    func CheckEmailExist(email:String?){
        self.StartUpDelegateView?.showLoader()
        parm["email"] = email
        AuthenticationService.sharedInstance.CheckEmailService(url: UrlStrings.Register.isEmailExist, email: email, completionResponse: { (CheckEmailMapper) in
            if let userid = CheckEmailMapper.data?._id{
                UserDefaults.standard.setUserId(value:userid)
            }
            
            self.delegate.CheckEmailPassed()
            self.StartUpDelegateView?.hideLoader()
            
        }, completionnilResponse: { (message) in
            
            self.StartUpDelegateView?.hideLoader()
            self.delegate.CheckEmailFailed(message: message)
            
        }, completionError: { (message) in
             self.StartUpDelegateView?.hideLoader()
        }) { (error) in
             self.StartUpDelegateView?.hideLoader()
            print(error)
        }
        
    }
    
    func Validations(email:String?,Passowrd:String?) throws{
        guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.Login.emptyUserName
        }
        if(!((email?.emailMinLength)!)){
            throw ValidationError.Login.emailMinLength
        }
        
        if(!(email?.isEmail)!){
            
            throw ValidationError.Login.wrongEmail
        }
        
        guard let Password = Passowrd,  !Password.isEmpty, !Password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.Login.emptyPassword
        }
        if(!(Passowrd?.passwordMinLength)!){
            throw ValidationError.Login.MinLength
        }
        if(!(Passowrd?.checkTextSufficientComplexity())!){
            throw ValidationError.Login.weakPassword
        }
        
    }
    
    func Login(email:String?,Passowrd:String?,social_id:String?){
        if((email?.isNumber)!){
           // parm["phone"] = email
         //   parm["password"] = Passowrd
            parm["social_id"] = social_id
        }else{
           // parm["email"] = email
           // parm["password"] = Passowrd
            parm["social_id"] = social_id
        }
        self.StartUpDelegateView?.showLoader()
        AuthenticationService.sharedInstance.UserLoginService(url: UrlStrings.Login.loginUrl, postDict: parm, completionResponse: { (UserData) in
            
            if let token = UserData.token{
                UserDefaults.standard.setAccessTokken(value: token)
            }
            
            UserDefaults.standard.setLoggedIn(value: true)
            
            if let userId = UserData.data?._id{
                UserDefaults.standard.setUserId(value: userId)
            }
            if let isAnonymous = UserData.data?.anonymous{
                UserDefaults.standard.setAnonymous(value: isAnonymous)
            }
            self.StartUpDelegateView?.hideLoader()
            self.delegate.LoginDidSucceeed()
        }, completionnilResponse: { (message) in
            self.StartUpDelegateView?.hideLoader()
            self.delegate.LoginDidFailed(message:message)
            //            self.StartUpDelegateView?.showAlert(Message: message)
        }, completionError: { (error) in
            print(error)
            self.StartUpDelegateView?.hideLoader()
            self.StartUpDelegateView?.showAlert(Message: Constants.Global.MessagesStrings.ServerError)
        }) { (networkerror) in
            self.StartUpDelegateView?.hideLoader()
            self.StartUpDelegateView?.showAlert(Message: Constants.Global.MessagesStrings.ServerError)
            
        }
        
        
    }
    
    
}

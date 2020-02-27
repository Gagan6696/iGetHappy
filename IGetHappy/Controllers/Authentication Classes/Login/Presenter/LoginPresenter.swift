//
//  LoginPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 5/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol LoginDelegate : class
{
    func LoginDidSucceeed()
    func LoginDidFailed(message:String?)
}


class LoginPresenter{
    //Login Delegate
    var delegate:LoginDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var LoginDelegateView: LoginViewDelegate?
    
    init(delegate:LoginDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: LoginViewDelegate) {
        LoginDelegateView = view
    }
    //Detaching login view
    func detachView() {
        LoginDelegateView = nil
    }
    
    
    func Login(email:String?,Passowrd:String?,phoneCode:String?)
    {
        
        if((email?.isNumber)!)
        {
            parm["phone"] = email
            parm["password"] = Passowrd
            parm["phone_code"] = phoneCode
        }
        else
        {
            parm["email"] = email
            parm["password"] = Passowrd
            parm["phone_code"] = phoneCode
        }
        
        
        self.LoginDelegateView?.showLoader()
        AuthenticationService.sharedInstance.UserLoginService(url: UrlStrings.Login.loginUrl, postDict: parm, completionResponse: { (UserData) in
            
            //Token implemented
            if let token = UserData.token{
                UserDefaults.standard.setAccessTokken(value: token)
            }
            
            UserDefaults.standard.setLoggedIn(value: true)
            
            UserDefaults.standard.setUserId(value: UserData.data?._id)
            
            if let name  = UserData.data?.first_name {
                UserDefaults.standard.setFirstName(value: name)
            }
            
            if let name  = UserData.data?.last_name {
                UserDefaults.standard.setLastName(value: name)
            }
            
            if let profileImage = UserData.data?.profile_image{
                UserDefaults.standard.setProfileImage(value: profileImage)
            }
            if let isAnonymous = UserData.data?.anonymous{
                UserDefaults.standard.setAnonymous(value: isAnonymous)
            }
            
            UserData.data?.first_name
            self.LoginDelegateView?.hideLoader()
            self.delegate.LoginDidSucceeed()
        }, completionnilResponse: { (message) in
            self.LoginDelegateView?.hideLoader()
            self.LoginDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.LoginDelegateView?.hideLoader()
            self.LoginDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
            self.LoginDelegateView?.hideLoader()
            self.LoginDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
        
    }
    
    
    func Validations(email:String?,Passowrd:String?) throws
    {
        if (((email?.isEmpty)!) || email!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        {
            guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
            {
                throw ValidationError.Login.emptyUserName
            }
        }
        else
        {
            if((email?.isNumber)!)
            {
                if(!((email?.phoneMinLength)!))
                {
                    throw ValidationError.Login.minPhoneNumber
                }
            }
            else if((email?.isEmail)!)
            {
                if(!((email?.emailMinLength)!))
                {
                    throw ValidationError.Login.emailMinLength
                }
            }
            else
            {
                throw ValidationError.Login.invalidEmailPhone
            }
        }
        guard let Password = Passowrd,  !Password.isEmpty, !Password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.Login.emptyPassword
        }
        if(!(Passowrd?.passwordMinLength)!)
        {
            throw ValidationError.Login.MinLength
        }
        if(!(Passowrd?.checkTextSufficientComplexity())!)
        {
            throw ValidationError.Login.weakPassword
        }
        
        
        
    }
    
}

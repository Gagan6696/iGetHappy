//
//  RegisterPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 5/20/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import libPhoneNumber_iOS

protocol RegisterDelegate : class
{
    func RegisterDidSucceeed(message:String?)
    func RegisterDidFailed(message:String?)
    func RegisterPhoneDidSucceeed(message:String?)
    func RegisterPhoneDidFailed(message:String?)
}


class RegisterPresenter{
    //Register Delegate
    var delegate:RegisterDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var RegisterDelegateView: RegisterViewDelegate?
    
    init(delegate:RegisterDelegate)
    {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: RegisterViewDelegate)
    {
        RegisterDelegateView = view
    }
    //Detaching login view
    func detachView() {
        RegisterDelegateView = nil
    }
    
    
    func CheckEmailExist(email:String?){
        self.RegisterDelegateView?.showLoader()
        AuthenticationService.sharedInstance.CheckEmailService(url: UrlStrings.Register.isEmailExist, email: email, completionResponse: { (CheckEmailMapper) in
            self.RegisterDelegateView?.hideLoader()
            self.delegate.RegisterDidSucceeed(message: CheckEmailMapper.message)
            
        }, completionnilResponse: { (message) in
            self.RegisterDelegateView?.hideLoader()
            self.delegate.RegisterDidFailed(message: message)
            
        }, completionError: { (message) in
            
        }) { (error) in
            print(error)
        }
        
    }
    func CheckPhoneExist(phoneNum: String?){
        self.RegisterDelegateView?.showLoader()
        AuthenticationService.sharedInstance.CheckPhoneService(url: UrlStrings.Register.isPhoneExist, phoneNum: "+91"+"/"+phoneNum!, completionResponse: { (CheckEmailMapper) in
            self.RegisterDelegateView?.hideLoader()
            self.delegate.RegisterPhoneDidSucceeed(message: CheckEmailMapper.message)
            
        }, completionnilResponse: { (message) in
            self.RegisterDelegateView?.hideLoader()
            self.delegate.RegisterPhoneDidFailed(message: message)
            
        }, completionError: { (message) in
            
        }) { (error) in
             self.RegisterDelegateView?.hideLoader()
            self.delegate.RegisterPhoneDidFailed(message: error)
            print(error)
        }
    }
    
    private func checkPhone(countryCode:String?, PhoneNumber:String?) -> Bool{
        let phoneUtil = NBPhoneNumberUtil()
        
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(PhoneNumber, defaultRegion: countryCode)
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            if phoneUtil.isValidNumber(phoneNumber) == true {
                return true
                print("TRUE")
            }
            else {
                return false
                print("FALSE")
            }
            
            //NSLog("[%@]", formattedString)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            
        }
        return false
    }
    
    func Validations(email:String?,Passowrd:String?,phoneNumber:String?,countryCode:String?) throws{

        if (email?.isEmpty ?? false && phoneNumber?.isEmpty ?? false){
             throw ValidationError.Register.emptyEmailAndPhone
        }else{
            if (email?.isEmpty == false){
                guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
                {
                    throw ValidationError.Register.emptyEmail
                }
                
            if(!(email?.isEmail)!){
                    print(email?.isEmail)
                throw ValidationError.Register.wrongEmail
            }
                
            if(!(email?.emailMinLength)!){
                throw ValidationError.Register.minEmailLength
            }
                
            }else if (phoneNumber?.isEmpty == false){
            guard let PhoneNumber = phoneNumber,  !PhoneNumber.isEmpty, !PhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                else
            {
                throw ValidationError.Register.emptyPhoneNumber
            }
            if(!(phoneNumber?.isNumber)!){
                throw ValidationError.Register.wrongPhoneNum
            }
            if(!(phoneNumber?.phoneMinLength)!){
                throw ValidationError.Register.minPhoneNumber
            }
            let isValidPhone = checkPhone(countryCode:countryCode , PhoneNumber: phoneNumber)
            if(!isValidPhone){
                throw ValidationError.Register.wrongPhoneNumber
            }
                
        }
        guard let Password = Passowrd,  !Password.isEmpty, !Password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.Register.emptyPassword
        }
            
        if(!(Passowrd?.passwordMinLength)!){
            throw ValidationError.Register.MinLength
        }
            
        if(!(Passowrd?.checkTextSufficientComplexity())!){
            throw ValidationError.Register.weakPassword
        }
    }
        
        
//        guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.Register.emptyEmail
//        }

//        if(!(email?.isEmail)!){
//            print(email?.isEmail)
//            throw ValidationError.Register.wrongEmail
//        }
//
//        if(!(email?.emailMinLength)!){
//            throw ValidationError.Register.minEmailLength
//        }
//        guard let PhoneNumber = phoneNumber,  !PhoneNumber.isEmpty, !PhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.Register.emptyPhoneNumber
//        }
//
//        if(!(phoneNumber?.isNumber)!){
//            throw ValidationError.Register.wrongPhoneNum
//
//        }
//
//        if(!(phoneNumber?.phoneMinLength)!){
//            throw ValidationError.Register.minPhoneNumber
//        }
//        let isValidPhone = checkPhone(countryCode:countryCode , PhoneNumber: phoneNumber)
//        if(!isValidPhone){
//            throw ValidationError.Register.wrongPhoneNumber
//        }
//        guard let Password = Passowrd,  !Password.isEmpty, !Password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.Register.emptyPassword
//        }
//
//        if(!(Passowrd?.passwordMinLength)!){
//            throw ValidationError.Register.MinLength
//        }
//
//        if(!(Passowrd?.checkTextSufficientComplexity())!){
//            throw ValidationError.Register.weakPassword
//        }
        
        
        
    }
    
}

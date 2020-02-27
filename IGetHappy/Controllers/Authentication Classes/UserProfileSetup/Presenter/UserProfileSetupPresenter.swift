//
//  UserProfileSetupPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol UserProfileSetupDelegate : class {
    func UserProfileSetupDidSucceeed()
    func UserProfileSetupDidFailed()
}
class UserProfileSetupPresenter{
    //Register Delegate
    var delegate:UserProfileSetupDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var UserProfileSetupDelegateView: UserProfileSetupViewDelegate?
    
    init(delegate:UserProfileSetupDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: UserProfileSetupViewDelegate) {
        UserProfileSetupDelegateView = view
    }
    //Detaching login view
    func detachView() {
        UserProfileSetupDelegateView = nil
    }
    
    
    func continueSignup(email:String?,Passowrd:String?){
        
        parm["email"] = email
        parm["password"] = Passowrd
        RegisterService.sharedInstance.UserRegisterService(url: "", postDict: parm, completionResponse: { (UserData) in
            self.UserProfileSetupDelegateView?.hideLoader()
            self.delegate.UserProfileSetupDidSucceeed()
        }, completionnilResponse: { (message) in
            self.UserProfileSetupDelegateView?.hideLoader()
            self.UserProfileSetupDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.UserProfileSetupDelegateView?.hideLoader()
            self.UserProfileSetupDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
            self.UserProfileSetupDelegateView?.hideLoader()
            self.UserProfileSetupDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
    }
    
    
func Validations(fstName:String?,lstName:String?,nickName:String?,profileImg:Any?,profession:String?) throws{
        guard let FirstName = fstName,  !FirstName.isEmpty, !FirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.UserProfileSetup.emptyFirstName
        }
    if(!(FirstName.nameMinLength)){
        throw ValidationError.UserProfileSetup.MinLengthFirstName
    }
        guard let LastName = lstName,  !LastName.isEmpty, !LastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.UserProfileSetup.emptyLastName
        }
    if(!(LastName.nameMinLength)){
        throw ValidationError.UserProfileSetup.MinLengthLastName
    }
//        guard let NickName = nickName,  !NickName.isEmpty, !NickName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
//        {
//            throw ValidationError.UserProfileSetup.emptyNickName
//        }
    
    if (nickName?.isEmpty == false){
        if(nickName?.nameMinLength == false){
            throw ValidationError.UserProfileSetup.MinLengthNickName
        }
    }
    
//    if(!(NickName.nameMinLength)){
//        throw ValidationError.UserProfileSetup.MinLengthNickName
//    }
        guard let ProfileImg = profileImg,  ProfileImg != nil  else
        {
            throw ValidationError.UserProfileSetup.emptyProfileImage
        }
        guard let Profession = profession,  !Profession.isEmpty, !Profession.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.UserProfileSetup.emptyProfession
        }
        
    }
    
}

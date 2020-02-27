//
//  BeCaregiverPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol BeCaregiverDelegate : class {
    func BeCaregiverDidSucceeed()
    func BeCaregiverDidFailed()
   
}
class BeCaregiverPresenter {
    //Register Delegate
    var delegate:BeCaregiverDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var BeCaregiverDelegateView: BeCaregiverViewDelegate?
    
    init(delegate:BeCaregiverDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: BeCaregiverViewDelegate) {
        BeCaregiverDelegateView = view
    }
    //Detaching login view
    func detachView() {
        BeCaregiverDelegateView = nil
    }
    
    func uploadSignupData(){
        CompleteRegisterData.sharedInstance?.login_type = "NATIVE"
        
        parm["speciality"] = "TEST"
        parm["work_experience"] = "1"
        parm["first_name"] = CompleteRegisterData.sharedInstance?.first_name
        parm["last_name"] = CompleteRegisterData.sharedInstance?.last_name
        parm["nick_name"] = CompleteRegisterData.sharedInstance?.nick_name
        if (CompleteRegisterData.sharedInstance?.email?.trim().isEmpty == false){
             parm["email"] = CompleteRegisterData.sharedInstance?.email
        }
        parm["password"] = CompleteRegisterData.sharedInstance?.password
        //parm["role"] = CompleteRegisterData.sharedInstance?.role
        parm["role"] = "CLIENT"
        parm["language_preferences"] = CompleteRegisterData.sharedInstance?.language_preferences
        parm["profile_image"] = CompleteRegisterData.sharedInstance?.profile_image
        parm["login_type"] = CompleteRegisterData.sharedInstance?.login_type
        parm["gender"] = CompleteRegisterData.sharedInstance?.gender
        parm["phone"] = CompleteRegisterData.sharedInstance?.phone
        if let socialId  = UserDefaults.standard.getUserId(){
            CompleteRegisterData.sharedInstance?.social_id = socialId
        }
        parm["social_id"] = CompleteRegisterData.sharedInstance?.social_id
        parm["dob"] = CompleteRegisterData.sharedInstance?.dob
        parm["referral_code"] = CompleteRegisterData.sharedInstance?.referral_code
        parm["is_anonymous"] = CompleteRegisterData.sharedInstance?.isAnonymous
        parm["phone_code"] = "+91"
        var dataImage = UIImage()
        
        dataImage = (CompleteRegisterData.sharedInstance?.profile_image)!
        print(CompleteRegisterData.self)
        print(dataImage)
          self.BeCaregiverDelegateView?.showLoader()
        AuthenticationService.sharedInstance.UploadMultipartRegisterData(url: UrlStrings.Register.registerNewUser, postDict: parm,imageData:dataImage, completionResponse: { (RegisterCompleteMapper) in
            
            UserDefaults.standard.setLoggedIn(value: true)
            
            if let Id = RegisterCompleteMapper.data?._id{
                 UserDefaults.standard.setUserId(value: Id)
            }
           
            print(RegisterCompleteMapper.data?._id)
          
            if let name  =  RegisterCompleteMapper.data?.first_name {
                UserDefaults.standard.setFirstName(value: name)
            }
            
            if let name  = RegisterCompleteMapper.data?.last_name {
                UserDefaults.standard.setLastName(value: name)
            }

            
            if let profileImage = RegisterCompleteMapper.data?.profile_image{
                UserDefaults.standard.setProfileImage(value: profileImage)
            }
            
            
            if let isAnonymous  = RegisterCompleteMapper.data?.isAnonymous{
                 UserDefaults.standard.setAnonymous(value: isAnonymous)
            }
            
            if let userToken  = RegisterCompleteMapper.token{
                UserDefaults.standard.setAccessTokken(value: userToken)
            }
            
            
            self.BeCaregiverDelegateView?.hideLoader()
            self.delegate.BeCaregiverDidSucceeed()
        }, completionnilResponse: { (message) in
            
            
            
        self.BeCaregiverDelegateView?.clearDefaluts()
            self.BeCaregiverDelegateView?.hideLoader()
            self.BeCaregiverDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.BeCaregiverDelegateView?.hideLoader()
            self.BeCaregiverDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
            self.BeCaregiverDelegateView?.hideLoader()
            self.BeCaregiverDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
       
    }
    
}

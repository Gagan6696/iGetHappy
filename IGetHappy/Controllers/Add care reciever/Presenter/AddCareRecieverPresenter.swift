//
//  AddCareRecieverPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 7/8/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import Foundation
protocol AddCareRecieverDelegate : class {
    func AddCareRecieverDidSucceeed(careRecieverId:String, emailID: String)
    func AddCareRecieverDidFailed()
}
protocol DeleteCareRecieverDelegate : class {
    func DeleteCareRecieverDidSucceeed()
    func DeleteCareRecieverDidFailed()
}
class AddCareRecieverPresenter{
    //Register Delegate
    var delegate:AddCareRecieverDelegate
    var deleteCareDelegate:DeleteCareRecieverDelegate
    var parm = [String:Any]()
    
    // Login Controllers weak object to save from being retain cycle
    weak var addCareRecieverDelegateView: AddCareRecieverViewDelegate?
    
    init(delegate:AddCareRecieverDelegate,deleteCareDelegate:DeleteCareRecieverDelegate) {
        self.delegate = delegate
        self.deleteCareDelegate = deleteCareDelegate
    }
    
    //Attaching login view
    func attachView(view: AddCareRecieverViewDelegate) {
        addCareRecieverDelegateView = view
    }
    //Detaching login view
    func detachView() {
        addCareRecieverDelegateView = nil
    }
    
    func addCareReciever(careRecieverName: String?, phoneNumber: String?, emailAddress: String?, isMinor:String?, relationship:String?,profilePhoto:UIImage ){
        
        if let user_id = UserDefaults.standard.getUserId(){
            parm["care_giver_id"] = user_id
        }
        parm["first_name"] = careRecieverName
        parm["email"] = emailAddress
        parm["is_care_receiver_minor"] = isMinor
        parm["phone"] = phoneNumber
        parm["relationship"] = relationship
        parm["role"] = "CLIENT"
        print(parm)
        AuthenticationService.sharedInstance.UploadMultipartAddCareRecieverData(url: UrlStrings.AddCareReciever.careReceivers, postDict: parm, imageData:profilePhoto, completionResponse: { (AddCareRecieverData) in
            
            self.addCareRecieverDelegateView?.hideLoader()
            print(AddCareRecieverData.data?._id)
            self.delegate.AddCareRecieverDidSucceeed(careRecieverId: (AddCareRecieverData.data?._id)!, emailID: AddCareRecieverData.data?.email ?? "User")
        }, completionnilResponse: { (message) in
            self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
             self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: "\(error?.localizedDescription)")
        }) { (networkerror) in
            self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
        
    }
    func deleteCareRecieverById(careRecieverId:String?){
        self.addCareRecieverDelegateView?.showLoader()
        AuthenticationService.sharedInstance.DeleteCareRecieverService(url: careRecieverId!, completionResponse: { (message) in
            print(message)
            self.addCareRecieverDelegateView?.hideLoader()
            self.deleteCareDelegate.DeleteCareRecieverDidSucceeed()
        }, completionnilResponse: { (message) in
            print(message)
            self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
             self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: "\(error?.localizedDescription)")
        }) { (networkerror) in
             self.addCareRecieverDelegateView?.hideLoader()
            self.addCareRecieverDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
 
    }
    
    func Validations(careRecieverName:String?,phoneNumber:String?,emailAddress:String?,profilePic:UIImage?,relationship:String?) throws{
        var CareRecieverName:String?
        var PhoneNumber:String?
        var EmailAddress:String?
        
        CareRecieverName = careRecieverName!.trimmingCharacters(in: .whitespacesAndNewlines)
        PhoneNumber = phoneNumber!.trimmingCharacters(in: .whitespacesAndNewlines)
        EmailAddress = emailAddress!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        guard let CareRecieverName1 = CareRecieverName,  !CareRecieverName1.isEmpty, !CareRecieverName1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddCareReciever.emptyName
        }
        
        if(!(CareRecieverName1.nameMinLength)){
            throw ValidationError.AddCareReciever.MinLengthName
        }
        guard let PhoneNumber1 = PhoneNumber,  !PhoneNumber1.isEmpty, !PhoneNumber1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddCareReciever.emptyPhoneNumber
        }
        
        if(!((PhoneNumber1.isNumber))){
            throw ValidationError.AddCareReciever.validPhoneNumber
        }
        
        if(profilePic == nil){
            throw ValidationError.AddCareReciever.emptyProfilePic
        }
        
        if(!(PhoneNumber1.phoneMinLength)){
            throw ValidationError.AddCareReciever.phoneNumberMinLength
        }
        guard let EmailAddress1 = EmailAddress,  !EmailAddress1.isEmpty, !EmailAddress1.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddCareReciever.emptyEmail
        }
        if(!(EmailAddress1.emailMinLength)){
            throw ValidationError.AddCareReciever.emailMinLength
        }
        if(!(EmailAddress1.isEmail)){
            throw ValidationError.AddCareReciever.wrongEmail
        }
        guard let Relationship = relationship,  !Relationship.isEmpty, !Relationship.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AddCareReciever.emptyRelation
        }
    }
    
}

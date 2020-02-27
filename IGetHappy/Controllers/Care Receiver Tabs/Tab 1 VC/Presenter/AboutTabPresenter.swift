//
//  AboutTabPresenter.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

protocol AboutTabDelegate : class
{
    func AboutTabDidSucceeed(message:String?)
    func AboutTabDidFailed(message:String?)

}


class AboutTabPresenter
{
    //ABoutTab Delegate
    var delegate:AboutTabDelegate
    var parm = [String:Any]()
// AboutTab Controllers weak object to save from being retain cycle
    weak var aboutTabViewDelegate: AboutTabViewDelegate?
    
    init(delegate:AboutTabDelegate)
    {
        self.delegate = delegate
    }
    
    //Attaching ABoutTab view
    func attachView(view: AboutTabViewDelegate)
    {
        aboutTabViewDelegate = view
    }
    //Detaching AboutTab view
    func detachView()
    {
        aboutTabViewDelegate = nil
    }
    
    func updateCareRecieverProfile(careRecieverId:String,lastName:String?,firstName:String?,nickName:String?,email:String?,relationShip:String?,gender:String?){
        
        self.aboutTabViewDelegate?.showLoader()
        //Reminder
        let userId = UserDefaults.standard.getUserId() ?? ""
         parm["care_giver_id"] = userId
         parm["last_name"] = lastName
         parm["first_name"] = firstName
        parm["nick_name"] = nickName
         parm["email"] = email
         parm["relationship"] = relationShip
        parm["gender"] = gender
        
        
        let url =  UrlStrings.EditCareReciever.editCareReceivers + careRecieverId ?? ""
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .Image, urlMedia: nil, urlString: url, fileData: AboutTabVC.careReciverProfileImage, requestDict: parm, method: .patch, compBlock: { (responseDict, response) in
            if let message  = responseDict["message"] as? String
            {
                print(message)
                //self.HomeDelegateView?.hideLoader()
                self.delegate.AboutTabDidSucceeed(message: Constants.AboutTab.MessagesStrings.kupdatedSuccesfully)
            }
            
        }) { (networkError) in
            self.delegate.AboutTabDidFailed(message:Constants.Global.MessagesStrings.SomethingWentWrong)
            print(networkError)
        }
        
//
//        ServiceCall.sharedManager.serviceApi(url, requestDict: parm as [String : AnyObject], method: .patch, compBlock: { (response, dataResponse) in
//            if response["status"] as? Int == 200 {
//                if let dataDict = response["data"] as? [String : AnyObject] {
//                    print(dataDict)
//                    self.delegate.AboutTabDidSucceeed(message: Constants.AboutTab.MessagesStrings.kupdatedSuccesfully)
//
//                }
//            }else{
//                self.delegate.AboutTabDidFailed(message:Constants.Global.MessagesStrings.SomethingWentWrong)
//
//
//            }
//        }) { (error) in
//            print(error)
//            self.delegate.AboutTabDidFailed(message:Constants.Global.MessagesStrings.ServerError)
//           // completion(false,(error as? String ?? ""))
//        }
        
        
    }
    
    
    
    func Validations(firstName:String?,relationShip:String?, email:String?) throws
    {
        guard let FirstName = firstName,  !FirstName.isEmpty, !FirstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AboutTab.emptyFirstname
        }
        
        guard let RelationShip = relationShip,  !RelationShip.isEmpty, !RelationShip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AboutTab.emptyRelationship
        }
  
        guard let Email = email,  !Email.isEmpty, !Email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else
        {
            throw ValidationError.AboutTab.emptyEmail
        }
        
        if(!(email?.isEmail)!)
        {
            throw ValidationError.AboutTab.wrongEmail
        }
        
        if(!(email?.emailMinLength)!)
        {
            throw ValidationError.AboutTab.minEmailLength
        }
        
   
    }
    
}

//
//  SelectGenderPresnter.swift
//  IGetHappy
//
//  Created by Gagan on 7/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol SelectGenderDelegate : class {
    func SelectGenderDidSucceeed()
    func SelectGenderDidFailed()
}
class SelectGenderPresnter{
    //Register Delegate
    var delegate:SelectGenderDelegate
    var parm = [String:Any]()
    // Login Controllers weak object to save from being retain cycle
    weak var SelectGenderDelegateView: SelectGenderViewDelegate?
    
    init(delegate:SelectGenderDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: SelectGenderViewDelegate) {
        SelectGenderDelegateView = view
    }
    //Detaching login view
    func detachView() {
        SelectGenderDelegateView = nil
    }
   
    func continueGender(email:String?,Passowrd:String?){
        
        parm["email"] = email
        parm["password"] = Passowrd
        RegisterService.sharedInstance.UserRegisterService(url: "", postDict: parm, completionResponse: { (UserData) in
            self.SelectGenderDelegateView?.hideLoader()
            self.delegate.SelectGenderDidSucceeed()
        }, completionnilResponse: { (message) in
            self.SelectGenderDelegateView?.hideLoader()
            self.SelectGenderDelegateView?.showAlert(alertMessage: message)
        }, completionError: { (error) in
            print(error)
            self.SelectGenderDelegateView?.hideLoader()
            self.SelectGenderDelegateView?.showAlert(alertMessage: "\(error)")
        }) { (networkerror) in
            self.SelectGenderDelegateView?.hideLoader()
            self.SelectGenderDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }
        
    }
    
    func Validations(gender:String?,date_of_birth:String?) throws{
        guard let Gender = gender,  !Gender.isEmpty, !Gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidationError.SelectGender.selectGender
        }
        
        guard let DOB = date_of_birth,  !DOB.isEmpty, !DOB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
             throw ValidationError.SelectGender.selectDOB
        }
    }
}

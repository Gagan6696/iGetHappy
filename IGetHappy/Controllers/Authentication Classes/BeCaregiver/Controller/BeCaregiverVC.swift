//
//  BeCaregiverVC.swift
//  IGetHappy
//
//  Created by Gagan on 7/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol BeCaregiverViewDelegate:class {
    func clearDefaluts()
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
var goToHome =  Bool()
class BeCaregiverVC: BaseUIViewController {
    var presenter:BeCaregiverPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        goToHome  = true
        self.presenter = BeCaregiverPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func addCareReciver(_ sender: Any) {
         dismissKeyboardBeforeAction()
        goToHome = false
        self.presenter?.uploadSignupData()
       
    }
    
    @IBAction func goToDashboard(_ sender: Any) {
         dismissKeyboardBeforeAction()
         goToHome = true
         self.presenter?.uploadSignupData()
        
    }

}
extension BeCaregiverVC:BeCaregiverDelegate{
    
    func BeCaregiverDidSucceeed() {
        
        if(goToHome){
            
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectUserChatBot, Data: nil)
           // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ChatBot, Data: nil)
        }else{
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddCareReciever, Data: nil)
        }
    }
    func BeCaregiverDidFailed() {
        
    }
}
extension BeCaregiverVC:BeCaregiverViewDelegate{
    func clearDefaluts() {
        CommonFunctions.sharedInstance.clearUserDefaults()
        //self.clearUserDefaults()
        
    }
    func showAlert(alertMessage: String) {
       // self.showAlert(Message: alertMessage)
        self.AlertMessageWithOkAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Some error occured while signup. Please signup again.", Target: self) {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartUp, Data: nil)
        }
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

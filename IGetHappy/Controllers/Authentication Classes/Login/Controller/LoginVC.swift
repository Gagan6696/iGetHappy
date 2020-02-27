//
//  LoginVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import UIKit
import CountryPickerView
protocol LoginViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class LoginVC: BaseUIViewController
{
    var presenter:LoginPresenter?
    var phoneCode:String?
    @IBOutlet weak var txtfld_Email: CustomUITextField!
    @IBOutlet weak var txtfldPhoneNumber: UITextField!
    @IBOutlet weak var txtfld_Password: CustomUITextField!
    @IBOutlet weak var countryListView: CountryPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        countryListView.delegate = self
        countryListView.dataSource = self
        countryListView.showCountryCodeInView = false
        //Reminder
        
        self.hideKeyboardWhenTappedAround()
        if(self.navigationController != nil){
            self.HideNavigationBar(navigationController: self.navigationController!)
        }
        
        let code = getCountryCode()
        countryListView.setCountryByCode(code)
        let country = countryListView.selectedCountry
        phoneCode = country.phoneCode
        print(country.phoneCode)
        
        
        //self.setBackButton(title: "BAck")
        self.presenter = LoginPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // Do any additional setup after loading the view.
        
        
    }
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtfld_Email.text = nil
        self.txtfld_Password.text = nil
        
    }
    
    
    @IBAction func actionShowCountryList(_ sender: Any) {
        
   
            countryListView.showCountriesList(from: self)
        
        
    }
    
    @IBAction func Login(_ sender: Any)
    {
        self.dismissKeyboardBeforeAction()
        do {
            if(!(txtfld_Email.text?.isEmpty)! && !(txtfldPhoneNumber.text?.isEmpty)!)
            {
                self.view.makeToast("Please enter either email or phone number")
            }
            else
            {
                var finalText:String?
                if(!(txtfldPhoneNumber.text?.isEmpty)!)
                {
                    finalText = txtfldPhoneNumber.text
                }
                else
                {
                    finalText = txtfld_Email.text
                }
                try presenter?.Validations(email:finalText, Passowrd: self.txtfld_Password.text)
                if self.checkInternetConnection()
                {
                    self.presenter?.Login(email:finalText,Passowrd: self.txtfld_Password.text, phoneCode: phoneCode)
                    //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
                }
                else
                {
                    self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
                }
            }
            
        } catch let error {
            switch  error {
                
            case ValidationError.Login.emptyUserName:
                self.view.makeToast( Constants.Login.Validations.kemptyUserName)
                self.hideLoader()
            case ValidationError.Login.emptyPassword:
                self.view.makeToast(Constants.Login.Validations.kemptypassword)
                self.hideLoader()
            case ValidationError.Login.weakPassword:
                self.view.makeToast( Constants.Login.Validations.kweakPassword)
                self.hideLoader()
            case ValidationError.Login.MinLength:
                self.view.makeToast( Constants.Login.Validations.kminLength)
                self.hideLoader()
            case ValidationError.Login.emailMinLength:
                self.view.makeToast( Constants.Login.Validations.kemailMinLength)
                self.hideLoader()
            case ValidationError.Login.wrongEmail:
                self.view.makeToast(Constants.Login.Validations.kinvalidEmail)
                self.hideLoader()
            case ValidationError.Login.minPhoneNumber:
                self.view.makeToast(Constants.Login.Validations.kMinLengthPhone)
            case ValidationError.Login.invalidEmailPhone:
                self.view.makeToast(Constants.Login.Validations.kinvalidEmailPhone)
            default:
                self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
                self.hideLoader()
            }
        }
        
    }
    
    @IBAction func Forgot_Pwd(_ sender: Any) {
         self.dismissKeyboardBeforeAction()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Forgot, Data: nil)
    }
    @IBAction func Cancel(_ sender: Any) {
         self.dismissKeyboardBeforeAction()
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func Go_To_Signup(_ sender: Any) {
         self.dismissKeyboardBeforeAction()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Register, Data: nil)
        
    }
}

extension LoginVC:LoginDelegate
{
    func LoginDidSucceeed()
    {
        
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
    }
    
    func LoginDidFailed(message:String?) {
        //self.showAlert(alertMessage: )
    }
}

extension LoginVC:LoginViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader()
    {
        ShowLoaderCommon()
    }
    
    func hideLoader()
    {
        HideLoaderCommon()
    }
    
    
}

extension LoginVC : CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        let country = countryListView.selectedCountry
         phoneCode = country.phoneCode
        print(country.phoneCode)
    }
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?{
        return "Select a country"
    }
    
   
    
}

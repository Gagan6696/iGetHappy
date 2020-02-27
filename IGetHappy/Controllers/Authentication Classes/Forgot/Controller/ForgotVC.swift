//
//  ForgotVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/15/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import CountryPickerView

import SkyFloatingLabelTextField
protocol ForgotViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class ForgotVC: BaseUIViewController {
    var presenter:ForgotPresenter?
    var phoneCode:String?
    @IBOutlet weak var countryListView: CountryPickerView!
    @IBOutlet weak var txt_Email: UITextField!
    @IBOutlet weak var txt_phoneNumber: SkyFloatingLabelTextFieldWithIcon!
    override func viewDidLoad() {
        super.viewDidLoad()
        countryListView.delegate = self
        countryListView.dataSource = self
        countryListView.showCountryCodeInView = false
        
        let code = getCountryCode()
        countryListView.setCountryByCode(code)
        
        
       // countryListView.setCountryByCode("IN")
        self.hideKeyboardWhenTappedAround()
        self.HideNavigationBar(navigationController: self.navigationController!)
        //self.setBackButton(title: "BAck")
        self.presenter = ForgotPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        let country = countryListView.selectedCountry
        phoneCode = country.phoneCode
        
        // Do any additional setup after loading the view.
    }
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txt_Email.text = nil
       
    }
    @IBAction func backActn(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func actionShowCountryList(_ sender: Any) {
        countryListView.showCountriesList(from: self)
    }
    
    @IBAction func Continue(_ sender: Any) {
        
        do {
            if(!(txt_Email.text?.isEmpty)! && !(txt_phoneNumber.text?.isEmpty)!){
                print("please enter only in one feild")
            }else{
                var finalText:String?
                if(txt_phoneNumber.text?.isEmpty == false){
                    finalText = txt_phoneNumber.text
                }else{
                    finalText = txt_Email.text
                }
            
                try presenter?.Validations(email:finalText)
            if self.checkInternetConnection(){
                self.presenter?.Forgot(email:finalText, phCode: phoneCode ?? "+1")
                
            }else{
               self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
            }
        }
    } catch let error {
            switch  error {
            case ValidationError.Forgot.emptyEmail:
                self.view.makeToast(Constants.Forgot.Validations.kemptyEmail)
            case ValidationError.Forgot.emailMinLength:
                self.view.makeToast( Constants.Forgot.Validations.kemailMinLength)
            case ValidationError.Forgot.wrongEmail:
                 self.view.makeToast(Constants.Forgot.Validations.kinvalidEmail)
            case ValidationError.Login.minPhoneNumber:
                self.view.makeToast(Constants.Forgot.Validations.kinvalidPhone)
            default:
               self.view.makeToast(Constants.Global.MessagesStrings.ServerError)
            }
            self.hideLoader()
        }
        
    }
    
}

extension ForgotVC:ForgotDelegate{
    func ForgotDidSucceeed(message:String?) {
        self.hideLoader()
        self.AlertWithNavigatonPurpose(message: message!, navigationType: .pop, ViewController: .none, rootViewController: .none, Data: nil)
    }
    
    func ForgotDidFailed() {
        
    }
}

extension ForgotVC:ForgotViewDelegate{
    func showAlert(alertMessage: String) {
        self.showAlert(Message:alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
}
extension ForgotVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.characters.first == " "  && string == " "{
            
            // If consecutive spaces entered by user
            return false
        }
        else{
            // If no consecutive space entered by user
            var maxLength = 1
            if(textField == self.txt_Email){
                maxLength = 50
            }else{
                maxLength = 15
            }
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
    }
}
extension ForgotVC : CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        let country = countryListView.selectedCountry
        phoneCode = country.phoneCode
        print(country)
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?{
        return "Select a country"
    }
}

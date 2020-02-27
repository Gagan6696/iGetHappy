//
//  RegisterVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import AttributedTextView
import CountryPickerView
protocol RegisterViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}

class RegisterVC: BaseUIViewController {
    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var txtFld_Email: CustomUITextField!
    @IBOutlet weak var txt_phoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var txtFld_password: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var Terms: UIButton!
    @IBOutlet weak var attributedTextView: AttributedTextView!
    @IBOutlet weak var countryListView: CountryPickerView!
    var presenter:RegisterPresenter?
    var isTermsChecked:Bool = false
    var phoneCode:String?
    var countryCode :String?
    override func viewDidLoad() {
        super.viewDidLoad()
        countryListView.delegate = self
        countryListView.dataSource = self
        countryListView.showCountryCodeInView = false
        self.txtFld_Email.delegate = self
        self.txtFld_password.delegate = self
        self.txt_phoneNumber.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.HideNavigationBar(navigationController: self.navigationController!)
        self.presenter = RegisterPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.setAttributedText()
        countryCode = getCountryCode()
        countryListView.setCountryByCode(countryCode ?? "US")
        let country = countryListView.selectedCountry
        phoneCode = country.phoneCode
        print(country.phoneCode)
        //ountryListView.setCountryByCode("IN")
        
    }
    
    func setAttributedText() {
        attributedTextView.attributer = "I consent to the ".black
            .append("Terms & Conditions").makeInteract { _ in
               CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .TermsVC, Data: nil)
            }.underline
            .all.font(UIFont.systemFont(ofSize: 15))
            .setLinkColor(UIColor(red: 0.25, green: 0.66, blue: 0.89, alpha: 1))
    }
    
    @IBAction func termsButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            isTermsChecked = false
        }else{
             isTermsChecked = true
        }
    }
    
    @IBAction func Refrl_Code(_ sender: Any) {
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        
    }
    
    @IBAction func actionShowCountryList(_ sender: Any) {
        countryListView.showCountriesList(from: self)
    }
    
    @IBAction func backActn(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func Get_Started(_ sender: Any) {
         dismissKeyboardBeforeAction()
    do {
        try presenter?.Validations(email:self.txtFld_Email.text?.trim(), Passowrd: self.txtFld_password.text, phoneNumber:self.txt_phoneNumber.text?.trim(), countryCode: countryCode)
        if self.checkInternetConnection(){
       
            if isTermsChecked {
                if (self.txtFld_Email.text?.trim().isEmpty == false){
                    self.presenter?.CheckEmailExist(email:self.txtFld_Email.text)
                }else{
                    self.presenter?.CheckPhoneExist(phoneNum:self.txt_phoneNumber.text)
                }
            }else{
                self.view.makeToast(Constants.Register.MessagesStrings.KTermsCheked)
            }
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    } catch let error {
        switch  error {
        case ValidationError.Register.emptyEmailAndPhone:
            self.view.makeToast(Constants.Register.Validations.kemptyEmailAndPHone)
            self.hideLoader()
        case ValidationError.Register.emptyEmail:
            self.view.makeToast( Constants.Register.Validations.kemptyEmailId)
            self.hideLoader()
        case ValidationError.Register.emptyPhoneNumber:
            self.view.makeToast(Constants.Register.Validations.kemptyPhoneNumber)
            self.hideLoader()
        case ValidationError.Register.emptyPassword:
            self.view.makeToast(Constants.Register.Validations.kemptypassword)
            self.hideLoader()
        case ValidationError.Register.minPhoneNumber:
            self.view.makeToast(Constants.Register.Validations.kminLengthPhoneNumber)
            self.hideLoader()
        case ValidationError.Register.weakPassword:
            self.view.makeToast( Constants.Register.Validations.kweakPassword)
            self.hideLoader()
        case ValidationError.Register.MinLength:
            self.view.makeToast( Constants.Register.Validations.kminLength)
            self.hideLoader()
        case ValidationError.Register.wrongPhoneNumber:
            self.view.makeToast( Constants.Register.Validations.kwrongPhoneNumber)
            self.hideLoader()
        case ValidationError.Register.wrongEmail:
            self.view.makeToast(Constants.Register.Validations.kinvalidEmail)
            self.hideLoader()
        case ValidationError.Register.wrongPhoneNum:
            self.view.makeToast(Constants.Register.Validations.kinvalidPhone)
            self.hideLoader()
        case ValidationError.Register.minEmailLength:
            self.view.makeToast(Constants.Register.Validations.kemailMinLength)
            self.hideLoader()
        default:
            self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
            self.hideLoader()
            }
        }
    }
}

extension RegisterVC:RegisterDelegate{
    func RegisterPhoneDidSucceeed(message: String?) {
        self.hideLoader()
        self.showAlert(Message: message!)
    }
    
    func RegisterPhoneDidFailed(message: String?) {
        self.hideLoader()
        CompleteRegisterData.sharedInstance?.email = self.txtFld_Email.text
        
        CompleteRegisterData.sharedInstance?.password = self.txtFld_password.text
        CompleteRegisterData.sharedInstance?.phone = self.txt_phoneNumber.text
        //UserDefaults.standard.setFirstName(value: self.txtFld_Email.text ?? "")
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: nil)
    }
    
    func RegisterDidFailed(message: String?) {
        self.hideLoader()
        if (self.txt_phoneNumber.text?.trim().isEmpty == false){
            self.presenter?.CheckPhoneExist(phoneNum:self.txt_phoneNumber.text)
        }else{
            CompleteRegisterData.sharedInstance?.email = self.txtFld_Email.text
            CompleteRegisterData.sharedInstance?.password = self.txtFld_password.text
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .StartBegin, Data: nil)
        }
    }
    
    func RegisterDidSucceeed(message: String?) {
        self.hideLoader()
        self.showAlert(Message: message!)
    }
    
}

extension RegisterVC:RegisterViewDelegate
{
    func showAlert(alertMessage: String) {
        
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
}
extension RegisterVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFld_Email {
            txt_phoneNumber.becomeFirstResponder()
            
        } else if textField == txt_phoneNumber {
            txtFld_password.becomeFirstResponder()
            
        } else if textField == txtFld_password {
            txtFld_password.resignFirstResponder()
            
        }  else {
            txtFld_password.resignFirstResponder()
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == self.txt_phoneNumber){
            let charsLimit = 12
            
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            if(string.isNumeric == true || string == "")
            {
                return newLength <= charsLimit
            }
            else
            {
                return false
            }
            
            
        }else if textField.text == " " || string == " "  {
            return false
        }
        // Return true so the text field will be changed
        return true
    }
    
   
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txt_phoneNumber{
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            if(string == numberFiltered){
//                 var maxLength = 1
//                if(textField == self.txt_phoneNumber){
//                    maxLength = 10
//                }
//                let currentString: NSString = textField.text! as NSString
//                let newString: NSString =
//                    currentString.replacingCharacters(in: range, with: string) as NSString
//                return newString.length <= maxLength
//            }
//            return string == numberFiltered
//        }
//
//        if textField.text?.characters.first == " "  && string.contains(" "){
//            // If consecutive spaces entered by user
//            return false
//        }
//        else{
//            // If no consecutive space entered by user
//            var maxLength = 1
//            if(textField == self.txtFld_Email){
//                maxLength = 50
//            }else if(textField == self.txt_phoneNumber){
//                maxLength = 10
//            }else{
//                maxLength = 15
//            }
//            let currentString: NSString = textField.text! as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            return newString.length <= maxLength
//        }
//
//    }
}
extension RegisterVC : CountryPickerViewDelegate, CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country){
        let country = countryListView.selectedCountry
        phoneCode = country.phoneCode
        print(country)
    }
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?{
        return "Select a country"
    }
}


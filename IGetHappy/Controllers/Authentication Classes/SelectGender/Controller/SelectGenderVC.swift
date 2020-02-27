//
//  SelectGenderVC.swift
//  IGetHappy
//
//  Created by Gagan on 6/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import ADDatePicker
protocol SelectGenderViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class SelectGenderVC: BaseUIViewController {
    var presenter:SelectGenderPresnter?
    @IBOutlet weak var selectedTickM: UIImageView!
    @IBOutlet weak var seletedTickF: UIImageView!
    @IBOutlet weak var Male: UIImageView!
    @IBOutlet weak var Female: UIImageView!
    @IBOutlet weak var datePicker: ADDatePicker!
    var selctedGender:String?
    var selctedDOB:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.delegate = self
        self.presenter = SelectGenderPresnter.init(delegate: self)
        self.presenter?.attachView(view: self)
        selctedGender = "Male"
        self.hideKeyboardWhenTappedAround()
        let date = Calendar.current.date(byAdding: .year, value: -13, to: Date())
        let calendar = Calendar.current
        datePicker.yearRange(inBetween: 1920, end: calendar.component(.year, from: date!))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        selctedDOB = formatter.string(from: date!)
        
        datePicker.intialDate = date!
        datePicker.bgColor = .clear
        datePicker.deselectedBgColor = .clear
        datePicker.selectedBgColor = .lightGray
        datePicker.selectionType = .circle
        datePicker.selectedTextColor = .black
        datePicker.deselectTextColor = .lightGray
        prepareTapGesture()
        self.selectedTickM.isHidden = false
        self.seletedTickF.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.Female.transform = .init(scaleX: 0.7, y: 0.7)
            self.Male.transform = .init(scaleX: 1, y: 1)
        }
        // Do any additional setup after loading the view.
    }
    
    func prepareTapGesture() {
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(SelectGenderVC.tapFunction(sender:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(SelectGenderVC.tapFunction(sender:)))
        tapGesture1.numberOfTapsRequired = 1
        tapGesture2.numberOfTapsRequired = 1
        Male.addGestureRecognizer(tapGesture1)
        Female.addGestureRecognizer(tapGesture2)
        Male.tag = 1
        Female.tag = 2
        Male.isUserInteractionEnabled = true
        Female.isUserInteractionEnabled = true
    }
    
    @objc func tapFunction(sender: UITapGestureRecognizer) {
        if(sender.view?.tag == 1){
            self.selectedTickM.isHidden = false
            self.seletedTickF.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.selctedGender = "Male"
                self.selectedTickM.transform = .init(scaleX: 1, y: 1)
                self.seletedTickF.transform = .init(scaleX: 0.7, y: 0.7)
                self.Female.transform = .init(scaleX: 0.7, y: 0.7)
                 self.Male.transform = .init(scaleX: 1, y: 1)
            }
        }else {
            self.selectedTickM.isHidden = true
            self.seletedTickF.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.selctedGender = "Female"
                self.selectedTickM.transform = .init(scaleX: 0.7, y: 0.7)
                self.seletedTickF.transform = .init(scaleX: 1.0, y: 1.0)
                self.Male.transform = .init(scaleX: 0.7, y: 0.7)
                self.Female.transform = .init(scaleX: 1, y: 1)
               
            }
            
        }
        
        // show pop up
        
    }
    
   
    @IBAction func backAction(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func conitnue(_ sender: Any) {
        do {
             dismissKeyboardBeforeAction()
           try presenter?.Validations(gender: selctedGender, date_of_birth: selctedDOB)
            if self.checkInternetConnection(){
                //self.presenter?.Register(email:self.txtFld_Email.text,Passowrd: self.txtFld_Password.text)
                CompleteRegisterData.sharedInstance?.gender = selctedGender
                CompleteRegisterData.sharedInstance?.dob = selctedDOB
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .LanguagePreference, Data: nil)
            }else{
                 self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
            }
        } catch let error {
            switch  error {
                
            case ValidationError.SelectGender.selectGender:
                self.view.makeToast(Constants.SelectGender.Validations.kselectGender)
                self.hideLoader()
            case ValidationError.SelectGender.selectDOB:
                 self.view.makeToast(Constants.SelectGender.Validations.kselectDOB)
                self.hideLoader()
              
            default:
                self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
                self.hideLoader()
            }
        }
    }
}

extension SelectGenderVC:SelectGenderDelegate{
    func SelectGenderDidSucceeed() {
        
    }
    
    func SelectGenderDidFailed() {
        
    }
    
    
}
extension SelectGenderVC:SelectGenderViewDelegate{
    func showAlert(alertMessage: String) {
        
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
}

extension SelectGenderVC : ADDatePickerDelegate{
    func ADDatePicker(didChange date: Date) {
        selctedDOB = "\(date)"
    }
}

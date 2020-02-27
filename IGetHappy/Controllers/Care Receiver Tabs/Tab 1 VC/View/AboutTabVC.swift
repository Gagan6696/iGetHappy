//
//  AboutTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown

protocol AboutTabViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}

class AboutTabVC: BaseUIViewController,UITextFieldDelegate,UIScrollViewDelegate
{

    //MARK: <-OUTLETS ->
    
    @IBOutlet weak var lblRelationShip: UILabel!
    
    @IBOutlet weak var tf_FirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_LastName: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_NickName: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_BirthDate: SkyFloatingLabelTextField!
  //  @IBOutlet weak var tf_Relationship: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_FBID: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_EmailID: SkyFloatingLabelTextField!
   // @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnSave: PSCustomButton!
    
    
    //MARK: <- VARIABLES->
    @IBOutlet weak var btn_DropDown: UIButton!
    let dropDown = DropDown()
    var presenter:AboutTabPresenter?
    var gender = "male"
    var selectedCareRecieverData:CareReceiverDetail?
    static var careReciverProfileImage = UIImage()
    var arr_Category: [String] = [
        "Doctor",
        "Teacher",
        "Engineer"
    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tf_EmailID.text = selectedCareRecieverData?.email
        self.tf_LastName.text = selectedCareRecieverData?.last_name
        self.tf_NickName.text = selectedCareRecieverData?.nick_name
        self.tf_FirstName.text = selectedCareRecieverData?.first_name
        self.lblRelationShip.text = selectedCareRecieverData?.relationship
    
        //self.lblRelationShip.attributedText = NSAttributedString(string: selectedCareRecieverData?.relationship ?? arr_Category[0], attributes:
            //[.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.btnSave.cornerRadius = 10
        
        self.presenter = AboutTabPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            // The view to which the drop down will appear on
            self.dropDown.anchorView = self.lblRelationShip // UIView or UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = self.arr_Category
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                self.lblRelationShip.text = "\(item)"
                DropDown.startListeningToKeyboard()
            }
            
           // self.profile_Img.clipsToBounds = true
            
            
        }
    }
    
    
    
    override func viewDidLayoutSubviews()
    {
       //self.myScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    

    //MARK: <- TEXT FIELD DELEGATES ->
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    
    
    @IBAction func ACTION_MALE_SELECTED(_ sender: Any)
    {
        self.gender =  "male"
        self.btnMale.setImage(UIImage(named: "selecetdTick"), for: UIControl.State.normal)
        self.btnFemale.setImage(UIImage(named: "unselecetdTick"), for: UIControl.State.normal)
       
    }
    @IBAction func ACTION_FEMALE_SELECTED(_ sender: Any)
    {
        self.gender =  "female"
        self.btnMale.setImage(UIImage(named: "unselecetdTick"), for: UIControl.State.normal)
        self.btnFemale.setImage(UIImage(named: "selecetdTick"), for: UIControl.State.normal)
    }
    
    @IBAction func actionDropDown(_ sender: Any) {
        
        self.dropDown.show()
    
    }
    
    @IBAction func ACTION_SAVE(_ sender: Any){

    do {
        try presenter?.Validations(firstName: self.tf_FirstName.text, relationShip: self.lblRelationShip.text, email: self.tf_EmailID.text)
        
            if self.checkInternetConnection(){
           
                self.presenter?.updateCareRecieverProfile(careRecieverId: selectedCareRecieverData?._id ?? "", lastName: self.tf_LastName.text, firstName: self.tf_FirstName.text, nickName: self.tf_NickName.text, email: self.tf_EmailID.text, relationShip: self.lblRelationShip.text, gender: gender)
        
            }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    } catch let error {
        switch  error {
        case ValidationError.AboutTab.emptyFirstname:
            self.view.makeToast(Constants.AboutTab.Validations.kemptyFirstName)
            self.hideLoader()
        case ValidationError.AboutTab.emptyRelationship:
            self.view.makeToast(Constants.AboutTab.Validations.kemptyRelationship)
            self.hideLoader()
        case ValidationError.AboutTab.emptyEmail:
            self.view.makeToast(Constants.AboutTab.Validations.kemptyEmail)
            self.hideLoader()
        case ValidationError.AboutTab.wrongEmail:
            self.view.makeToast(Constants.AboutTab.Validations.kinvalidEmail)
            self.hideLoader()
        case ValidationError.AboutTab.minEmailLength:
            self.view.makeToast( Constants.AboutTab.Validations.kemailMinLength)
            self.hideLoader()
        
        default:
            self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
            self.hideLoader()
        }
    }
    
    
    }
    
}

extension AboutTabVC: AboutTabViewDelegate
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

extension AboutTabVC: AboutTabDelegate
{
    func AboutTabDidSucceeed(message: String?) {
        self.hideLoader()
        self.showAlert(alertMessage: message ?? "")
    }
    
    
    func AboutTabDidFailed(message: String?) {
        self.hideLoader()
        self.showAlert(alertMessage: message ?? "")
    }

}


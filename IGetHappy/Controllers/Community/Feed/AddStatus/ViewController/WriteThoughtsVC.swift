//
//  WriteThoughtsVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/31/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import DropDown
import Kingfisher
protocol WriteThoughtsViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class WriteThoughtsVC: BaseUIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lbl_profileName: UILabel!
    //    @IBOutlet weak var switch_anonymous: UISwitch!
    @IBOutlet weak var lbl_privacy: UILabel!
    @IBOutlet weak var txt_status: UITextView!
    @IBOutlet weak var toolView: UIView!
    //    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var anonymusButton: UIButton!
    
    var presenter:WriteThoughtsPresenter?
    let dropDown  = DropDown()
    var isAnonymous:String?
    var type:String?
    var selectedPostData: [Post]?
    var isEdit: Bool = false
    var selectedPostVents :AllVentsModelDetail?
    var isEditVents = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isAnonymous = UserDefaults.standard.getAnonymous()
        if isAnonymous == "YES"{
            anonymusButton.isSelected = false
        }else{
            anonymusButton.isSelected = true
        }
        
        
        //isAnonymous = "No"
        self.lbl_profileName.text = UserDefaults.standard.getFirstName()
        self.txt_status.delegate = self
        
        let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
        self.profileImage?.kf.indicatorType = .activity
        self.profileImage?.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        //        if let profileImage = UserDefaults.standard.getProfileImage(){
        //            self.profileImage.kf.setImage(with: URL.init(string: profileImage))
        //        }
        
        
        
        //type = "IMAGE"
        self.HideNavigationBar(navigationController: self.navigationController!)
        //self.setBackButton(title: "BAck")
        self.presenter = WriteThoughtsPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        DispatchQueue.main.async {
            self.dropDown.anchorView = self.privacyButton // UIView or UIBarButtonItem
            
            // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = ["PUBLIC","FRIENDS","ONLYME"]
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if (index == 1)
                {
                    CommonVc.AllFunctions.showAlert(message: "Friends feature is coming soon!", view: self, title: Constants.Global.ConstantStrings.KAppname)
                     self.lbl_privacy.text = "PUBLIC"
                }else{
                     self.lbl_privacy.text = item
                }
                
            }
            
            if self.selectedPostData?.first?.isEditingMode ?? false {
                self.isEdit = true
                self.txt_status.text = self.selectedPostData?.first?.postDescription
                
                self.lbl_privacy.text = self.selectedPostData?.first?.privacyOption
                if self.selectedPostData?.first?.isAnonymous == "YES"{
                    self.anonymusButton.isSelected = false
                }else{
                    self.anonymusButton.isSelected = true
                }
            }
            
            DropDown.startListeningToKeyboard()
        
            if self.isEditVents {
                self.txt_status.text = self.selectedPostVents?.desc
                self.lbl_privacy.text = self.selectedPostVents?.privacy_option
                if self.selectedPostData?.first?.isAnonymous == "YES"{
                    self.anonymusButton.isSelected = false
                }else{
                    self.anonymusButton.isSelected = true
                }
            }
            
            
        DropDown.startListeningToKeyboard()
        }
        //self.txt_status.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isEditVents = false
        self.selectedPostVents = nil
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func anonymusButtonAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            isAnonymous = "No"
        }
        else
        {
            isAnonymous = "Yes"
        }
    }
    
    @IBAction func ActionSend(_ sender: Any)
    {
        if (txt_status.text.count == 0 || txt_status.text.contains("Eg: I have a interview today"))
        {
            CommonVc.AllFunctions.showAlert(message: "Oops! Please write something to add a post.", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            do
            {
                var finalText = txt_status.text
                if(finalText!.contains("Eg: I have a interview today"))
                {
                    finalText = "iGetHappy:)"
                }
                try presenter?.Validations(postText: finalText, privacy: lbl_privacy.text, isAnonymous: isAnonymous)
                
                if self.checkInternetConnection()
                {
                    self.showLoader()
                    if isEdit
                    {
                        self.presenter?.editTextPost(postText: self.txt_status.text,
                                                     privacy: lbl_privacy.text,
                                                     isAnonymous: isAnonymous,
                                                     postID: (selectedPostData?.first?.postId)!)
                    }
                    else if (isEditVents)
                    {
                        self.presenter?.editTextPost(postText: self.txt_status.text,
                                                     privacy: lbl_privacy.text,
                                                     isAnonymous: isAnonymous,
                                                     postID: (selectedPostVents?._id ?? ""))
                    }
                    else
                    {
                        self.presenter?.AddTextPost(postText: self.txt_status.text, privacy: lbl_privacy.text, isAnonymous: isAnonymous)
                    }
                }
                else
                {
                    self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
                }
                
                
            } catch let error {
                switch  error {
                    
                case ValidationError.AddPost.emptyText:
                    self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyText)
                    self.hideLoader()
                case  ValidationError.AddPost.emptyPrivacy:
                    self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyPrivacy)
                    self.hideLoader()
                case  ValidationError.AddPost.emptyisAnonymous:
                    self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyisAnonymous)
                    self.hideLoader()
                case  ValidationError.AddPost.textMaxLength:
                    self.view.makeToast(Constants.WriteThoughts.Validations.KMaxtextLength)
                    self.hideLoader()
                    
                default:
                    self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
                    self.hideLoader()
                }
            }
        }
   
    }
    
    @IBAction func ActionSelectprivacy(_ sender: Any) {
        dropDown.show()
    }
}

extension WriteThoughtsVC:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if isEdit{
            
        }else{
            if(self.txt_status.text.contains("Eg: I have a interview today")){
                self.txt_status.text = nil
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txt_status.text.isEmpty{
            txt_status.text = "Eg: I have a interview today"
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 100
    }
}

extension WriteThoughtsVC:WriteThoughtsDelegate
{
    func WriteThoughtsDidSucceeed(message: String?)
    {
        hideLoader()
       // self.showAlert(alertMessage: message!)
        self.AlertWithNavigatonPurpose(message: message!, navigationType: .pop, ViewController: .none, rootViewController: .none, Data: nil)
    }
    
    
    func WriteThoughtsDidFailed(message: String?)
    {
        hideLoader()
        print(message as Any)
    }
    
    
}

extension WriteThoughtsVC:WriteThoughtsViewDelegate
{
    func showAlert(alertMessage: String)
    {
        hideLoader()
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

//
//  UserProfileSetupVC.swift
//  IGetHappy
//
//  Created by Gagan on 6/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import DropDown
protocol UserProfileSetupViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
class UserProfileSetupVC: BaseUIViewController {
    
    @IBOutlet weak var txtfldProfession: UITextField!
    @IBOutlet weak var btnSwitch: UIButton!
    
    @IBOutlet weak var txtfldFstname: CustomUITextField!
    
    @IBOutlet weak var txtfldLastname: CustomUITextField!
    @IBOutlet weak var txtfldNickname: CustomUITextField!
    
    @IBOutlet weak var profile_Img: UIImageView!
    var presenter:UserProfileSetupPresenter?
    
    @IBOutlet weak var tap_Camera: CustomButton!
    @IBOutlet weak var avtars_List: UICollectionView!
    
    @IBOutlet weak var btn_DropDown: UIButton!
    let dropDown = DropDown()
    @IBOutlet weak var lbl_SelectedCat: UILabel!
    //MARK: - UIImagePickerController
    private var imagePicker =  UIImagePickerController()
    var arrAvatrs: [UIImage] = [
        UIImage(named: "profile_man1")!,
        UIImage(named: "profile_man2")!,
        UIImage(named: "profile_angel")!,
        UIImage(named: "profile_armuffs")!,
        
        UIImage(named: "AdultGirlFace")!,
        UIImage(named: "ChildFaceBoy")!,
        UIImage(named: "ChildGirlFace")!,
        UIImage(named: "YoungGirlFace")!,
        
        UIImage(named: "profile_elf")!
    ]
    var arr_Category: [String] = [
        "Doctor",
        "Teacher",
        "Engineer",
        "Other"
            ]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setupData()
        CompleteRegisterData.sharedInstance?.isAnonymous = "No"
        //let dropDown = DropDown()
        DispatchQueue.main.async {
        // The view to which the drop down will appear on
            self.dropDown.anchorView = self.lbl_SelectedCat // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = self.arr_Category
        
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
                if (index == 3){
                    self.txtfldProfession.isHidden = false
                    self.lbl_SelectedCat.isHidden = true
                }else{
                    self.txtfldProfession.isHidden = true
                    self.lbl_SelectedCat.isHidden = false
                    self.lbl_SelectedCat.text = "\(item)"
                }
                
            
             DropDown.startListeningToKeyboard()
        }
        
        self.profile_Img.clipsToBounds = true
        
       
        }
        self.txtfldFstname.delegate = self
        self.txtfldLastname.delegate = self
        self.txtfldNickname.delegate  = self
        self.presenter = UserProfileSetupPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.avtars_List.delegate = self
        self.avtars_List.dataSource = self
    }
    
    @IBAction func openCamera(_ sender: Any) {
        self.addImageOptions()
    }
    
    @IBAction func backActn(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from:self)
    }
    
    @IBAction func qustionAction(_ sender: Any) {
        self.view.makeToast("Your name will not be displayed to the community Users in the App. It will be displayed as Anonymous")
    }
    
    @IBAction func actionBtnSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            CompleteRegisterData.sharedInstance?.isAnonymous = "Yes"
        }else{
            CompleteRegisterData.sharedInstance?.isAnonymous = "No"
        }
    }
    
    @IBAction func Continue(_ sender: Any) {
        view.endEditing(true)
        do {
            let profession:String?
            if (txtfldProfession.isHidden != true){
                profession = txtfldProfession.text
            }else{
                profession = lbl_SelectedCat.text
            }
            try presenter?.Validations(fstName: self.txtfldFstname.text, lstName: self.txtfldLastname.text, nickName: self.txtfldNickname.text,profileImg: self.profile_Img, profession:profession)
           
            if self.checkInternetConnection(){
                
                //self.presenter?.Register(email:self.txtFld_Email.text,Passowrd: self.txtFld_Password.text)
                UserDefaults.standard.setFirstName(value: self.txtfldFstname.text!)
                UserDefaults.standard.setLastName(value: self.txtfldLastname.text!)
                //UserDefaults.standard.setNickName(value: self.txtfldNickname.text!)
                CompleteRegisterData.sharedInstance?.first_name = self.txtfldFstname.text
                CompleteRegisterData.sharedInstance?.last_name = self.txtfldLastname.text
                CompleteRegisterData.sharedInstance?.nick_name = self.txtfldNickname.text
                CompleteRegisterData.sharedInstance?.profile_image = self.profile_Img.image
                CompleteRegisterData.sharedInstance?.role = self.lbl_SelectedCat.text
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectGender, Data: nil)
            }else{
                self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
            }
        } catch let error {
            switch  error {
            case ValidationError.UserProfileSetup.emptyFirstName:
                 self.view.makeToast(Constants.UserProfileSetup.Validations.kemptyFirstName)
                self.hideLoader()
            case  ValidationError.UserProfileSetup.MinLengthFirstName:
                self.view.makeToast(Constants.UserProfileSetup.Validations.kminLengthFirst)
                self.hideLoader()
            case  ValidationError.UserProfileSetup.MinLengthLastName:
                  self.view.makeToast(Constants.UserProfileSetup.Validations.kminLengthLast)
                self.hideLoader()
            case  ValidationError.UserProfileSetup.MinLengthNickName:
                self.view.makeToast(Constants.UserProfileSetup.Validations.kminLengthNick)
                self.hideLoader()
            case ValidationError.UserProfileSetup.emptyLastName:
                 self.view.makeToast(Constants.UserProfileSetup.Validations.kemptyLastName)
                self.hideLoader()
            case ValidationError.UserProfileSetup.emptyNickName:
                 self.view.makeToast(Constants.UserProfileSetup.Validations.kemptyNickName)
                self.hideLoader()
            case ValidationError.UserProfileSetup.emptyProfession:
                 self.view.makeToast(Constants.UserProfileSetup.Validations.kemptyProfession)
            case ValidationError.UserProfileSetup.emptyProfileImage:
                 self.view.makeToast(Constants.UserProfileSetup.Validations.kemptyProfilePhoto)
                 self.hideLoader()
            default:
               self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
                self.hideLoader()
            }
        }
    }
    
    @IBAction func Actn_DropDown(_ sender: UIButton) {
       // self.hideKeyboardWhenTappedAround()
        dropDown.show()
    }
    
    func setupData(){
        self.txtfldProfession.isHidden = true
        self.lbl_SelectedCat.isHidden = false
        
        if let firstName = UserDefaults.standard.getFirstName(){
            let substring = trimTextfeildData(modifyString: firstName)
            self.txtfldFstname.text = "\(substring ?? "")"
            
        }
        if let lastName = UserDefaults.standard.getLastName(){
            let substring = trimTextfeildData(modifyString: lastName)
            self.txtfldLastname.text = "\(substring ?? "")"
           
        }
//        if let nickName = UserDefaults.standard.getNickname(){
//            let substring = trimTextfeildData(modifyString: nickName)
//            self.txtfldNickname.text = "\(substring ?? "")"
//
//        }
    }
   
}
extension UserProfileSetupVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAvatrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let indentifier = "PickAvatar"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! UserProfileCVC
        print(arrAvatrs[indexPath.row])
        print(cell.imgView_Avtars)
        cell.imgView_Avtars.image = arrAvatrs[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.profile_Img.image = arrAvatrs[indexPath.row]
            // Replace with count of your data for collectionViewA
       
    }
    
}
extension UserProfileSetupVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let indentifier = "CategoryTVC"
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifier, for: indexPath) as! UserProfileCategoryTVC
        cell.lbl_Category.text = arr_Category[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.lbl_SelectedCat.text = arr_Category[indexPath.row]
        
    }
    
}
extension UserProfileSetupVC:UserProfileSetupDelegate{
    func UserProfileSetupDidSucceeed() {
        
    }
    
    func UserProfileSetupDidFailed() {
        
    }
    
    
}
extension UserProfileSetupVC:UserProfileSetupViewDelegate{
    func showAlert(alertMessage: String) {
        
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}


extension UserProfileSetupVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtfldFstname {
            txtfldLastname.becomeFirstResponder()
            
        } else if textField == txtfldLastname {
            txtfldNickname.becomeFirstResponder()
            
        } else if textField == txtfldNickname {
            txtfldNickname.resignFirstResponder()
            
        }  else {
            txtfldNickname.resignFirstResponder()
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField.text?.characters.first == " "  && string == " "{
            return false
        }
        else{

        let maxLength = 20

        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        }
    }
}


extension UserProfileSetupVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                // choose a name for your image
                let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
                // create the destination file url to save your image
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // get your UIImage jpeg data representation and check if the destination file url already exists
                if let data = pickedImage.jpegData(compressionQuality: 1.0),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                       
                        self.profile_Img.image = pickedImage
                         self.profile_Img.setRounded()
                        //print("file saved")
                    } catch {
                        //print("error saving file:", error)
                    }
                }
        }else{
           
        }
        dismiss(animated: true)
    }
}

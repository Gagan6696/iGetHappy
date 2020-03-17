//
//  AddCareRecieverVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/28/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import UIKit
protocol AddCareRecieverViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}

var lastSelectedIndexForDelete:Int?
class AddCareRecieverVC: BaseUIViewController {
    
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var txt_emailAddress: CustomUITextField!
    @IBOutlet weak var txt_phoneNumber: CustomUITextField!
    @IBOutlet weak var txt_careRecieverName: CustomUITextField!
    @IBOutlet weak var selctd_Contacts: UICollectionView!
    @IBOutlet weak var select_Avatrs: UICollectionView!
    @IBOutlet weak var select_Relation: UICollectionView!
    @IBOutlet weak var selced_img: UIImageView!
    var selctdcontact_Arr = [UIImage]()
    var storedCareRecieverId = [String]()
    var presenter:AddCareRecieverPresenter?
    var selcted_avatar:UIImage!
    var selectedIndex:Int = -1
    var relationship:String?
    var isMinor:String?
    var isLegalGuardian:Bool? = false
    var delegate:AddActivityWithMoodVC?
    var logoImage: [UIImage] = [
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
    var arr_Relations: [String] = [
        "Father",
        "Mother",
        "Spouse",
        "Brother",
        "Sister",
        "Relative",
        "Friend"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selcted_avatar = UIImage.init(named: "userProfileSetupAvtar1")
        isMinor = "YES"
        isLegalGuardian = false
        relationship  = ""
        btnYes.setImage(#imageLiteral(resourceName: "addCareRecieverSelect"), for: .normal)
        btnNo.setImage(#imageLiteral(resourceName: "addCareRecieverUnselect"), for: .normal)
        btnNo.centerTextAndImage(spacing: 10.0)
        btnYes.centerTextAndImage(spacing: 10.0)
        selctdcontact_Arr.removeAll()
        //self.HideNavigationBar(navigationController: self.navigationController!)
        self.select_Avatrs.delegate = self
        self.select_Relation.delegate = self
        self.select_Relation.dataSource = self
        self.selctd_Contacts.delegate = self
        self.select_Avatrs.dataSource = self
        self.selctd_Contacts.dataSource = self
        self.presenter = AddCareRecieverPresenter.init(delegate: self, deleteCareDelegate: self)
    //    self.hideKeyboardWhenTappedAround()
        self.presenter?.attachView(view: self)
        isMinor = "YES"
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        
        if let vc = self.navigationController?.getPreviousViewController() {
            if vc is BeCaregiverVC{
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
            }else{
                if vc is AddActivityWithMoodVC {
                    if (delegate != nil){
                         CommonFunctions.sharedInstance.popTocontroller(from:self)
                        delegate?.openPopup()
                    }
                }else{
                     CommonFunctions.sharedInstance.popTocontroller(from:self)
                }
            }
        }
    }
    
    @IBAction func actionOpenCamera(_ sender: Any) {
        self.addImageOptions()
        
    }
    
    @IBAction func btnYesAction(_ sender: UIButton) {
        print(sender.isSelected)
        if sender.tag == 0{
            
            
            if(relationship == "Father" || relationship == "Mother" ){
                
                self.AlertMessageWithOkCancelAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Are you a legal guardian?", Target: self) { (message) in
                    if(message == "Yes"){
                        self.btnYes.setImage(#imageLiteral(resourceName: "addCareRecieverSelect"), for: .normal)
                        self.btnNo.setImage(#imageLiteral(resourceName: "addCareRecieverUnselect"), for: .normal)
                        self.isMinor = "YES"

                        self.select_Relation.reloadData()
                        self.isLegalGuardian = true
                    }else{
                        self.selectedIndex = -1
                         self.isMinor = "NO"
                        self.select_Relation.reloadData()
                        self.showAlert(alertMessage: "Sorry! You are  not authorized to add care reciever. You should be a legal guardian")
                    }
                }
            }else{
              //  btnYes.setImage(#imageLiteral(resourceName: "addCareRecieverUnselect"), for: .normal)
               // btnNo.setImage(#imageLiteral(resourceName: "addCareRecieverSelect"), for: .normal)
                isMinor = "NO"
                isLegalGuardian = false
                self.showAlert(alertMessage: "Sorry! You are  not authorized to add care reciever.")
            }
            
        }else{
            btnYes.setImage(#imageLiteral(resourceName: "addCareRecieverUnselect"), for: .normal)
            btnNo.setImage(#imageLiteral(resourceName: "addCareRecieverSelect"), for: .normal)
            isMinor = "NO"
        }
    }
    
    @IBAction func save(_ sender: Any)
    {
        
        //        if let vcs = self.navigationController?.viewControllers
        //        {
        //            let previousVC = vcs[vcs.count - 2]
        //            if previousVC is AddActivityWithMoodVC
        //            {
        //                CommonFunctions.sharedInstance.popTocontroller(from: self)
        //            }
        //            else if previousVC is CareReceiverVC
        //            {
        //                CommonFunctions.sharedInstance.popTocontroller(from: self)
        //            }
        //            else
        //            {
        //                if(selctdcontact_Arr.count == 0)
        //                {
        //
        //                    self.AlertMessageWithOkCancelAction(titleStr: "IGetHappy", messageStr: "Do you want to continue without adding care receiver", Target: self) { (message) in
        //                        if(message == "Yes")
        //                        {
        //                            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectUserChatBot, Data: nil)
        //                        }
        //                    }
        //                    //self.AlertMessageWithOkAction(titleStr:"IGetHappy", messageStr: "Do you want to continue without adding carereceiver", Target: self) {
        //                }
        //                else
        //                {
        //                    CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectUserChatBot, Data: nil)
        //                }
        //            }
        //        }
//
//                if(selcted_avatar == nil){
//                    //self.view.makeToast("please fill data")
//                }else{
//                    selctdcontact_Arr.append(self.selcted_avatar)
//                    self.selcted_avatar = nil
//                    self.selctd_Contacts.reloadData()
//                }
        
        do{
            try presenter?.Validations(careRecieverName: self.txt_careRecieverName.text, phoneNumber: self.txt_phoneNumber.text, emailAddress: self.txt_emailAddress.text, profilePic: self.selced_img.image, relationship: relationship)
            
            if self.checkInternetConnection()
            {
                view.endEditing(true)
                self.presenter?.addCareReciever(careRecieverName: self.txt_careRecieverName.text, phoneNumber: self.txt_phoneNumber.text, emailAddress: self.txt_emailAddress.text, isMinor: isMinor, relationship: relationship, profilePhoto:self.selced_img.image ?? UIImage.init(named: "")!)
            }
            else
            {
                self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
            }
            
        }
        catch let error
        {
            switch  error
            {
                
            case ValidationError.AddCareReciever.emptyName:
                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyName)
                self.hideLoader()
            case  ValidationError.AddCareReciever.MinLengthName:
                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthName)
                self.hideLoader()
            case  ValidationError.AddCareReciever.emptyPhoneNumber:
                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyPhoneNumber)
                self.hideLoader()
            case  ValidationError.AddCareReciever.phoneNumberMinLength:
                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthPhoneNumber)
                self.hideLoader()
            case ValidationError.AddCareReciever.emptyEmail:
                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyEmail)
                self.hideLoader()
            case ValidationError.AddCareReciever.emptyRelation:
                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyRelation)
                self.hideLoader()
                
            case ValidationError.AddCareReciever.emailMinLength:
                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthEmail)
                self.hideLoader()
            case ValidationError.AddCareReciever.wrongEmail:
                self.view.makeToast(Constants.AddCareReciever.Validations.KWrongEmail)
                self.txt_emailAddress.text = nil
                
            case ValidationError.AddCareReciever.validPhoneNumber:
                self.view.makeToast(Constants.AddCareReciever.Validations.KInvalidPhoneNum)
                self.txt_phoneNumber.text = nil
            default:
                self.view.makeToast(Constants.Global.MessagesStrings.ServerError)
                self.hideLoader()
            }
        }
        
    }
    
    //Go to next screen
    @IBAction func Add_More(_ sender: Any)
    {
        view.endEditing(true)
        if let vcs = self.navigationController?.viewControllers
                {
                    let previousVC = vcs[vcs.count - 2]
                    if previousVC is AddActivityWithMoodVC
                    {
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                    }
                    else if previousVC is CareReceiverVC
                    {
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                    }
                    else
                    {
                        if(selctdcontact_Arr.count == 0)
                        {
        
                            self.AlertMessageWithOkCancelAction(titleStr: "IGetHappy", messageStr: "Do you want to continue without adding care receiver", Target: self) { (message) in
                                if(message == "Yes")
                                {
                                    CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectUserChatBot, Data: nil)
                                }
                            }
                            //self.AlertMessageWithOkAction(titleStr:"IGetHappy", messageStr: "Do you want to continue without adding carereceiver", Target: self) {
                        }
                        else
                        {
                            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SelectUserChatBot, Data: nil)
                        }
                    }
                }
        
        
        //        if(selcted_avatar == nil){
        //            //self.view.makeToast("please fill data")
        //        }else{
        //            selctdcontact_Arr.append(self.selcted_avatar)
        //            self.selcted_avatar = nil
        //            self.selctd_Contacts.reloadData()
        //        }
        
//        do{
//            try presenter?.Validations(careRecieverName: self.txt_careRecieverName.text, phoneNumber: self.txt_phoneNumber.text, emailAddress: self.txt_emailAddress.text, profilePic: self.selced_img.image)
//
//            if self.checkInternetConnection()
//            {
//                //let profileImage = UIImage()
//                //                if let image = self.selced_img.image{
//                //                     profileArray.append(image)
//                //                }
//
//
//
//                //                if(isMinor == "YES" && relationship == "Father" || relationship == "Mother"){
//                //
//                //
//                //                    self.AlertMessageWithOkAction(titleStr: "", messageStr: "Are you a legal guardian?", Target: self) {
//                //                        self.presenter?.addCareReciever(careRecieverName: self.txt_careRecieverName.text, phoneNumber: self.txt_phoneNumber.text, emailAddress: self.txt_emailAddress.text, isMinor: self.isMinor, relationship: self.relationship, profilePhoto:self.selced_img.image ?? UIImage.init(named: "")!)
//                //
//                //                        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
//                //                    }
//                //
//                //                }else{
//                self.presenter?.addCareReciever(careRecieverName: self.txt_careRecieverName.text, phoneNumber: self.txt_phoneNumber.text, emailAddress: self.txt_emailAddress.text, isMinor: isMinor, relationship: relationship, profilePhoto:self.selced_img.image ?? UIImage.init(named: "")!)
//
//                //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
//                // }
//            }
//            else
//            {
//                self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
//            }
//
//        }
//        catch let error {
//            switch  error {
//
//            case ValidationError.AddCareReciever.emptyName:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyName)
//                self.hideLoader()
//            case  ValidationError.AddCareReciever.MinLengthName:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthName)
//                self.hideLoader()
//            case  ValidationError.AddCareReciever.emptyPhoneNumber:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyPhoneNumber)
//                self.hideLoader()
//            case  ValidationError.AddCareReciever.phoneNumberMinLength:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthPhoneNumber)
//                self.hideLoader()
//
//            case ValidationError.AddCareReciever.emptyEmail:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KEmptyEmail)
//                self.hideLoader()
//            case ValidationError.AddCareReciever.emailMinLength:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KMinLengthEmail)
//                self.hideLoader()
//            case ValidationError.AddCareReciever.wrongEmail:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KWrongEmail)
//                self.txt_emailAddress.text = nil
//
//            case ValidationError.AddCareReciever.validPhoneNumber:
//                self.view.makeToast(Constants.AddCareReciever.Validations.KInvalidPhoneNum)
//                self.txt_phoneNumber.text = nil
//            default:
//                self.view.makeToast(Constants.Global.MessagesStrings.ServerError)
//                self.hideLoader()
//            }
//        }
        
    }
    
    @objc func editButtonTapped(sender : UIButton) {
        lastSelectedIndexForDelete = sender.tag
        //        selctdcontact_Arr.remove(at: sender.tag)
        //        self.selctd_Contacts.reloadData()
        self.presenter?.deleteCareRecieverById(careRecieverId: storedCareRecieverId[sender.tag])
        
        
    }
    
    func clearTextfeilds(){
        self.txt_phoneNumber.text = nil
        self.txt_emailAddress.text = nil
        self.txt_careRecieverName.text = nil
    }
    
    
}
extension AddCareRecieverVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.selctd_Contacts {
            return selctdcontact_Arr.count // Replace with count of your data for collectionViewA
        }else if( collectionView == select_Relation){
            return arr_Relations.count
        }
        return logoImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.selctd_Contacts {
            let indentifier = "SelectedAvtars"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! SelectedContactsCVC
            
            cell.img_View_Avatrs.image = selctdcontact_Arr[indexPath.row]
            let currentrow = indexPath.row
            let editButton = UIButton(frame: CGRect(x:20, y:5, width:15,height:15))
            
            editButton.setImage(UIImage(named: "addCareRecieverCancel"), for: UIControl.State.normal)
            editButton.tag = currentrow
            
            editButton.addTarget(self,action:#selector(editButtonTapped),
                                 for:UIControl.Event.touchUpInside)
            
            //editButton.addTarget(self, action: #selector(self.editButtonTapped(sender: editButton)), for: UIControl.Event.touchUpInside)
            //editButton.addTarget(self, action: #selector(self.editButtonTapped(row: currentrow)), for: UIControl.Event.touchUpInside)
            cell.addSubview(editButton)
            cell.bringSubviewToFront(editButton)
            return cell
            // Replace with count of your data for collectionViewA
        }else if (collectionView == select_Relation){
            let indentifier = "SelectRealtion"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! ListRelationCVC
            //DispatchQueue.main.async {
            if(self.selectedIndex == indexPath.row){
                cell.SetupView(item: arr_Relations[indexPath.row], isSelected: true)
            }else{
                cell.SetupView(item: arr_Relations[indexPath.row], isSelected: false)
            }
            return cell
        }
            
        else
        {
            
            let indentifier = "SelectAvtars"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath) as! ListAvtarsCVC
            
            if(!logoImage.isEmpty){
                cell.imgview_listAvatrs.image = logoImage[indexPath.row]
            }
            return cell
            
        }
        
        
        return UICollectionViewCell.init()
        // Replace with count of your data for collectionViewB
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.select_Avatrs {
            
            self.selcted_avatar = logoImage[indexPath.row]
            selced_img.image = logoImage[indexPath.row]
            
            // Replace with count of your data for collectionViewA
        }else{
            if selectedIndex != indexPath.row {
                selectedIndex = indexPath.row
                relationship = arr_Relations[indexPath.row]
                if(isMinor == "YES"){
                    if(relationship == "Father" || relationship == "Mother"){
                        self.AlertMessageWithOkCancelAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Are you a legal guardian?", Target: self) { (message) in
                            if(message == "Yes"){
                                self.select_Relation.reloadData()
                                self.isLegalGuardian = true
                            }else{
                                self.selectedIndex = -1
                                self.select_Relation.reloadData()
                                self.showAlert(alertMessage: "Sorry! You are  not authorized to add care reciever. You should be a legal guardian")
                            }
                        }
                    }else{
                        self.showAlert(alertMessage: "Sorry! You are  not authorized to add care reciever. You should be a legal guardian")
                        self.selectedIndex = -1
                        self.select_Relation.reloadData()
                    }
                    
                }
            }
            select_Relation.reloadData()
        }
    }
}

extension AddCareRecieverVC:AddCareRecieverViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
}


extension AddCareRecieverVC:AddCareRecieverDelegate
{
    func AddCareRecieverDidSucceeed(careRecieverId: String, emailID: String)
    {
        let customAlertView = CustomAlert.instanceFromNib()
        customAlertView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        customAlertView.frame = self.view.bounds
        customAlertView.delegate = self
        
        if(isMinor == "NO")
        {
           // customAlertView.alertMessageLabel.text = "An email has been sent to " + emailID + " for consent."
            let string1 = self.txt_careRecieverName.text ?? ""
            let string2 = "has been added as a Care-Receiver and an email sent to"
            let string3 = emailID
            let string4 = "for consent. Please click Yes if you want to add another Care-Receiver or No to continue without adding another Care-Receiver"
            
//
//            customAlertView.alertMessageLabel.text = self.txt_careRecieverName.text ??
//                "" + "has been added as a Care-Receiver and an email sent to" + emailID + "for consent. Please click “Yes” if you want to add another Care-Receiver or “No” to continue without adding another Care-Receiver"
            
             customAlertView.alertMessageLabel.text = "\(string1) \(string2) \(string3) \(string4)"
            
             print(customAlertView.alertMessageLabel.text)
            clearTextfeilds()
            
            self.view.addSubview(customAlertView)
        }
        else
        {
            if let userNameString = UserDefaults.standard.getFirstName()
            {
                
                
                let string1 = self.txt_careRecieverName.text ?? ""
                let string2 = "has been added as a Care-Receiver and an email sent to"
                let string3 = userNameString
                let string4 = "for consent. Please click Yes if you want to add another Care-Receiver or No to continue without adding another Care-Receiver"
                
                //
                //            customAlertView.alertMessageLabel.text = self.txt_careRecieverName.text ??
                //                "" + "has been added as a Care-Receiver and an email sent to" + emailID + "for consent. Please click “Yes” if you want to add another Care-Receiver or “No” to continue without adding another Care-Receiver"
                
                customAlertView.alertMessageLabel.text = "\(string1) \(string2) \(string3) \(string4)"
                
                
//                customAlertView.alertMessageLabel.text = self.txt_careRecieverName.text ??
//                    "" + "has been added as a Care-Receiver and an email sent to" + userNameString + "for consent. Please click “Yes” if you want to add another Care-Receiver or “No” to continue without adding another Care-Receiver"
                 print(customAlertView.alertMessageLabel.text)
                clearTextfeilds()
                //customAlertView.alertMessageLabel.text = "An email has been sent to " + userNameString + " for consent."
            }
            else
            {
                //customAlertView.alertMessageLabel.text = "An email has been sent to user for consent."
                
                let string1 = self.txt_careRecieverName.text ?? ""
                let string2 = "has been added as a Care-Receiver and an email sent to"
                let string3 = "User"
                let string4 = "for consent. Please click Yes if you want to add another Care-Receiver or No to continue without adding another Care-Receiver"
                
                customAlertView.alertMessageLabel.text = "\(string1) \(string2) \(string3) \(string4)"
                
//                customAlertView.alertMessageLabel.text = self.txt_careRecieverName.text ??
//                    "" + "has been added as a Care-Receiver and an email sent to user for consent. Please click “Yes” if you want to add another Care-Receiver or “No” to continue without adding another Care-Receiver"
                print(customAlertView.alertMessageLabel.text)
                clearTextfeilds()
            }
            
            self.view.addSubview(customAlertView)
        }
        
        selctdcontact_Arr.append(self.selcted_avatar)
        self.selctd_Contacts.reloadData()
        storedCareRecieverId.append(careRecieverId)
        print(storedCareRecieverId)
    }
    
    func AddCareRecieverDidSucceeed()
    {
        
    }
    
    func AddCareRecieverDidFailed()
    {
        
    }
    
    
}
extension AddCareRecieverVC:DeleteCareRecieverDelegate
{
    func DeleteCareRecieverDidSucceeed()
    {
        selctdcontact_Arr.remove(at: lastSelectedIndexForDelete ?? 0)
        storedCareRecieverId.remove(at: lastSelectedIndexForDelete ?? 0)
        self.selctd_Contacts.reloadData()
    }
    
    func DeleteCareRecieverDidFailed()
    {
        
    }
    
    
    
}

extension AddCareRecieverVC:CustomAlertDelegate{
    func NoButtonTapped(sender: UIButton) {
        self.Add_More(self)
    }
    func YesButtonTapped(sender: UIButton) {
        
    }
    
}
//extension AddCareRecieverVC:UITextFieldDelegate{
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text?.count == 0  && string == " "{
//
//            // If consecutive spaces entered by user
//            return false
//        }
//        else{
//            // If no consecutive space entered by user
//            var maxLength = 1
//            if(textField == self.txt_emailAddress){
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
//    }
//}
extension AddCareRecieverVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
                    
                    self.selced_img.image = pickedImage
                    self.selced_img.setRounded()
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

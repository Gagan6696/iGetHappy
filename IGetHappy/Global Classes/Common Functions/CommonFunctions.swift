//
//  CommonFunctions.swift
//
//  Created by Gagan
//  Copyright © 2019 Seasia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

@available(iOS 10.0, *)
class CommonFunctions
{
    static let sharedInstance = CommonFunctions()
    
    
    private init()
    {
    }
    
    
    func clearUserDefaults(){
        let UserDefaultsObj =  UserDefaults.standard
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.email.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.firstName.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.lastName.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.nickName.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.password.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.userId.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.accessTokken.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.profileImage.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.anonymous.rawValue)
        UserDefaultsObj.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        UserDefaults.standard.setLoggedIn(value: false)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.breatheAudio.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.lastGetDetailMusic.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.breatheImage.rawValue)
       // UserDefaults.standard.removeObject(forKey: defaultKeys.Emoji_CurrentPage)
        ExtensionModel.shared.Emoji_CurrentPage = 10
        
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil, forKey: )
        //        UserDefaultsObj.set(nil,forKey: )
        //        UserDefaultsObj.set(nil,forKey: )
        CompleteRegisterData.sharedInstance?.Reinitilize()
        
    }
    
    
    //MARK: - Navigation functions
    func PushToContrllerForEdit(from Target : UIViewController,  ToController:ViewControllers, Data:Any?) {
        if let obj =  ToController.viewcontroller as? PreviewVC{
            if let name = Data as? [Post] {
                obj.selectedPostData = name
            }
            if let data = Data as? AllVentsModelDetail{
                //This model and variable is global
                selectedPostVentsVideo = data
                isEditVentsVideo = true
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        Target.navigationController?.pushViewController(ToController.viewcontroller!, animated: true)
    }
    
    func PushToContrller(from Target : UIViewController,  ToController:ViewControllers, Data:Any?)
    {
        print(ToController.viewcontroller ?? "")
        
        
        if let obj =  ToController.viewcontroller as? ChatBotVC{
            if let selectedUserNameForChat = Data as? String
            {
                obj.selectedUserName = selectedUserNameForChat as String
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        if let obj =  ToController.viewcontroller as? ChooseMoodVC{
            if let isFrom = Data as? String
            {
                obj.from_activity_controller = isFrom as String
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }

        if let obj =  ToController.viewcontroller as? PreviewVC{
            if let url = Data as? URL
            {
                obj.path = url as NSURL
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        if let obj =  ToController.viewcontroller as? addVideoVC{
            if let fromPreviewVC = Data as? Bool
            {
                obj.isFromPreviewVC = fromPreviewVC
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        
        
        
        if let obj =  ToController.viewcontroller as? CommentViewController{
            if let selectedIndex = Data as? Post{
                obj.selectedPost = selectedIndex
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        if let obj =  ToController.viewcontroller as? ReplyViewController{
            if let data = Data as? [String:String]{
                obj.dataForPostReply = data
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        
        if let obj =  ToController.viewcontroller as? StartBeginVC {
            if let name = Data as? String{
                obj.name = name as String
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }

        if let obj =  ToController.viewcontroller as? WriteThoughtsVC{
            if let name = Data as? [Post] {
                obj.selectedPostData = name
            }
            
            if let data = Data as? AllVentsModelDetail{
                obj.selectedPostVents = data
                obj.isEditVents = true
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        
        if let obj =  ToController.viewcontroller as? RecordAudioVC{
            if let name = Data as? [Post] {
                obj.selectedPostData = name
                
            }
            
            if let data = Data as? AllVentsModelDetail{
                obj.selectedPostVentsAudio = data
                obj.isEditVentsAudio = true
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        if let obj =  ToController.viewcontroller as? CareReceiverTabsVC{
            if let data = Data as? CareReceiverDetail {
                obj.dataCareReciever = data
            }
            Target.navigationController?.pushViewController(obj, animated: true)
            return
        }
        Target.navigationController?.pushViewController(ToController.viewcontroller!, animated: true)
    }
    
    func SetRootViewController(rootVC : RootViewControllers){
     Constants.Global.ConstantStrings.KappDelegate.window?.rootViewController = rootVC.rootViewcontroller
    }
    
    func popTocontroller(from Target : UIViewController){
        Target.navigationController?.popViewController(animated: true)
    }
    
    func PresentTocontroller(from Target : UIViewController,  ToController:ViewControllers,Data:Any?){
        
        if let obj =  ToController.viewcontroller as? PreviewVC{
            if let url = Data as? URL{
                obj.path = url as NSURL
            }
            Target.navigationController?.present(obj, animated: true)
            return
        }
        
       Target.present(ToController.viewcontroller!, animated: true, completion: nil)
    }
    
    //MARK: - Validation functions
    func checkTextSufficientComplexity( text : String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: text)
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        
        return capitalresult || numberresult || specialresult
    }
    
    //MARK: -    Check Location
    func LocationAccess() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                Location.sharedInstance.InitilizeGPS()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    class func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    class func make_text_different_in_label(label:UILabel,textForColor:String) -> UILabel
    {
        let blueColor = UIColor(red: 50.0/255.0, green: 190.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        let main_string = label.text
        let string_to_color = textForColor
        
        let range = (main_string! as NSString).range(of: string_to_color)
        
        let attribute = NSMutableAttributedString.init(string: main_string ?? "")
        attribute.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: blueColor , range: range)
        
        let labelNew = label
        labelNew.attributedText = attribute
        
        return labelNew
    }
}

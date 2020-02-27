//
//  CommonVc.swift
//  CareerApp
//
//  Created by Kindlebit on 26/10/18.
//  Copyright © 2018 careerprivacy. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import MBProgressHUD
import AlamofireObjectMapper
import AVFoundation
import CoreMedia
//import SwiftyJSON


extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}



public class CommonVc: UIViewController
{
    
    typealias CompletionUser = ( _ result: Handle_Response? , _ error: Error?) -> ()
    
    public class AllFunctions
    {
        
        //MARK: - Internet Check
        class func have_internet() -> Bool
        {
            // To check internet connection.
            var isInternetActive: Bool!
            var internetConnectionReach: Reachability!
            internetConnectionReach = Reachability.reachabilityForInternetConnection()
            var netStatus: Reachability.NetworkStatus!
            netStatus = internetConnectionReach.currentReachabilityStatus
            
            if(netStatus == Reachability.NetworkStatus.notReachable)
            {
                isInternetActive = false;
                return isInternetActive
            }
            else
            {
                isInternetActive = true
                return isInternetActive
            }
        }
        
        
        class func createEmojy_forMood() -> [CharacterC]
        {
            let characters = [
                
                CharacterC(imageName: "excited", title: "Excited", description: "excited"),
                CharacterC(imageName: "haha", title: "Haha", description: "haha"),
                CharacterC(imageName: "wink", title: "Wink", description: "wink"),
                CharacterC(imageName: "wow_dark", title: "Wow", description: "wow_dark"),
                CharacterC(imageName: "blushing", title: "Blushing", description: "blushing"),
                CharacterC(imageName: "ic_angry_dark", title: "Angry", description: "ic_angry_dark"),
                CharacterC(imageName: "sad_dark", title: "Sad", description: "sad_dark")
            ]
            return characters
        }
        /**
         To set Smiley from assets using resourceId
         */
        class func set_emojy_from_server(imgName:String) -> UIImage
        {
            if let image = UIImage(named:imgName)
            {
                return image
            }
            
            return UIImage(named: "smily")!
        }
        
        class func set_privacy_from_server(privacy:String) -> UIImage
        {
            if (privacy == "FRIENDS")
            {
                return UIImage(named: "friends")!
            }
            else if (privacy == "ONLYME")
            {
                return UIImage(named: "globalLock")!
            }
            else
            {
                return UIImage(named: "public")!
            }
            
            
        }
        
        class func convert_asset_duration(asset:AVAsset)-> Int
        {
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            return Int(durationTime)
        }
        
        class func get_emojy_index_from_name(name:String)-> Int
        {
            let emoArr = self.createEmojy_forMood()
            var indx = 0
            
            for i in 0...emoArr.count-1
            {
                let obj = emoArr[i]
                
                if (obj.title == name)
                {
                    indx = i
                    break
                }
            }
            
            return indx
        }
        
        class func returnDate_from_Formatter(myDate:Date) -> Date
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let srdate = formatter.string(from: myDate)
            let dateN = formatter.date(from: srdate)
            return  dateN ?? Date()
        }
        
        class func return_time_from_string(myTime:String) -> Date
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            let dateN = formatter.date(from: myTime)
            return  dateN ?? Date()
        }
        
        
        class func return_string_from_date(myDate:Date) -> String
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let srdate = formatter.string(from: myDate)
            return  srdate
        }
        
        class func convert_string_into_date(strArr:[String]) -> [Date]
        {
            var newArr = [Date]()
            if strArr.count > 0
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                for strDate in strArr
                {
                    if let dateN = formatter.date(from: strDate)
                    {
                        newArr.append(dateN)
                    }
                }
                
                return newArr
            }
            
            return newArr
        }
        
        class func convert_date_array_into_string_array(dateArr:[Date]) -> [String]
        {
            var strArr = [String]()
            if (dateArr.count > 0)
            {
                for obj in dateArr
                {
                    let strDate = return_string_from_date(myDate: obj)
                    strArr.append(strDate)
                }
                
                return strArr
            }
            
            return strArr
        }
        
        
        class func filter_date_array_with_weekDays(dateArr:[Date],weekDay:Int) -> [Date]
        {
            var strArr = [Date]()
            
            if (dateArr.count > 0)
            {
                for i in 0...dateArr.count-1
                {
                    let datefromArr = dateArr[i]
                    let day = Calendar.current.component(.weekday, from: datefromArr)
                    if (day == weekDay)
                    {
                        strArr.append(datefromArr)
                    }
                }
                
                return strArr
            }
            
            return strArr
        }
        
        
        class func formatize_date_arr(dateArr:[Date])-> [Date]
        {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var formattedArr = [Date]()
            
            if (dateArr.count > 0)
            {
                for objDate in dateArr
                {
                    let srdate = formatter.string(from: objDate)
                    let dateN = formatter.date(from: srdate)
                    formattedArr.append(dateN!)
                }
                
                return formattedArr
            }
            
            return formattedArr
        }
        
        class func show_automatic_hide_alert(controller:UIViewController,title:String)
        {
            let alert = UIAlertController(title: "", message: title, preferredStyle: .alert)
            controller.present(alert, animated: true, completion: nil)
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 7
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
        
        class func get_top_controller()-> UIViewController
        {
            if var topController = UIApplication.shared.keyWindow?.rootViewController
            {
                while let presentedViewController = topController.presentedViewController
                {
                    topController = presentedViewController
                }
                
                return topController
            }
            
            return   UIApplication.shared.keyWindow!.rootViewController!
        }
        
        class func decodeImage(base64:String) -> UIImage
        {
            let dataDecoded:NSData = NSData(base64Encoded: base64, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let image_dflt = UIImage(named:"currepted")
            if (dataDecoded.length == 0)
            {
                return image_dflt!
            }
            else
            {
                if let decodedimage:UIImage = UIImage(data: dataDecoded as Data)
                {
                    return decodedimage
                }
                return image_dflt!
            }
        }
        
        class func clear_database_for_uploaded_files_happy_memories()
        {
            DatabaseModel_HappyMemris_Offline_API_DATA.delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY: "", success: { (sccss) in
                
                print(sccss)
            })
            { (err) in
                print(err)
            }
        }
        
        class func get_file_from_document_dirctory(fileName:String)-> String
        {
            if (fileName.count > 0)
            {
                let filemanager = FileManager.default
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
                let destinationPath = documentsPath.appendingPathComponent(fileName)
                
                if (filemanager.fileExists(atPath: destinationPath))
                {
                    return destinationPath
                }
                else
                {
                    return ""
                }
            }
            else
            {
                return ""
            }
        }
        
        class func get_thumbnail_from_server_link(path:String) -> UIImage
        {
            let img = UIImage(named:"videoBG")
            if (path.count > 0)
            {
                let url = URL(string: path)
                
                let asset = AVAsset(url: url!)
                let assetImgGenerate = AVAssetImageGenerator(asset: asset)
                assetImgGenerate.appliesPreferredTrackTransform = true
                assetImgGenerate.maximumSize = CGSize(width: 100, height: 100)
                
                let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
                do
                {
                    let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                    let thumbnail = UIImage(cgImage: img)
                    return thumbnail
                }
                catch
                {
                    print(error.localizedDescription)
                    return img!
                }
                
                //                if let thumbnailImage = self.getThumbnailImage(forUrl: url!)
                //                {
                //                    return thumbnailImage
                //                }
            }
            
            return img!
        }
        
        class func getThumbnailImage(forUrl url: URL) -> UIImage?
        {
            let asset: AVAsset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            
            do
            {
                let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
                return UIImage(cgImage: thumbnailImage)
            }
            catch let error
            {
                print(error)
            }
            
            return nil
        }
        
        class func save_file_in_document_directory(pathNew:String,fileUrl:URL)
        {
            if (fileUrl.absoluteString.count > 0)
            {
                let fileData = NSData(contentsOf: fileUrl)
                let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
                let newPath = path.appendingPathComponent(pathNew)
                do
                {
                    try fileData?.write(to: newPath)
                }
                catch
                {
                    print(error)
                }
            }
        }
        
        //MARK: HANDLING SEND VIEW WHEN KEYBOOARD IS APPEAR
        class func pullUp_view_for_keyboard(view:UIView)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                view.frame.origin.y = -(view.frame.size.height/3)-10
                view.layoutIfNeeded()
            }) { _ in
            }
        }
        class func bowDown_view_for_keyboard(view:UIView)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                view.frame.origin.y = 0
                view.layoutIfNeeded()
            }) { _ in
            }
        }
        
        
        class func showAlert(message:String,view:UIViewController,title:String)
        {
            let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            view.present(alert, animated: true, completion: nil)
        }
        
        class func addLOADER(controller:UIViewController)
        {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: controller.view, animated: true)
            }
        }
        
        class func hideLOADER(controller:UIViewController)
        {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: controller.view, animated: true)
            }
        }
        
        class func get_placeholder_image(type:String)-> UIImage
        {
            var image = UIImage(named: "currepted")
            if (type == "AUDIO")
            {
                image = UIImage(named: "audioBG")
            }
            if (type == "VIDEO")
            {
                image = UIImage(named: "videoBG")
            }
            if (type == "IMAGE")
            {
                image = UIImage(named: "currepted")
            }
            
            return image!
        }
        
        class func getCurrentDate_InString() -> String
        {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            return result
        }
        
        class func generateRandomString() -> String
        {
            let letters : NSString = "0123456789"
            let len = UInt32(letters.length)
            
            var randomString = ""
            
            for _ in 0 ..< 10
            {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            return randomString
        }
        
        
        class func image_radious(image: UIImageView)-> UIImageView
        {
            image.layer.cornerRadius = 3
            image.layer.masksToBounds = true
            image.clipsToBounds = true;
            return image
        }
        class func radious_create(button: UIButton)-> UIButton
        {
            button.layer.cornerRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 0.2
            //button.layer.masksToBounds = true
            return button
        }
        class func button_radiousColorborder(button: UIButton)-> UIButton
        {
            button.layer.cornerRadius = 5
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 0)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 0.2
            //button.layer.masksToBounds = true
            return button
        }
        class func txtfield_border_color(txtfield: UITextField)-> UITextField
        {
            //txtfield.layer.shadowRadius = 3.0
            txtfield.layer.shadowColor = UIColor.lightGray.cgColor
            txtfield.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            txtfield.layer.shadowOpacity = 1.0
            
            return txtfield
        }
        class func button_border(button: UIButton)-> UIButton
        {
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 20.0
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.white.cgColor
            
            return button
        }
        
        class func button_shadow_border(button: UIButton)-> UIButton
        {
            button.layer.shadowColor = UIColor.lightGray.cgColor
            button.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            button.layer.shadowOpacity = 1.0
            button.layer.cornerRadius = 5.0
            
            return button
        }
        
        class func radious_for_view (view: UIView)->UIView
        {
            view.layer.cornerRadius = 10.0
            view.layer.shadowColor = UIColor.darkGray.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 5
            view.layer.shadowOpacity = 0.2
            return view
        }
        class func radious_for_label (label: UILabel)->UILabel
        {
            label.layer.cornerRadius = 0.0
            label.layer.masksToBounds = true
            label.layer.borderWidth = 2.0
            label.layer.borderColor = UIColor.lightGray.cgColor
            
            return label
        }
        class func radious_for_Button (uibutton: UIButton)->UIButton
        {
            uibutton.layer.cornerRadius = 0.0
            uibutton.layer.masksToBounds = true
            uibutton.layer.borderWidth = 2.0
            uibutton.layer.borderColor = UIColor.lightGray.cgColor
            
            return uibutton
        }
        class func header_bottom_shedow (view: UIView)->UIView
        {
            view.layer.shadowColor = UIColor.lightGray.cgColor
            view.layer.masksToBounds = false
            view.layer.shadowOffset = CGSize(width: 0.0 , height: 1.0)
            view.layer.shadowOpacity = 5.0
            view.layer.shadowRadius = 1.0
            return view
        }
        
        class func SearchActiveInactive(button1: UIButton, button2: UIButton,button3: UIButton,button4: UIButton)
        {
            button1.backgroundColor = UIColor(red: 124/255, green: 73/255, blue: 198/255, alpha: 1.0)
            button1.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0), for:.normal)
            
            button2.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            button2.setTitleColor(UIColor(red: 124/255, green: 73/255, blue: 198/255, alpha: 1.0), for:.normal)
            button3.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            button3.setTitleColor(UIColor(red: 124/255, green: 73/255, blue: 198/255, alpha: 1.0), for:.normal)
            button4.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            button4.setTitleColor(UIColor(red: 124/255, green: 73/255, blue: 198/255, alpha: 1.0), for:.normal)
        }
        
        class func DynamictblHeightAndScroll(cellHeight :CGFloat,tableView : UITableView,ScrollViewTbl: UIScrollView,btnSave: UIButton)
        {
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: cellHeight)
            ScrollViewTbl.contentSize = CGSize(width: ScrollViewTbl.frame.size.width, height: cellHeight+100)
            
            btnSave.frame = CGRect(x: btnSave.frame.origin.x, y: cellHeight+50, width: btnSave.frame.size.width, height: btnSave.frame.size.height)
        }
        class func isValidEmail(testStr:String) -> Bool
        {
            print("validate emilId: \(testStr)")
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: testStr)
            return result
        }
        class func validatePhone(value: String) -> Bool {
            let PHONE_REGEX = "^[0-9]{9,15}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }
        
        class func HeaderWithPOSTRequest(forURL: String, params: [String: AnyObject], showLoader:Bool, viewmain:UIView, success: @escaping (Dictionary<String, AnyObject>) -> Void, failure: @escaping (Error) -> Void)
        {
            if showLoader
            {
                MBProgressHUD.showAdded(to: viewmain, animated: true)
            }
            Alamofire.request(forURL, method: .post, parameters: params,headers:["Accept" : "application/json"]).responseJSON { response in
                if response.result.isSuccess
                {
                    //print(response.result.isSuccess)
                    MBProgressHUD.hide(for: viewmain, animated: true)
                    if let json = response.result.value {
                        success(json as! Dictionary<String, AnyObject>)
                        MBProgressHUD.hide(for: viewmain, animated: true)
                    }
                }
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
                if showLoader
                {
                    MBProgressHUD.hide(for: viewmain, animated: true)
                }
            }
        }
        
        
        
        
        class func HeaderWithGETRequest(forURL: String, params: [String: AnyObject], showLoader:Bool,viewmain:UIView, success: @escaping (Dictionary<String, AnyObject>) -> Void, failure: @escaping (Error) -> Void)
        {
            if showLoader
            {
                MBProgressHUD.showAdded(to: viewmain, animated: true)
            }
            Alamofire.request(forURL, method: .get, parameters: params,headers:["Accept" : "application/json"]).responseJSON { response in
                
                if response.result.isSuccess
                {
                    print(response.result.isSuccess)
                    MBProgressHUD.hide(for: viewmain, animated: true)
                    if let json = response.result.value {
                        success(json as! Dictionary<String, AnyObject>)
                        MBProgressHUD.hide(for: viewmain, animated: true)
                    }
                }
                if response.result.isFailure {
                    let error : Error = response.result.error!
                    failure(error)
                }
                if showLoader
                {
                    MBProgressHUD.hide(for: viewmain, animated: true)
                }
            }
        }
        
        
        
        class func genrate_base64_from_data(fileName:String) -> String
        {
            let fm = FileManager.default
            let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let path = docsurl.appendingPathComponent(fileName)
            let videoURL = NSURL(string: path.absoluteString)
            do
            {
                let asset = AVURLAsset(url: videoURL! as URL , options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 5), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                let imgData = thumbnail.pngData()
                let base64String = imgData?.base64EncodedString()
                
                return base64String ?? ""
            }
            catch let error
            {
                print("*** Error generating thumbnail: \(error.localizedDescription)")
                return ""
            }
        }
        
        
        class func genrate_image_from_url(fileName:String) -> String
        {
            if (fileName.count > 0)
            {
                let fileURL = URL(string: fileName)
                if let data = try? Data(contentsOf: fileURL!)
                {
                    let base64String = data.base64EncodedString()
                    return base64String
                }
                else
                {
                    return ""
                }
            }
            else
            {
                return ""
            }
            
        }
        
        
        
        //MODEL FOR GET REQUEST WITH TOKEN
        class func HeaderWithGETRequestToken_MODEL(forURL: String, params: [String: AnyObject], success: @escaping (CompletionUser))
        {
            var accessTokken = ""
            if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
            {
                accessTokken = str
            }
            
            let headers    = ["Content-Type" : "application/json","Authorization": "\(accessTokken)","Accept" : "application/json"]
            
            Alamofire.request(forURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers : headers).responseObject{ (response: DataResponse<Handle_Response>) in
                switch(response.result)
                {
                case .success(_):
                    var listDetail: Handle_Response?
                    print(response.result.value!)
                    listDetail =  response.result.value ?? nil
                    success(listDetail,nil)
                    break
                case .failure(_):
                    let error : Error = response.result.error!
                    success(nil,error)
                    
                    break
                }
            }
        }
        
        
        class func return_days_from_selection_of_time(hint:String) -> Int
        {
            var result = 3
            if (Singleton.shared().setGoalDays == "3 Days")
            {
                result = 3
            }
            else if (Singleton.shared().setGoalDays == "7 Days")
            {
                result = 7
            }
            else if (Singleton.shared().setGoalDays == "14 Days")
            {
                result = 14
            }
            else if (Singleton.shared().setGoalDays == "1 Month")
            {
                result = 31
            }
            else if (Singleton.shared().setGoalDays == "3 Months")
            {
                result = 93
            }
            else if (Singleton.shared().setGoalDays == "6 Months")
            {
                result = 186
            }
            else//year
            {
                result = 365
            }
            
            return result
            
        }
        
    }
    
    
    
    
}

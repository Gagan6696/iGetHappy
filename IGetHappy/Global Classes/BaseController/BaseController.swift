//
//  BaseController.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//


import UIKit
import ASProgressHud
import EventKit
import EventKitUI
import SystemConfiguration
import AVFoundation
import Photos
import ARSLineProgress
import MBProgressHUD
import AVKit
import MediaPlayer
open class BaseUIViewController: UIViewController
{
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // This method is used to corner the buttons e.g. Save, Submit etc.
    func CornerButton(btn : UIButton) {
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
    }
    
    
    
    
    
    func getCountryCode() -> String{
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            return countryCode
            print(countryCode)
           
        }
        return "IN"
    }
   
    
    func getCategoryNumberForMood(moodName:String) -> Double{
        
        print(moodName.lowercased())
        
        if  (moodName.lowercased() == "normal"){
            return 1.0
        }else if (moodName.lowercased() == "happy"){
             return 2.0
        }else if (moodName.lowercased() == "others"){
             return 3.0
        }else if (moodName.lowercased() == "sad"){
             return 4.0
        }else if (moodName.lowercased() == "angry"){
             return 5.0
        }else{
             return 6.0
        }
        
        
    }
    
    func find(value searchValue: String, in array: [String]) -> Int?
    {
        for (index, value) in array.enumerated()
        {
            if value == searchValue {
                return index
            }
        }
        
        return nil
    }
    
    func getIndex(of key: String, for value: String, in dictionary : [[String: Any]]) -> Int{
        var count = 0
        for dictElement in dictionary{
            if dictElement.keys.contains(key) && dictElement[key] as! String == value{
                return count
            }
            else{
                count = count + 1
            }
        }
        return -1
        
    }
    
    func getCurrentLocale() -> String{
        let locale  = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
        return locale ?? "IN"
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
//    func getLastController(isOfController:UIViewController){
//      let cm =  isOfController
//        if let vcs = self.navigationController?.viewControllers {
//            let previousVC = vcs[vcs.count - 2]
//
//            if previousVC as? isOfController {
//                CommonFunctions.sharedInstance.popTocontroller(from: self)
//            }
//        }
//    }
    
    // Hide Navigation Bar
    func HideNavigationBar(navigationController: UINavigationController){
        navigationController.setNavigationBarHidden(true, animated: true)
        
    }
    
    //UnHide Navigation Bar
    func UnHideNavigationBar(navigationController: UINavigationController){
        navigationController.setNavigationBarHidden(false, animated: true)
        //        navigationController.isToolbarHidden = false
        //        navigationController.isNavigationBarHidden = false
    }
    
    //Hide back button title
    func HideBackButtonTitle(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        UIBarButtonItem.appearance().tintColor = UIColor.white
    }
    
//    func playVideoViaAssets (view:UIView, asset:PHAsset, vc:UIViewController) {
//
//        guard (asset.mediaType == PHAssetMediaType.video)
//
//            else {
//               vc.view.makeToast("Corrupt media file")
//                return
//        }
//        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
//            DispatchQueue.main.async {
//
//                let asset = asset as? AVURLAsset
//                let player = AVPlayer(url: asset!.url)
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//
//                vc.addChild(playerViewController)
//
//                // Add your view Frame
//                playerViewController.view.frame = view.layer.frame
//
//                // Add sub view in your view
//                view.addSubview(playerViewController.view)
//
//
//
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player?.play()
//                }
//            }
//        })
//    }
    
    func trimTextfeildData(modifyString:String) -> Substring?{
        let start = modifyString.startIndex
        let offset = modifyString.count - 20
        if(offset > 0){
            let end = modifyString.index(modifyString.startIndex, offsetBy: +20)
            let substring = modifyString[start..<end]
            return substring
        }
       return Substring.init(modifyString)
        
       
    }
    
//    func convertIsoStringToDate(isoDate:String) -> Date{
//        
////         // set locale to reliable
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
////        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
////        let date = dateFormatter.date(from:isoDate)
////        return date!
//    
//        let dateFormatter = DateFormatter()
//        let date  = dateFormatter.dateFromISOString(string: isoDate)
//       
//        return date
//    }
    
    
    func checkForMusicLibraryAccess(andThen f:(()->())? = nil) {
        let status = MPMediaLibrary.authorizationStatus()
        switch status {
        case .authorized:
            f?()
        case .notDetermined:
            MPMediaLibrary.requestAuthorization() { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        f?()
                    }
                }
            }
        case .restricted:
         
          break
        case .denied:
            let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KMsgCameraPermission, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kOpenSettings, style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                            print(success)
                        })
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.KCancel, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //return
             break
        }
    }
    
    
    func setBackButton(title:String){
        let imgBack = UIImage(named: "backButton")
        navigationController?.navigationBar.backIndicatorImage = imgBack
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBack
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        //navigationController?.navigationItem.title = title
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //        navigationController?.navigationBar.barTintColor = Global.Strings.kBaseColor
        navigationItem.title = title
    }
    
    //Customize the Font of Navigation Bar
    func CustomizeFontNavaigationBar(navigationController: UINavigationController){
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 20)!,.foregroundColor: UIColor.white]
    }
    
    
  
    //MARK: - Alert and Toast
    
    func AlertMessgaeForMusicPermissiion(){
        let alertController = UIAlertController (title: Constants.Global.ConstantStrings.KAppname, message: "Go to Settings ", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func AlertMessageWithOkAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping () -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: Constants.Global.ConstantStrings.KOK, style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            completionResponse()
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentLatLon(vc:UIViewController,obj:CLLocationManager)
    {
        
        let locationManager = obj
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
       locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = vc as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ())
    {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
          

            if(error == nil)
            {
                print(error?.localizedDescription)
           
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            // Address dictionary
            print(placeMark.addressDictionary, terminator: "")
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString
            {
                print(locationName, terminator: "")
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street, terminator: "")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city, terminator: "")
                
                UserDefaults.standard.setLocation(value: city as String)
                completion(city as String, "", error)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString
            {
                print(zip, terminator: "")
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString
            {
                print(country, terminator: "")
                completion(country as String, "", error)
            }
            }
            else
            {
                print(error?.localizedDescription)
            }
        })
     
    }
    
    
    func AlertMessageWithOkCancelAction(titleStr:String, messageStr:String,Target : UIViewController, completionResponse:@escaping (String) -> Void) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            completionResponse("Yes")
        }
        let CancelAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            completionResponse("No")
        }
        // Add the actions
        alert.addAction(okAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

    func showAlertMessage(titleStr:String, messageStr:String) {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: Constants.Global.ConstantStrings.KOK, style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        // Add the actions
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func showToast(message : String)
    {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-80, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 8.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        Constants.Global.ConstantStrings.KappDelegate.window?.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        print(destinationUrl)
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:{
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl, error)
                                }
                                else
                                {
                                    completion(destinationUrl, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl, error)
                }
            })
            task.resume()
        }
    }
    
    
    func download_file(url: URL,pathNAme:String, completion: @escaping (URL?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(pathNAme)
        print(destinationUrl)
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:{
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl, error)
                                }
                                else
                                {
                                    completion(destinationUrl, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl, error)
                }
            })
            task.resume()
        }
    }
    
    
    
    //MARK: - Screen width
    
    func ViewHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    //MARK: - Screen Height
    
    func ViewWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    //MARK: - Internet Check
    func checkInternetConnection() -> Bool {
        // To check internet connection.
        var isInternetActive: Bool!
        var internetConnectionReach: Reachability!
        
        internetConnectionReach = Reachability.reachabilityForInternetConnection()
        
        var netStatus: Reachability.NetworkStatus!
        
        netStatus = internetConnectionReach.currentReachabilityStatus
        
        if(netStatus == Reachability.NetworkStatus.notReachable) {
            isInternetActive = false;
            return isInternetActive
        }
        else {
            isInternetActive = true
            return isInternetActive
        }
    }
    
    //MARK: - Navigatin after Alert
    
    func AlertWithNavigatonPurpose(message: String, navigationType:NavigationType, ViewController:ViewControllers,rootViewController:RootViewControllers,Data:Any?)
    {
        let alertController = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: message, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: Constants.Global.ConstantStrings.KOK, style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            switch navigationType {
            case .push:
                Constants.Singleton.Objects.KCommonFunctions.PushToContrller(from: self, ToController: ViewController, Data: Data)
            case .present:
                Constants.Singleton.Objects.KCommonFunctions.PresentTocontroller(from: self, ToController: ViewController, Data: nil
                )
            case .pop:
                Constants.Singleton.Objects.KCommonFunctions.popTocontroller(from: self)
            case .root:
                Constants.Singleton.Objects.KCommonFunctions.SetRootViewController(rootVC:rootViewController)
            }
        }
        self.dismiss(animated: true, completion: nil)
        //        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
        //            UIAlertAction in
        //            NSLog("Cancel Pressed")
        //        }
        
        // Add the actions
        alertController.addAction(okAction)
        //alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //Show Alert with message
    func showAlert(Message:String)
    {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "IGetHappy", message: Message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func dismissKeyboardBeforeAction(){
        view.endEditing(true)
    }
    
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    //Show and Hide Loader
    func ShowLoaderCommon()
    {
        MBProgressHUD.showAdded(to: view, animated: true).labelText = "Loading"
       //ARSLineProgress.ars_showOnView(self.view)
        //ASProgressHud.showHUDAddedTo(self.view, animated: true, type: .google)
    }
    
    func HideLoaderCommon(){
        MBProgressHUD.hide(for: view, animated: true)
         //ARSLineProgress.hide()
        //ASProgressHud.hideHUDForView(self.view, animated: true)
    }
    
    func createNavigationBackBarButtonForSideBarMenuItems(title:String?){
        let myBackButton:UIButton = UIButton()
        myBackButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        // myBackButton.setBackgroundImage(UIImage(named:"backButton"), for: UIControl.State())
        myBackButton.setImage(UIImage(named:"backButton"), for: UIControl.State())
        myBackButton.addTarget(self, action: #selector(self.popToHome), for: UIControl.Event.touchUpInside)
        let leftBackBarButton:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem = leftBackBarButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 20)!,.foregroundColor: UIColor.white]
        
        //self.navigationController?.navigationBar.barTintColor = Global.Strings.kBaseColor
        self.navigationItem.title = title
        
        
    }
    @objc func popToHome()
    {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainViewController") as! HomeVC
//        let leftViewController = storyboard.instantiateViewController(withIdentifier: "SideBarVC") as! SideBarVC
//        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
//
//        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
//        nvc.navigationItem.title = "Home"
//
//        slideMenuController.delegate = mainViewController
//        appDelegate.window?.backgroundColor = Global.Strings.kBaseColor
//        appDelegate.window?.rootViewController = slideMenuController
//        appDelegate.window?.makeKeyAndVisible()
        // create viewController code...
    }
    
    //clearUserDefaults
    func clearUserDefaultsSimpleLogin(){
        let UserDefaultsObj =  UserDefaults.standard
       
        UserDefaultsObj.set(nil, forKey: UserDefaultsKeys.email.rawValue)
        UserDefaultsObj.set(nil, forKey: UserDefaultsKeys.firstName.rawValue)
        UserDefaultsObj.set(nil, forKey: UserDefaultsKeys.lastName.rawValue)
        UserDefaultsObj.set(nil, forKey: UserDefaultsKeys.nickName.rawValue)
       
    }
    func clearUserDefaults()
    {
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
        CompleteRegisterData.sharedInstance?.Reinitilize()
        
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    //Set Custom Back Button When using push and segue//Taran
    func SetBackBarNavigationCustomButton()
    {
        //Back buttion
        let btnLeft: UIButton = UIButton()
        btnLeft.setImage(UIImage(named: "backButton"), for: .normal)
        btnLeft.addTarget(self, action: #selector(self.onClcikBack), for: .touchUpInside)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        let barLeftButton = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItem = barLeftButton
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "OpenSans-Semibold", size: 20)!,.foregroundColor: UIColor.white]
    }
    
    @objc func onClcikBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func compressImage(image:UIImage,compressionQuality:CGFloat) -> Data {
        
        //let imageData2 = UIImageJPEGRepresentation(image, 1.0)//UIImageJPEGRepresentation(image, 1.0)
        let imageData2 = image.jpegData(compressionQuality: 0.75)
        // print((imageData2! as Data).count)
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64((imageData2! as Data).count))
        print(string)
        
        
        var actualHeight:CGFloat = CGFloat(image.size.height)
        var actualWidth:CGFloat = CGFloat(image.size.width)
        let maxHeight:CGFloat = 2000.0 * 0.8
        let maxWidth:CGFloat = 2000.0
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = maxWidth/maxHeight
        let compressionQuality:CGFloat = 1.0
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }else{
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect:CGRect = CGRect.init(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality:  compressionQuality)
        //let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        
        //print((imageData! as Data).count)
        let string2 = bcf.string(fromByteCount: Int64((imageData! as Data).count))
        print(string2)
        
        
        UIGraphicsEndImageContext()
        
        return imageData!
    }
    
    
}


//MARK: Other validation methods
extension NSObject{
    
    func isFirstLastNameLength( text:String)-> Bool   {
        if text.count < 20  &&  text.characters.count > 3 {
            return true
        }
        else{
            return false
        }
    }
    func isEmailLength( text:String)-> Bool   {
        if text.count < 50 {
            return true
        }
        else{
            return false
        }
    }

    
    //MARK:- PASSWORD VALIDATION
    func isValidPassword(_ Text:String) -> Bool {
        let name_reg = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let name_test = NSPredicate(format: "SELF MATCHES %@", name_reg)
        if name_test.evaluate(with: Text)
        {
            return name_test.evaluate(with: Text)
        }
        else
        {
            return false
        }
    }
    
   
    //Date conversion
    func dateFromISOString(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }
    //Date format for past mood logs
    func dateFromISOStringPastMoodLog(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone =  TimeZone(identifier: "UTC")
        dateFormatter.locale =  Locale.current
        dateFormatter.dateFormat =  "EEEE,ddMMM hh:mmaa"
        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }

    func dateFromISOStringForMoodlogs(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone =  TimeZone(identifier: "UTC")
        dateFormatter.locale =  Locale.current
        dateFormatter.dateFormat =  "EEEE,ddMMM hh:mmaa"
        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }
    
    
    func dateFromISOStringToSort(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let dt = dateFormatter.date(from: string)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
         dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        print("\(dateFormatter.string(from: dt!))")
        return dateFormatter.string(from: dt!)
        
    }
    
    func getDayFromISOString(string: String) -> String?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let dt = dateFormatter.date(from: string)
       
        print("\(dateFormatter.string(from: dt!))")
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: dt ?? Date())
        if  let day = components.day {
            return "\(day)"
        }
        return ""
    }
    
}


extension UIViewController{
    func addImageOptions()
    {
        DispatchQueue.main.async{
            self.view.endEditing(true)
            let actionSheet1 = UIAlertController(title: Constants.Global.ConstantStrings.kChoosePhoto , message: nil, preferredStyle: .actionSheet)
            
            actionSheet1.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kCamera, style: .default, handler: {(action: UIAlertAction) -> Void in
                // take photo button tapped.
                self.takeNewPhotoFromCamera()
            }))
            actionSheet1.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kGallery, style: .default, handler: {(action: UIAlertAction) -> Void in
                // choose photo button tapped.
                self.choosePhotoFromExistingImages()
            }))
            actionSheet1.addAction(UIAlertAction(title:Constants.Global.ConstantStrings.KCancel, style: .cancel, handler: nil))
            
            self.present(actionSheet1, animated: true, completion: nil)
        }
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor)
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        //gradientLayer.frame = bounds
        //layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func dateFormatTime(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    
    func dateFormatTimeFilter(date : Date , format : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    
    func takeNewPhotoFromCamera()
    {
        view.endEditing(true)
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
            if granted == true
            {
                
                
                
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                {
                    let controller = UIImagePickerController()
                    controller.sourceType = .camera
                    controller.allowsEditing = false
                    controller.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    DispatchQueue.main.async {
                        self.navigationController?.present(controller, animated: true, completion: nil)
                    }
                    
                }
                
            }
            else
            {
                let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KMsgCameraPermission, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kOpenSettings, style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:], completionHandler: { (success) in
                                print(success)
                            })
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.KCancel, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
        })
        
    }
    
    //Select pic from gallery
    func choosePhotoFromExistingImages()
    {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
                let controller = UIImagePickerController()
                controller.sourceType = .savedPhotosAlbum
                controller.allowsEditing = false
                controller.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                DispatchQueue.main.async {
                    self.navigationController!.present(controller, animated: true, completion: nil)
                }
            }
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KMsgCameraPermission, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.kOpenSettings, style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: Constants.Global.ConstantStrings.KCancel, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.notDetermined)
        {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
                    {
                        let controller = UIImagePickerController()
                        controller.sourceType = .savedPhotosAlbum
                        controller.allowsEditing = false
                        controller.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                        DispatchQueue.main.async {
                            self.navigationController!.present(controller, animated: true, completion: nil)
                        }
                    }
                }
                else
                {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted)
        {
            // Restricted access - normally won't happen.
        }
    }
}


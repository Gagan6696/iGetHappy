//
//  newCamVC.swift
//  StatusStoryDemo
//
//  Created by Aditi on 8/22/18.
//  Copyright © 2018 Taranjeet Singh. All rights reserved.
//

import UIKit
import SwiftyCam
import Photos
import ARSLineProgress
import MBProgressHUD


class addVideoVC: SwiftyCamViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var btn_flash: UIButton!
    @IBOutlet weak var btn_Capture: SwiftyCamButton!
    //MARK: - Variables
    @IBOutlet weak var imgRecord: UIImageView!
    var imagePick = UIImagePickerController()
    //var progressTimer : Timer!
    var selectedPostData: [Post]?
    var delegatePassUrl:JournelThoughtsVC?
    // tHis is one to check whether edit  is for   vents
    var isFromPreviewVC :Bool?
    
    var progressTimer : Timer!
    var progress : Int! = 0
    var timerLabel = UILabel()
    static var maxDuration = 30
    //MARK: - ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //let countdownLabel = CountdownLabel(frame: frame, minutes: 30) // you can use NSDate as well
        
        self.HideNavigationBar(navigationController: self.navigationController!)
        cameraDelegate = self
        btn_Capture.delegate = self
        imagePick.delegate = self
        maximumVideoDuration = 30.0
        self.imgRecord.isHidden = true
        let transfrom:CGAffineTransform=CGAffineTransform(scaleX: 1, y: 4)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addVideoVC.maxDuration = 30
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (progressTimer != nil){
            progressTimer.invalidate()
            progressTimer = nil
        }
        
       timerLabel.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ButtonActions
    @IBAction func ActionbackBtn(_ sender: Any) {
        
        if(self.navigationController != nil){
            if let vcs = self.navigationController?.viewControllers {
                let previousVC = vcs[vcs.count - 2]
                if previousVC is JournelThoughtsVC {
                    CommonFunctions.sharedInstance.popTocontroller(from: self)
                }else{
                   // for controller in vcs as Array {
                 //       if controller.isKind(of: BaseTabVC.self) {
                   // self.stopVideoRecording()
                  //  isEditVentsVideo = true
                           CommonFunctions.sharedInstance.popTocontroller(from: self)
                           // break
                   //     }
                        
                  //  }
                }
            }
        }else{
            print(Constants.Global.MessagesStrings.SomethingWentWrong)
        }
       
        //CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func btn_Flash(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            flashEnabled = true
        }else{
            flashEnabled = false
        }
    }
    
    @IBAction func btn_Opengallery(_ sender: Any) {
        
        imagePick.allowsEditing = true
        imagePick.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        openGalleryy(imagePicker: imagePick)
        
    }
    
    @IBAction func btn_Chngcam(_ sender: Any) {
        switchCamera()
    }
    
    
    //MARK: - Functions
    func openGalleryy(imagePicker:UIImagePickerController)
    {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            imagePicker.navigationBar.tintColor = UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            imagePicker.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            ]
            
            imagePicker.videoMaximumDuration = 30.0
            present(imagePicker, animated: true)
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: "Please go to settings and allow the permission of gallery", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Open setting", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.openURL(settingsURL)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                }
                    
                else {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    func compresssVideo(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
    
}
//MARK: - Extensions
extension addVideoVC:SwiftyCamViewControllerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func HideNavigationBar(navigationController: UINavigationController){
        navigationController.setNavigationBarHidden(true, animated: true)
        
    }
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        
        
        
        self.imgRecord.isHidden = true
        
        timerLabel = UILabel(frame: CGRect(x: 0, y: 50, width: 50, height: 30))
        timerLabel.backgroundColor = .white
        timerLabel.layer.cornerRadius = 13
        timerLabel.clipsToBounds = true
        timerLabel.center.x = self.view.center.x
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
        self.view.addSubview(timerLabel)
        self.view.bringSubviewToFront(timerLabel)
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        
        //        video_progressView.isHidden=false
        //        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    //    @objc func update(){
    //        if (progressValue < 1)
    //        {
    //            progressValue += 0.025
    //            video_progressView.progress = progressValue
    //        }
    //        else
    //        {
    //            timer?.invalidate()
    //            timer = nil
    //        }
    //        let transfrom:CGAffineTransform=CGAffineTransform(scaleX: 1, y: 4)
    //        self.video_progressView.transform = transfrom;
    //    }
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        //ARSLineProgress.ars_showOnView(self.view)
        
        
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: BaseTabVC.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//
//                        }
//
        
        MBProgressHUD.showAdded(to: view, animated: true).labelText = "Loading"
        self.imgRecord.isHidden = true
        // Called when stopVideoRecording() is called
        // Called if a SwiftyCamButton ends a long press gesture
        
    }
    
    @objc func updateProgress() {
         // Max duration of the recordButton
        progress = addVideoVC.maxDuration
        addVideoVC.maxDuration = addVideoVC.maxDuration - 1
        //update timer label here
        
        if (addVideoVC.maxDuration < 10){
             timerLabel.text = "00:0\(addVideoVC.maxDuration)"
        }else{
             timerLabel.text = "00:\(addVideoVC.maxDuration)"
        }
        
       
        print(addVideoVC.maxDuration)
        if addVideoVC.maxDuration <= 1 {
            progressTimer.invalidate()
            
            //you can call stop recording here
        }
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL)
    {
        // Called when stopVideoRecording() is called and the video is finished processing
        // Returns a URL in the temporary directory where video is stored
        
        MBProgressHUD.hide(for: view, animated: true)
        if(self.navigationController != nil){
            progressTimer.invalidate()
            timerLabel.removeFromSuperview()
            if let vcs = self.navigationController?.viewControllers {
                let previousVC = vcs[vcs.count - 2]
                if previousVC is JournelThoughtsVC {
                    print("delegatePassUrl obj refrence",delegatePassUrl)
                    delegatePassUrl?.pass(data: url)
                    CommonFunctions.sharedInstance.popTocontroller(from: self)
                }else{
                    if SingletonPostModel.sharedInstance?.isEditingMode ?? false {
                        SingletonPostModel.sharedInstance?.isEditingMode = true
                        SingletonPostModel.sharedInstance?.postfile = url
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                    }else if (isFromPreviewVC ?? false){
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                        selectedPostVentsVideo?.post_upload_file = "\(url)"
                        isEditVentsVideo = true
                    }else{
                        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Preview, Data: url)
                    }
                }
            }
            
        }else{
            print(Constants.Global.MessagesStrings.SomethingWentWrong)
        }
        
        
        
        //        let data = NSData(contentsOf: url as URL)!
        //        print("File size before compression: \(Double(data.length / 1048576)) mb")
        //        let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")//m4a
        //        compresssVideo(inputURL: url as URL, outputURL: compressedURL) { (exportSession) in
        //            guard let session = exportSession else {
        //                return
        //            }
        //
        //            switch session
        //                .status {
        //            case .unknown:
        //                break
        //            case .waiting:
        //                break
        //            case .exporting:
        //                break
        //            case .completed:
        //                guard let compresssedData = NSData(contentsOf: compressedURL) else {
        //                    return
        //                }
        //                print("File size after compression: \(Double(compresssedData.length)) mb")
        //              //  CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Preview, Data: compressedURL)
        //
        //                //ARSLineProgress.hide()
        //               // CommonFunctions.sharedInstance.PresentTocontroller(from: self, ToController: .Preview, Data: compressedURL)
        //               CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Preview, Data: compressedURL)
        //                //self.move_Video_ToStatusDetailVC(path: compressedURL as NSURL)
        //
        //            case .failed:
        //                break
        //            case .cancelled:
        //                break
        //            }
        //
        //
        //        }
        
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        // Called when a user initiates a tap gesture on the preview layer
        // Will only be called if tapToFocus = true
        // Returns a CGPoint of the tap location on the preview layer
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        // Called when a user initiates a pinch gesture on the preview layer
        // Will only be called if pinchToZoomn = true
        // Returns a CGFloat of the current zoom level
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        // Called when user switches between cameras
        // Returns current camera selection
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        {
            
            
            
            if mediaType == "public.movie"
            {
                
                if let path = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
                {
                    let data = NSData(contentsOf: path as URL)!
                    print("File size before compression: \(Double(data.length / 1048576)) mb")
                    let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")//m4a
                    self.compresssVideo(inputURL: path as URL, outputURL: compressedURL) { (exportSession) in
                        guard let session = exportSession else {
                            return
                        }
                        switch session
                            .status {
                        case .unknown:
                            break
                        case .waiting:
                            break
                        case .exporting:
                            break
                        case .completed:
                            guard let compresssedData = NSData(contentsOf: compressedURL) else {
                                return
                            }
                            
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: {
                                    
                                    
                                    
                                    if(self.navigationController != nil){
                                        
                                        if let vcs = self.navigationController?.viewControllers {
                                            let previousVC = vcs[vcs.count - 2]
                                            if previousVC is JournelThoughtsVC
                                            {
                                                // Reminder
                                                self.delegatePassUrl?.pass(data: compressedURL)
                                                CommonFunctions.sharedInstance.popTocontroller(from: self)
                                            }
                                            else
                                            {
                                                if SingletonPostModel.sharedInstance?.isEditingMode ?? false
                                                {
                                                    SingletonPostModel.sharedInstance?.isEditingMode = true
                                                    SingletonPostModel.sharedInstance?.postfile = compressedURL
                                                    CommonFunctions.sharedInstance.popTocontroller(from: self)
                                                }
                                                else if (self.isFromPreviewVC ?? false)
                                                {
                                                    CommonFunctions.sharedInstance.popTocontroller(from: self)
                                                    selectedPostVentsVideo?.post_upload_file = "\(compressedURL)"
                                                    isEditVentsVideo = true
                                                }
                                                else
                                                {
                                                    CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Preview, Data: compressedURL)
                                                }
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        print(Constants.Global.MessagesStrings.SomethingWentWrong)
                                    }
                                    
                                   // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Preview, Data: compressedURL)
                                })
                                
                                
                            }
                            
                        case .failed:
                            break
                        case .cancelled:
                            break
                        }
                    }
                }
                else
                {
                    
                    self.dismiss(animated: true, completion: {
                        
                        CommonVc.AllFunctions.showAlert(message: "Sorry! this video does not have a correct path.", view: self, title: Constants.Global.ConstantStrings.KAppname)
                        
                    })
                }
            }
        }
    }
    
    //    @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    //    {
    //        var data = Data()
    //        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
    //
    //
    //
    //            if mediaType == "public.movie" {
    //
    //                let path = info["UIImagePickerControllerMediaURL"] as! NSURL
    //                print(path)
    //
    //                let data = NSData(contentsOf: path as URL)!
    //                print("File size before compression: \(Double(data.length / 1048576)) mb")
    //                let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + NSUUID().uuidString + ".mov")//m4a
    //                self.compresssVideo(inputURL: path as URL, outputURL: compressedURL) { (exportSession) in
    //                    guard let session = exportSession else {
    //                        return
    //                    }
    //                    switch session
    //                        .status {
    //                    case .unknown:
    //                        break
    //                    case .waiting:
    //                        break
    //                    case .exporting:
    //                        break
    //                    case .completed:
    //                        guard let compresssedData = NSData(contentsOf: compressedURL) else {
    //                            return
    //                        }
    //                        print("File size after compression: \(Double(compresssedData.length / 1048576)) mb")
    //
    //                        self.dismiss(animated: true, completion: {
    //                            //self.move_Video_ToStatusDetailVC(path: compressedURL as NSURL)
    //                        })
    //                    case .failed:
    //                        break
    //                    case .cancelled:
    //                        break
    //                    }
    //                }
    //            }
    //            print("Video Selected")
    //        }
    //
    //    }
}


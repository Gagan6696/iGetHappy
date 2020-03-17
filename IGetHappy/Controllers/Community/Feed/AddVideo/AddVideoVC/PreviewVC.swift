//
//  StorySelectVC.swift
//  StatusStoryDemo
//  Created by Taranjeet Singh on 8/8/18.
//  Copyright © 2018 Taranjeet Singh. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown

protocol AddVideoViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}
var isEditVentsVideo  = Bool()
var selectedPostVentsVideo : AllVentsModelDetail?
class PreviewVC: BaseUIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var upload : UIButton!
    @IBOutlet weak var btn_Play : UIButton!
    @IBOutlet weak var txtField_Status : UITextField!
    @IBOutlet weak var view_videoPlay : UIView!
    @IBOutlet weak var btn_playvideo : UIButton!
    //    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var anonymusButton: UIButton!
    
    //MARK: - Vaiables
    var presenter:AddVideoPresenter?
    var isPLayvideo = true
    var player : AVPlayer!
    var playerLayer :   AVPlayerLayer!
    var path : NSURL?
    var data : Data?
    let dropDown = DropDown()
    var isAnonymous:String?
    var parm = [String:Any]()
    var selectedPostData: [Post]?
    var isEdit: Bool = false
    
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEdit = SingletonPostModel.sharedInstance?.isEditingMode ?? false
        if(isEdit){
            self.txtField_Status.text = SingletonPostModel.sharedInstance?.postDescription
            self.isAnonymous = SingletonPostModel.sharedInstance?.isAnonymous
             self.lblPrivacy.text = SingletonPostModel.sharedInstance?.privacyOption
         //   self.showImageVideo()
            //self.path = SingletonPostModel.sharedInstance?.postfile
        }else if (isEditVentsVideo){
            self.txtField_Status.text = selectedPostVentsVideo?.desc
            self.isAnonymous = selectedPostVentsVideo?.is_anonymous
            self.lblPrivacy.text = selectedPostVentsVideo?.privacy_option
            //self.lblPrivacy.text = SingletonPostModel.sharedInstance?.privacyOption
        //    self.showImageVideo()
        }else{
            self.presenter = AddVideoPresenter.init(delegate: self)
            
            isAnonymous = UserDefaults.standard.getAnonymous()
            if isAnonymous == "YES"{
                anonymusButton.isSelected = false
            }else{
                anonymusButton.isSelected = true
            }
            
            self.presenter?.attachView(view: self)
            DispatchQueue.main.async {
                
                self.txtField_Status.attributedPlaceholder = NSAttributedString(string: "Write Something Here:",
                                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
                let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.backgroundTap(gesture:)));
                self.view.addGestureRecognizer(gestureRecognizer)
                
                
                // Do any additional setup after loading the view.
               /// self.showImageVideo()
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            self.dropDown.anchorView = self.btnDropDown
            // The list of items to display. Can be changed dynamically
            self.dropDown.dataSource = ["PUBLIC","FRIENDS","ONLYME"]
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if (index == 1)
                {
                    CommonVc.AllFunctions.showAlert(message: "Friends feature is coming soon!", view: self, title: Constants.Global.ConstantStrings.KAppname)
                    self.lblPrivacy.text = "PUBLIC"
                }else{
                    self.lblPrivacy.text = item
                }
            }
            DropDown.startListeningToKeyboard()
        }
        
        self.presenter = AddVideoPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        DispatchQueue.main.async {
            
            self.txtField_Status.attributedPlaceholder = NSAttributedString(string: "Write Something Here:",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.backgroundTap(gesture:)));
            self.view.addGestureRecognizer(gestureRecognizer)
            
            
            // Do any additional setup after loading the view.
            //self.showImageVideo()
            
        }
 
        isEdit = SingletonPostModel.sharedInstance?.isEditingMode ?? false
        if(isEdit){
            self.txtField_Status.text = SingletonPostModel.sharedInstance?.postDescription
            self.isAnonymous = SingletonPostModel.sharedInstance?.isAnonymous
            self.lblPrivacy.text = SingletonPostModel.sharedInstance?.privacyOption
            self.path = SingletonPostModel.sharedInstance?.postfile as? NSURL
          //  self.showImageVideo()
        }else if (isEditVentsVideo){
            self.txtField_Status.text = selectedPostVentsVideo?.desc
            self.isAnonymous = selectedPostVentsVideo?.is_anonymous
            self.lblPrivacy.text = selectedPostVentsVideo?.privacy_option
            // let isValid = self.verifyUrl(urlString: selectedPostVentsVideo?.post_upload_file)
            //if isValid{
            self.path =  NSURL.init(string: selectedPostVentsVideo?.post_upload_file ?? "")
            
            
           // self.showImageVideo()
            // }else{
            //  self.AlertMessageWithOkAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "File is corrupted.", Target: self) {
            //     CommonFunctions.sharedInstance.popTocontroller(from: self)
            // }
            //}
        }else{
            if self.selectedPostData?.first?.isEditingMode ?? false {
                self.isEdit = true
                
                SingletonPostModel.sharedInstance?.isEditingMode = true
                
                SingletonPostModel.sharedInstance?.postDescription = self.selectedPostData?.first?.postDescription
                
                SingletonPostModel.sharedInstance?.postfile = URL(string: self.selectedPostData?.first?.postfile ?? "")
                
                SingletonPostModel.sharedInstance?.postId = self.selectedPostData?.first?.postId
                SingletonPostModel.sharedInstance?.isAnonymous = self.selectedPostData?.first?.isAnonymous
                SingletonPostModel.sharedInstance?.privacyOption = self.selectedPostData?.first?.privacyOption
                self.txtField_Status.text = self.selectedPostData?.first?.postDescription
                self.path = NSURL(string: (self.selectedPostData?.first?.postfile)!)
                self.lblPrivacy.text = self.selectedPostData?.first?.privacyOption
                if self.selectedPostData?.first?.isAnonymous == "YES"{
                    self.anonymusButton.isSelected = false
                    isAnonymous = "Yes"
                }else{
                    self.anonymusButton.isSelected = true
                    isAnonymous = "No"
                }
               
            }
        }
          self.showImageVideo()
    }
    
    //MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //DispatchQueue.main.async {
            self.player?.pause()
            self.player = nil
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer = nil
      //  }
        isEditVentsVideo  = false
        
        
        
    }
    
    //MARK: - ButtonActions
    
    @IBAction func actionCross(_ sender: Any) {

        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .VideoRecord, Data: true)
    }
    
    @IBAction func ActionDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func anonymusButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            isAnonymous = "No"
        }else{
            isAnonymous = "Yes"
        }
    }
    
    @objc func backgroundTap(gesture : UITapGestureRecognizer) {
        txtField_Status.resignFirstResponder()// or view.endEditing(true)
    }
    
    @IBAction func ActionBtnUploadStory(_ sender: UIButton)
    {
        txtField_Status.resignFirstResponder()
        
        do {
            try presenter?.Validations(postText: self.txtField_Status.text, privacy: lblPrivacy.text, isAnonymous: isAnonymous)
            if self.checkInternetConnection(){
                
                if isEdit
                {
                    DispatchQueue.main.async {
                        self.showLoader()
                        if self.selectedPostData?.first?.postfile == self.path?.absoluteString
                        {
                            self.loadFileAsync(url: self.path! as URL) { (url, error) in
                                if(error == nil)
                                {
                                    DispatchQueue.main.async {
                                    self.presenter?.editVideoPost(postText: self.txtField_Status.text, privacy: self.lblPrivacy.text, isAnonymous: self.isAnonymous, MediaUrl: url as NSURL?, withPostID: SingletonPostModel.sharedInstance?.postId ?? "")
                                       
                                    }
                                }
                            }
                        }
                        else
                        {
                            self.presenter?.editVideoPost(postText: self.txtField_Status.text, privacy: self.lblPrivacy.text, isAnonymous: self.isAnonymous, MediaUrl: self.path!, withPostID: SingletonPostModel.sharedInstance?.postId ?? "")
                        }
                    }
                }
                else if (isEditVentsVideo)
                {
                    DispatchQueue.main.async {
                        let verify =  self.verifyUrl(urlString: selectedPostVentsVideo?.post_upload_file)
                        self.showLoader()
                        if verify
                        {
                            self.loadFileAsync(url: self.path! as URL) { (url, error) in
                                if(error == nil)
                                {
                                    self.presenter?.editVideoPost(postText: self.txtField_Status.text, privacy: self.lblPrivacy.text, isAnonymous: self.isAnonymous, MediaUrl: url as NSURL?, withPostID: selectedPostVentsVideo?._id ?? "")
                                }
                            }
                        }
                        else
                        {
                            self.presenter?.editVideoPost(postText: self.txtField_Status.text, privacy: self.lblPrivacy.text, isAnonymous: self.isAnonymous, MediaUrl: self.path!, withPostID: selectedPostVentsVideo?._id ?? "")
                        }
                    }
                }else{
                    self.showLoader()
                    self.presenter?.AddVideoPost(postText: self.txtField_Status.text, privacy: lblPrivacy.text, isAnonymous: isAnonymous, MediaUrl: path)
                }
            }else{
                self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
            }
        } catch let error {
            switch  error {
                //            case ValidationError.AddPost.emptyText:
            //                self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyText)
            case  ValidationError.AddPost.emptyPrivacy:
                self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyPrivacy)
            case  ValidationError.AddPost.emptyisAnonymous:
                self.view.makeToast(Constants.WriteThoughts.Validations.KEmptyisAnonymous)
            case  ValidationError.AddPost.textMaxLength:
                self.view.makeToast(Constants.WriteThoughts.Validations.KMaxtextLength)
            default:
                self.view.makeToast( Constants.Global.MessagesStrings.ServerError)
            }
            self.hideLoader()
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        CommonFunctions.sharedInstance.popTocontroller(from: self)
        self.isEdit = false
         isEditVentsVideo = false
        SingletonPostModel.sharedInstance?.isEditingMode = false
    }
    
    //Video will playing when click on play button
    @IBAction func play_Again(_ sender: Any) {
        
        if player != nil{
            if btn_Play.image(for: .normal) == UIImage.init(named: "addVideoPlay"){
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                } catch {
                    // report for an error
                }
                player.play()
                btn_Play.setImage(UIImage.init(named: "addVideoPauseButton"), for: .normal)
            }else{
                player.pause()
                btn_Play.setImage(UIImage.init(named: "addVideoPlay"), for: .normal)
            }
            
            if isPLayvideo == true{
                isPLayvideo = false
                NotificationCenter.default.addObserver(self, selector: #selector(PreviewVC.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
    }
}

//MARK: - Extensions
extension PreviewVC {
    
    //When video finishes this method is called
    @objc func finishedPlaying(_ myNotification:NSNotification) {
        btn_Play.setImage(UIImage.init(named: "addVideoPlay"), for: .normal)
        self.player?.pause()
        self.player = nil
      //  self.playerLayer?.removeFromSuperlayer()
        self.playerLayer = nil
        self.play_video(url: self.path! as URL)
    }
    
    //Show Image
    func showImageVideo(){
        DispatchQueue.main.async {
            if self.path != nil{
                self.play_video(url: self.path! as URL)
            }else{
                self.view.makeToast("video URL not found")
            }
        }
    }
    
    //All assets and video layer are intialize here
    func play_video(url: URL) {
        DispatchQueue.main.async {
            let asset = AVURLAsset.init(url: url)
            let duration =  asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            print("durationTime is",durationTime)
            DispatchQueue.main.async {
                self.player = AVPlayer(url: url)
                self.playerLayer = AVPlayerLayer(player: self.player)
                self.playerLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view_videoPlay.layer.addSublayer(self.playerLayer)
                self.view_videoPlay.addSubview(self.btn_Play)
                if self.isEdit {
                    //SingletonPostModel.sharedInstance?.isEditingMode = true
                    // SingletonPostModel.sharedInstance?.isEditingMode = false
                    
                    self.view_videoPlay.addSubview(self.btnCross)
                }else if(isEditVentsVideo){
                    //self.isEditVentsVideo = false
                    self.view_videoPlay.addSubview(self.btnCross)
                    self.view_videoPlay.bringSubviewToFront(self.btnCross)
                }else{
                    self.btnCross.isHidden = true
                }
            }
        }
    }
}

extension PreviewVC:AddVideoDelegate
{
    func AddVideoDidSucceeed(message: String?)
    {
        
        hideLoader()
        SingletonPostModel.sharedInstance?.isEditingMode = false
        if(isEditVentsVideo == true)
        {
            isEditVentsVideo = false
            selectedPostVentsVideo = nil
            CommonFunctions.sharedInstance.popTocontroller(from: self)
        }
        

        for controller in self.navigationController!.viewControllers as Array
        {
            if controller.isKind(of: BaseTabVC.self)
            {
                self.AlertMessageWithOkAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: message ?? "Post has been uploaded successfully", Target: self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    
                }
                break
            }
        }
    }
    
    func AddVideoDidFailed(message: String?)
    {
        hideLoader()
        self.showAlert(Message: message ?? Constants.Global.MessagesStrings.ServerError)
    }
}

extension PreviewVC:AddVideoViewDelegate
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

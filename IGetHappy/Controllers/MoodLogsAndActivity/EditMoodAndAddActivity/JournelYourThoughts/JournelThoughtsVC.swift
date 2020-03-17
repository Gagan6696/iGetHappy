//
//  JournelThoughtsVC.swift
//  IGetHappy
//  Created by Gagan on 10/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import DropDown
import AVKit

protocol JournelYourThoughtsViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class JournelThoughtsVC: BaseUIViewController
{
    
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var viewAudio: CustomUIView!
    @IBOutlet weak var viewVideo: UIView!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var btnPlayAudio: UIButton!
    @IBOutlet weak var btnPlayVideo: UIButton!
    
    @IBOutlet weak var btnCrossVideo: UIButton!
    
    var presenter:JournelYourThoughtsPresenter?
    var currentTimeInterval:CMTime?
    var mediaUrl = String()
    let dropDown = DropDown()
    var player : AVPlayer!
    var playerLayer :   AVPlayerLayer!
    var isPLayvideo = true
     let playerViewController = AVPlayerViewController()
    var Edit_Data_Journal : [MoodLogDetails]?
    var editEvent_has_attached_new_file = "0" //I am creating this because in edit event if user has recorded somehitng then  it shud be update
    
    override func viewDidLoad()
    {
        JournelYourThoughtsPresenter.ref_Journal = self
        super.viewDidLoad()
        self.viewVideo.isHidden  = true
        self.viewAudio.isHidden  = true
        self.presenter = JournelYourThoughtsPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.txtViewDescription.delegate = self
        DispatchQueue.main.async {
            self.dropDown.anchorView = self.lblPrivacy
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
        
        
        if (Edit_Data_Journal?.count ?? 0 > 0)
        {
            let obj = Edit_Data_Journal?[0]
            EditMoodActivityData.sharedInstance?.post_upload_type = obj?.post_upload_type
            EditMoodActivityData.sharedInstance?.post_upload_file = URL(string: obj?.post_upload_file ?? "")
            EditMoodActivityData.sharedInstance?.user_id = obj?.user_id
            EditMoodActivityData.sharedInstance?.privacy_option = obj?.privacy_option
            EditMoodActivityData.sharedInstance?.description = obj?.description
            if (obj?.post_upload_type == "TEXT"){
                mediaUrl = ""
            }else{
                mediaUrl = obj?.post_upload_file ?? ""
            }
            txtViewDescription.text = obj?.description
            lblPrivacy.text = obj?.privacy_option
            
            if (lblPrivacy.text?.count == 0)
            {
                lblPrivacy.text = "PUBLIC"
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let audioSession = AVAudioSession.sharedInstance()
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch let error as NSError {
            print(error.localizedDescription)
            print("audioSession error: \(error.localizedDescription)")
            return
        }
        btnPlayAudio.tag = 0
        btnPlayAudio.setImage(UIImage(named: "addVideoPlay"), for: .normal)
     
        
    
        if(mediaUrl != "")
        {
            
            if mediaUrl.contains(".wav")
            {
                EditMoodActivityData.sharedInstance?.post_upload_type = "AUDIO"
                self.viewVideo.isHidden  = true
                self.viewAudio.isHidden  = false
                NotificationCenter.default.addObserver(self, selector: #selector(JournelThoughtsVC.finishedPlayingAudio(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
            else
            {
                EditMoodActivityData.sharedInstance?.post_upload_type = "VIDEO"
                self.viewVideo.isHidden  = false
                self.viewAudio.isHidden  = true
            }
            
        }
        else
        {
            EditMoodActivityData.sharedInstance?.post_upload_type = "TEXT"
            self.viewVideo.isHidden  = true
            self.viewAudio.isHidden  = true
        }
        
        
    }
    
    //MARK: - ViewDidDisappear
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async {
            self.player?.pause()
            self.playerViewController.player?.pause()
            self.playerViewController.removeFromParent()
            self.playerViewController.player = nil
            self.player = nil
            self.playerLayer?.removeFromSuperlayer()
            self.playerLayer = nil
        }
        self.dismissKeyboard()
     NotificationCenter.default.removeObserver(self)
    }
    
    
    
    @IBAction func playVideo(_ sender: Any)
    {
        
        if player != nil
        {
            if btnPlayVideo.image(for: .normal) == UIImage.init(named: "addVideoPlay")
            {
                do
                {
                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                }
                catch
                {
                    // report for an error
                }
                player.play()
                btnPlayVideo.setImage(UIImage.init(named: "addVideoPauseButton"), for: .normal)
            }
            else
            {
                player.pause()
                btnPlayVideo.setImage(UIImage.init(named: "addVideoPlay"), for: .normal)
            }
            
            if isPLayvideo == true
            {
                isPLayvideo = false
                NotificationCenter.default.addObserver(self, selector: #selector(JournelThoughtsVC.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }
        else
        {
            DispatchQueue.main.async {
                
                if(self.mediaUrl.count > 0)
                {
                    let asset = AVURLAsset.init(url: URL.init(string: self.mediaUrl)!)
                    let duration =  asset.duration
                    let durationTime = CMTimeGetSeconds(duration)
                    print("durationTime is",durationTime)
                    DispatchQueue.main.async {
//                        self.player = AVPlayer(url: URL.init(string: self.mediaUrl)!)
//                        self.playerLayer = AVPlayerLayer(player: self.player)
//                        self.playerLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                        self.viewVideo.layer.addSublayer(self.playerLayer)
//                        self.viewVideo.addSubview(self.btnPlayVideo)
//                        self.player.play()
                        let player = AVPlayer(url: URL.init(string: self.mediaUrl)!)
                        self.playerViewController.player = player
                        self.addChild(self.playerViewController)
                        // Add your view Frame
                        self.playerViewController.view.frame = self.viewVideo.bounds
                        // Add sub view in your view
                        self.viewVideo.addSubview(self.playerViewController.view)
                        self.playerViewController.player?.play()
                        self.viewVideo.addSubview(self.btnCrossVideo)
                        self.viewVideo.bringSubviewToFront(self.btnCrossVideo)
                        
                    }
                }
                else
                {
                    self.view.makeToast(Constants.Global.MessagesStrings.SomethingWentWrong)
                }
            }
        }
        
    }
    
    @IBAction func actionShowDropDown(_ sender: Any)
    {
        dropDown.show()
    }
    
    @IBAction func playAudio(_ sender: Any)
    {
        if btnPlayAudio.tag == 0
        {
            if(currentTimeInterval == nil)
            {
                player = nil
                
                if (Edit_Data_Journal?.count ?? 0 > 0)
                {
                    let url = EditMoodActivityData.sharedInstance?.post_upload_file
                    let playerItem = AVPlayerItem(url: url ?? URL(string: "www.google.com")!)
                    player = AVPlayer(playerItem: playerItem)
                    player?.play()
                    
                }
                else
                {
                    let asset = AVURLAsset(url: URL.init(string: mediaUrl)!)
                    let playerItem = AVPlayerItem(asset: asset)
                    player = AVPlayer(playerItem: playerItem)
                    player?.play()
                }
            }
            else
            {
                let asset = AVURLAsset(url: URL.init(string: mediaUrl)!)
                let playerItem = AVPlayerItem(asset: asset)
                player = AVPlayer(playerItem: playerItem)
                player?.play()
            }
            
            btnPlayAudio!.setImage(UIImage(named: "addVideoPauseButton"), for: .normal)
            btnPlayAudio!.setTitle("Pause", for: UIControl.State.normal)
            btnPlayAudio.tag = 1
        }
        else
        {
           // if player != nil
           // {
                player?.pause()
                currentTimeInterval = player.currentTime()
                btnPlayAudio?.setImage(UIImage(named: "addVideoPlay"), for: .normal)
                btnPlayAudio?.setTitle("Play", for: UIControl.State.normal)
                btnPlayAudio.tag = 0
          //  }
        }
    }
    
    
    
    @IBAction func actionCrossVideo(_ sender: Any)
    {
        player?.pause()
        player = AVPlayer()
        mediaUrl = ""
        self.viewVideo.isHidden  = true
        self.viewAudio.isHidden  = true
        EditMoodActivityData.sharedInstance?.post_upload_file = URL.init(string: " ")
        EditMoodActivityData.sharedInstance?.post_upload_type = "TEXT"
    }
    
    @IBAction func actionCrossAudio(_ sender: Any)
    {
        btnPlayAudio.tag = 0
        btnPlayAudio.setImage(UIImage(named: "addVideoPlay"), for: .normal)
        player?.pause()
        player = AVPlayer()
        mediaUrl = ""
        self.viewVideo.isHidden  = true
        self.viewAudio.isHidden  = true
        EditMoodActivityData.sharedInstance?.post_upload_file = URL.init(string: " ")
        EditMoodActivityData.sharedInstance?.post_upload_type = "TEXT"
    }
    
    @IBAction func actionBack(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func actionMic(_ sender: Any) {
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AudioRecord, Data: nil)
        self.dismissKeyboard()
        Constants.isFromHappyMemories = true
        let navigation = UIStoryboard.init(name: "Auth", bundle: nil)
        // let pickerUserVC = navigation.viewControllers.first as! RecordAudioVC
        //  self.present(navigation, animated: true, completion: nil)
        //Global Variable used for record audio
        
        
        let goNext = navigation.instantiateViewController(withIdentifier: "RecordAudioVC") as! RecordAudioVC
        goNext.delegatePassUrl = self
        self.navigationController?.pushViewController(goNext, animated: true)
    }
    
    @IBAction func actionCamera(_ sender: Any)
    {
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .VideoRecord, Data: nil)
        self.dismissKeyboard()
        let navigation = UIStoryboard.init(name: "Auth", bundle: nil)
        // let pickerUserVC = navigation.viewControllers.first as! RecordAudioVC
        //  self.present(navigation, animated: true, completion: nil)
        //Global Variable used for record audio
        
        
        let goNext = navigation.instantiateViewController(withIdentifier: "addVideoVC") as! addVideoVC
        goNext.delegatePassUrl = self
        self.navigationController?.pushViewController(goNext, animated: true)
        
    }
    
    @IBAction func actionPost(_ sender: Any)
    {
        
        self.player?.pause()
        btnPlayAudio.tag = 0
        btnPlayAudio.setImage(UIImage(named: "addVideoPlay"), for: .normal)
        let finalText = self.txtViewDescription.text
        
        if(finalText!.contains("E.g. I have a job interview") || finalText == "")
        {
            //CommonVc.AllFunctions.showAlert(message: "Please add some text information to make a post.", view: self,  title:Constants.Global.ConstantStrings.KAppname)
            
            EditMoodActivityData.sharedInstance?.user_id = UserDefaults.standard.getUserId()
            EditMoodActivityData.sharedInstance?.privacy_option = self.lblPrivacy.text
            EditMoodActivityData.sharedInstance?.description = " "
            self.showLoader()
            self.presenter?.GetAllListCareReciever()
            
        }
        else
        {
            EditMoodActivityData.sharedInstance?.user_id = UserDefaults.standard.getUserId()
            EditMoodActivityData.sharedInstance?.privacy_option = self.lblPrivacy.text
            EditMoodActivityData.sharedInstance?.description = finalText
            self.showLoader()
            self.presenter?.GetAllListCareReciever()
        }
    }
    
}

extension JournelThoughtsVC
{
    @objc func playerItemDidPlayToEndTime()
    {
        // load next video or something
        btnPlayAudio!.setImage(UIImage(named: "addVideoPlay"), for: .normal)
        btnPlayAudio!.setTitle("Play", for: UIControl.State.normal)
        btnPlayAudio.tag = 0
        currentTimeInterval = nil
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    //When video finishes this method is called
    @objc func finishedPlaying(_ myNotification:NSNotification) {
        btnPlayVideo.setImage(UIImage.init(named: "addVideoPlay"), for: .normal)
        self.play_video(url: URL.init(string: self.mediaUrl)!)
    }
    @objc func finishedPlayingAudio(_ myNotification:NSNotification) {
        //btnPlayAudio.setImage(UIImage.init(named: "addVideoPlay"), for: .normal)
           btnPlayAudio.setImage(UIImage(named: "addVideoPlay"), for: .normal)
         btnPlayAudio.tag = 0
    }
    
    //Show Image
    func showImageVideo()
    {
        DispatchQueue.main.async {
            if self.mediaUrl != nil
            {
                self.play_video(url: URL.init(string: self.mediaUrl)!)
            }
            else
            {
                self.view.makeToast("video URL not found")
            }
        }
    }
    
    //All assets and video layer are intialize here
    func play_video(url: URL)
    {
        
        
        DispatchQueue.main.async {
            
            var fileURL = url
            if (self.Edit_Data_Journal?.count ?? 0 > 0)
            {
                fileURL = EditMoodActivityData.sharedInstance?.post_upload_file ?? URL(string: "www.google.com")!
            }
            
            //            let asset = AVURLAsset.init(url: url)
            //            let duration =  asset.duration
            //            let durationTime = CMTimeGetSeconds(duration)
            
            DispatchQueue.main.async {
//                self.player = AVPlayer(url: fileURL)
//                self.playerLayer = AVPlayerLayer(player: self.player)
//                self.playerLayer.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                self.viewVideo.layer.addSublayer(self.playerLayer)
//                self.viewVideo.addSubview(self.btnPlayVideo)
                
                let player = AVPlayer(url: fileURL)
                self.playerViewController.player = player
                self.addChild(self.playerViewController)
                
                // Add your view Frame
                self.playerViewController.view.frame = self.viewVideo.bounds
                
                // Add sub view in your view
                self.viewVideo.addSubview(self.playerViewController.view)
                self.playerViewController.player?.play()
                 self.viewVideo.addSubview(self.btnCrossVideo)
                 self.viewVideo.bringSubviewToFront(self.btnCrossVideo)
                
            }
        }
    }
    
    
    func handle_success_and_pop_controller()
    {
        // Create the alert controller
        let alertController = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: "Mood log updated successfully!", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}

extension JournelThoughtsVC:ReceiveData
{
    func pass(data: URL)
    {
        mediaUrl  = "\(data)"
        
        if (Edit_Data_Journal?.count ?? 0 > 0)
        {
            self.editEvent_has_attached_new_file = "1"
            EditMoodActivityData.sharedInstance?.change_file_status = "YES"
        }
        else
        {
            EditMoodActivityData.sharedInstance?.change_file_status = "NO"
        }
        
        
        
        EditMoodActivityData.sharedInstance?.post_upload_file = data
        if mediaUrl.contains(".wav"){
              btnPlayAudio.tag = 0
        }else{
              self.playVideo(self)
        }
        
      
        //        self.loadFileAsync(url: URL.init(string: self.mediaUrl)!
        //            ) { (url, error) in
        //            if(error == nil){
        //                EditMoodActivityData.sharedInstance?.post_upload_file = url
        //            }
        // }
    }
    
}
extension JournelThoughtsVC:JournelYourThoughtsDelegate{
    
    func JournelYourThoughtsDidSucceeed(data: String?)
    {
        self.hideLoader()
        
        self.AlertMessageWithOkAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "This thought has been saved to your Journal", Target: self) {
            
//            if let viewControllers = self.navigationController?.viewControllers {
//                for viewController in viewControllers {
//                    // some process
//                    if viewController.isKind(of: CommunityListingViewController.self) {
//                        guard let homeVC = self.navigationController?.getReference(to: CommunityListingViewController.self) else { return }
//                        // Pass variables if needed.
//                        self.navigationController?.popToViewController(homeVC, animated: true)
//                    }
//                    }
//                }
            //}
            
            self.backTwo()
        }
        EditMoodActivityData.sharedInstance?.Reinitilize()
       
        //self.AlertWithNavigatonPurpose(message: data ?? "", navigationType: .pop, ViewController: .Home, rootViewController: .none, Data: nil)
        
        // self.showAlert(Message: data ?? "")
        
    }
    
    func JournelYourThoughtsDidFailed(message:String?)
    {
        self.hideLoader()
        self.showAlert(Message: message ?? "")
    }
    
    
}

extension JournelThoughtsVC:JournelYourThoughtsViewDelegate{
    func showAlert(alertMessage: String)
    {
        hideLoader()
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}
extension JournelThoughtsVC:UITextViewDelegate
{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if(self.txtViewDescription.text.contains("E.g. I have a job interview"))
        {
            self.txtViewDescription.text = nil
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if txtViewDescription.text.isEmpty
        {
            txtViewDescription.text = "E.g. I have a job interview"
          
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

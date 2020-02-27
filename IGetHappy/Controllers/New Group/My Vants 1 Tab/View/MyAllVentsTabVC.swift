//
//  MyAllVentsTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import MBProgressHUD
import AVKit
import AVFoundation
import FTPopOverMenu_Swift

protocol AllVentsViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    func getSharedPostList()
   // func filterArray(searchText:String)
    func search_dismiss()
}

protocol RefreshTableFromCell:class{
    func refreshTable()
}

class MyAllVentsTabVC: BaseUIViewController,AVAudioPlayerDelegate
{
    //MARK: <-OUTLETS ->
    @IBOutlet weak var myTableView: UITableView!
    
   
    
    //MARK: <- VARIABLES->
    let cellID = "CellClass_MyVentsTab"
    let cellIDPrivate = "CellClassMyVentsPrivate"
    let cellIDAudio = "CellClass_MyVentsPlayer"
    let cellIDFeeling = "CellClassMyVentsFeeling"
    var presenter:AllVentsPresenter?
    var apiDATA:[AllVentsModelDetail] = []
    var apiDATA_filter:[AllVentsModelDetail] = []
    let userName = UserDefaults.standard.getFirstName()
    //var searchActiveAllVents = false
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    let playerViewController = AVPlayerViewController()
    var audioPlayer:AVPlayer?
    let stopAudioObserver = NotificationCenter.default
    var selectedIndexForMusicPlayer = String()
    var fromPrivate = false
     var playing = false
    var selectedAudio:Int = -1
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MyVentsTabVC.refNew = self
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 200
        self.presenter = AllVentsPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
       
        //NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.callToApi(searchKeyWord: "")
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        self.audioPlayer?.pause()
        self.audioPlayer = nil
        self.playerViewController.player?.pause()
      // self.playerViewController.player = nil
        NotificationCenter.default.removeObserver(self)
        self.fromPrivate = false
    }
    
//    @objc func playerDidFinishPlaying(note: NSNotification)
//    {
//
//      //  self.playerViewController.player = nil
//        //self.player = nil
//       // self.myTableView.reloadData()
//        print("Video Finished")
//    }
    
    
    @IBAction func actionDropDown(_ sender: UIButton)
    {
        var moodID = ""
        
         print(sender.tag)
        let obj = apiDATA[sender.tag]
    
        FTPopOverMenu.showForSender(sender: sender, with: ["Delete", "Edit"], done: { (selected) in
            switch selected
            {
            case 0:
                self.presenter?.deletePostVents(post_id: obj._id ?? "")
                break
            case 1:
                self.editPostVents(selectedPostVent:obj)
                break
            default:
                break
            }
        })
        {
            
        }
    }
    
    
    func callToApi(searchKeyWord:String)
    {
        presenter?.CALL_API_GET_SHARED_POSTS(searchKeyword: searchKeyWord, startDate: "", endDate: "", limit: "", skip: "")
    }
    
    func call_api_filter_approach(frndlist:Bool,date:Bool,strtDate:String,endDate:String)
    {
        
        if (frndlist == true && date == true)
        {
           presenter?.CALL_API_GET_SHARED_POSTS(searchKeyword: "", startDate: strtDate, endDate: endDate, limit: "", skip: "")
        }
        else if (frndlist == true)
        {
           presenter?.CALL_API_GET_SHARED_POSTS(searchKeyword: "", startDate: "", endDate: "", limit: "", skip: "")
        }
        else if (date == true)
        {
            presenter?.CALL_API_GET_SHARED_POSTS(searchKeyword: "", startDate: strtDate, endDate: endDate, limit: "", skip: "")
        }
        else
        {
            presenter?.CALL_API_GET_SHARED_POSTS(searchKeyword: "", startDate: "", endDate: "", limit: "", skip: "")
        }
        
    }
    
    func editPostVents(selectedPostVent:AllVentsModelDetail){
        
        print(selectedPostVent)
        if selectedPostVent.post_upload_type == Constants.PostType.text
        {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .WriteThoughts, Data:selectedPostVent)
        }
        else if selectedPostVent.post_upload_type == Constants.PostType.video
        {
            CommonFunctions.sharedInstance.PushToContrllerForEdit(from: self, ToController: .Preview, Data: selectedPostVent)
        }
        else
        {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AudioRecord, Data: selectedPostVent)
        }
    }
    //func filterArray(searchText:String)
//    {
//       // searchActiveAllVents = true
//        self.apiDATA_filter.removeAll()
//
//        if (self.apiDATA.count > 0)
//        {
//            for obj in self.apiDATA
//            {
//                let str = obj.desc ?? ""
//
//                if let _ = str.range(of: searchText, options: .caseInsensitive)
//                {
//                    self.apiDATA_filter.append(obj)
//                }
//            }
//
//            self.myTableView.reloadData()
//        }
//    }
    
    func search_dismiss()
    {
       // searchActiveAllVents = false
        //self.apiDATA_filter.removeAll()
        self.myTableView.reloadData()
    }
    
    
    func configureData_private()
    {
        //searchActiveAllVents = false
        self.fromPrivate = true
        var temp:[AllVentsModelDetail] = []
        for obj in apiDATA
        {
            if (obj.privacy_option == "ONLYME")
            {
                temp.append(obj)
            }
        }
        
        apiDATA = temp
        self.myTableView.reloadData()
    }

    @IBAction func playVideo(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
        let cell  = self.myTableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! CellClassMyVentsVideoCell
        let obj = apiDATA[sender.tag]
        let player = AVPlayer(url: URL.init(string: obj.post_upload_file ?? "")!)
        self.playerViewController.player = player
        
        self.addChild(self.playerViewController)
        
        // Add your view Frame
        self.playerViewController.view.frame = cell.videoView.bounds
        
        // Add sub view in your view
        cell.videoView.addSubview(self.playerViewController.view)
        self.playerViewController.player?.play()
    }
    
   // @IBAction func playAudio(_ sender: UIButton)
//    {
//        let cell  = self.myTableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! CellClass_MyVentsPlayer
//
//        //cell.audioSlider!.addTarget(self, action: #selector(paybackSliderValueDidChange),for: .valueChanged)
//        let obj = apiDATA[sender.tag]
//
//       //Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: cell, repeats: true)
//
//       // cell.audioSlider!.value = 0.0
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected
//        {
//            setupAudioContent(url: obj.post_upload_file, index: sender.tag)
//        }
//        else
//        {
//            player?.pause()
//        }
//
//
//    }

//    @objc func updateTime(_ timer: Timer) {
//        let cell = timer.userInfo as! CellClass_MyVentsPlayer
//
//
//       // cell.audioSlider!.value = Float(audioPlayer?.currentTime ?? 0.0)
//        let seconds : Int64 = Int64(cell.audioSlider.value)
//        //let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//        cell.audioSlider!.value =
//            Float(audioPlayer?.currentTime().value ?? Int64(0.0))
//    }

//    @IBAction func slide(_ slider: UISlider)
//    {
//
//         let cell  = self.myTableView.cellForRow(at: IndexPath.init(row: slider.tag, section: 0)) as! CellClass_MyVentsPlayer
//
//        //audioPlayer?.seek(to: CMTime.init(seconds:Double(cell.audioSlider!.value) , preferredTimescale: CMTimeScale(0.0)))
//        let seconds : Int64 = Int64(cell.audioSlider.value)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//
//        player!.seek(to: targetTime)
//        if player!.rate == 0
//        {
//            player?.play()
//        }
//
//    }
    
//    @objc func paybackSliderValueDidChange(sender: UISlider!)
//    {
//        let cell  = self.myTableView.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! CellClass_MyVentsPlayer
//        let seconds : Int64 = Int64(cell.audioSlider.value)
//        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
//
//        player!.seek(to: targetTime)
//
//        if player!.rate == 0
//        {
//            player?.play()
//        }
//    }

    
    
    
    
//    public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//
//
//
//        if object is AVPlayerItem {
//            switch keyPath {
//            case "playbackBufferEmpty":
//
//                break
//
//                // Show loader
//
//            case "playbackLikelyToKeepUp":
//
//                break
//                // Hide loader
//
//            case "playbackBufferFull":
//
//                break
//                // Hide loader
//            case .none:
//
//                break
//
//            case .some(_):
//
//                break
//
//            }
//        }
//    }
    
//        }else  {
//            stopMusic()
//            guard let url = URL(string: url ?? "")
//                else { return }
//
//            NotificationCenter.default.addObserver(self,
//                                                   selector:#selector(self.didEndPlayback),
//                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                                                   object:nil)
//            let error: NSError?
//            do {
//                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
//            }
//            catch let error {
//                print(error)
//            }
//            self.audioPlayer?.play()
      //  }
        
      
   // }
    
    @objc func playBtnAction(sender:UIButton)
    {
        let indxData = apiDATA[sender.tag]
        let pathNew = indxData.post_upload_file
        self.playerViewController.player?.pause()
        if (indxData.post_upload_type == Constants.PostType.audio)
        {
            
            if (selectedAudio == sender.tag){
                
                if playing == false{
                    playing = true
                    audioPlayer?.pause()
                    selectedAudio = sender.tag
                    self.refreshTable()
                }else{
                    playing = false
                    audioPlayer?.play()
                    selectedAudio = sender.tag
                    self.refreshTable()
                }
                
            }else{
                selectedAudio = sender.tag
                if(playing == true)
                {
                    audioPlayer?.pause()
                    playing = false
                    selectedAudio = -1
                    self.refreshTable()
                    // self.SET_UP_AUDIO(path:pathNew)
                }
                else
                {
                    self.SET_UP_AUDIO(path:pathNew ?? "")
                }
            }
            
            
        }
  
    }
    
    func SET_UP_AUDIO(path:String)
    {
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled), name: .AVPlayerItemPlaybackStalled, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(didEndPlayback),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object:nil)
        
        let urlMusicString = path.trimmingCharacters(in: .whitespacesAndNewlines)
        // guard let url = URL(string: urlMusicString ?? "") else { return complete(.unvalidURL) }
        guard let url = URL(string: urlMusicString ?? "")
            else { return }
        let isValidUrl = AVAsset(url: url).isPlayable
        print(url)
        
        if isValidUrl{
            audioPlayer = AVPlayer(url: url as URL)
            print("1st ref when create ",audioPlayer)
            //self.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
            
            playing  = false
            audioPlayer?.play()
            self.refreshTable()
            
        }else{
            self.view.makeToast("File is corrupted")
        }
        
    }
    

    
    @objc func didEndPlayback(note: NSNotification)
    {
        
        //btnPlay.isSelected = false
        print("didEndPlayback called")
        selectedAudio = -1
        
        playing = false
        self.refreshTable()
    }
 
    @objc func itemFailedToPlayToEndTime(note: NSNotification)
    {
        print("itemFailedToPlayToEndTime called")
        selectedAudio = -1
        
        playing = false
        self.refreshTable()
        //btnPlay.isSelected = false
    }
    @objc func itemNewErrorLogEntry(note: NSNotification)
    {
        print("itemNewErrorLogEntry called")
       selectedAudio = -1
        
        playing = false
        self.refreshTable()
        //btnPlay.isSelected = false
    }
    @objc func itemPlaybackStalled(note: NSNotification)
    {
        print("itemPlaybackStalled called")
        selectedAudio = -1
        
        playing = false
        self.refreshTable()
    }
    
    
    
}
extension MyAllVentsTabVC : RefreshTableFromCell{
    func refreshTable() {
        print("refresh called")
        self.myTableView.reloadData()
    }
    
    
}
extension MyAllVentsTabVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if (searchActiveAllVents == true)
//        {
//            return apiDATA_filter.count
//        }
        return apiDATA.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        let obj = apiDATA[indexPath.row]
        
        if (obj.post_upload_type == "AUDIO")
        {
            

            let myCell = myTableView.dequeueReusableCell(withIdentifier: CellClass_MyVentsPlayer.className) as! CellClass_MyVentsPlayer

            myCell.btnPlay.tag = indexPath.row
            myCell.btnPlay.addTarget(self, action: #selector(playBtnAction(sender:)), for: .touchUpInside)
            if (indexPath.row == selectedAudio)
            {
                if playing == true{
                     myCell.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
                }else{
                    myCell.btnPlay.setImage(UIImage.init(named: "community_audio_pause"), for: .normal)
                    
                }
               //myCell.btnPlay.isSelected = false
            }
            else
            {
                myCell.btnPlay.setImage(UIImage.init(named: "community_audio_play"), for: .normal)
                 //myCell.btnPlay.isSelected = false
            }
            
            
//            if(myCell.selectedIndex == indexPath.row)
//            {
//                //myCell.btnPlay.isSelected = false
//            }
//            else
//            {
//
//                myCell.stopMusic()
//                myCell.btnPlay.isSelected = false
//            }
            
            if(obj.privacy_option == "ONLYME")
            {
                myCell.ivPrivacy.image = UIImage(named:"Myventslock")
                myCell.bgViewAudio.backgroundColor = UIColor.init(hex: 0x152A35)
                myCell.btnLike.setTitleColor(UIColor.white, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.white
                myCell.btnShare.imageView?.tintColor = UIColor.white
                myCell.btnLike.imageView?.tintColor = UIColor.white
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblName.textColor = UIColor.white
                myCell.lblDate.textColor = UIColor.init(hex: 0x999999)
                myCell.txtViewDesc.textColor = UIColor.white
                myCell.lblPrivacyText.textColor = UIColor.init(hex: 0x999999)
                 myCell.lblPrivacyText.text = "Private vent"
                
            }
            else
            {
                
                myCell.ivPrivacy.image = UIImage(named:"journelWorld")
                if(obj.privacy_option == "FRIENDS")
                {
                    myCell.ivPrivacy.image = UIImage(named:"friends")
                }
                
                myCell.bgViewAudio.backgroundColor = UIColor.init(hex: 0xE5E5E5)
                myCell.btnLike.setTitleColor(UIColor.black, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.black
                myCell.btnShare.imageView?.tintColor = UIColor.black
                myCell.btnLike.imageView?.tintColor = UIColor.black
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblName.textColor = UIColor.black
                myCell.lblDate.textColor = UIColor.init(hex: 0x999999)
                myCell.lblPrivacyText.textColor = UIColor.init(hex: 0x999999)
                myCell.txtViewDesc.textColor = UIColor.black
                //myCell.lblDesc.textColor = UIColor.black
               // myCell.ivPrivacy.tintColor = UIColor.black
               myCell.lblPrivacyText.text = "Public vent"
                
            }
          //  myCell.audioSlider.tag = indexPath.row
            myCell.btnDropDownAudio.tag = indexPath.row
            myCell.btnComment.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnShare.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnLike.setTitle("\(obj.numOfLikes!)", for: .normal)
//            myCell.btnLike.titleLabel?.text = "\(obj.numOfLikes!)"
//            myCell.btnShare.titleLabel?.text = "\(obj.numOfShared!)"
//            myCell.btnComment.titleLabel?.text = "\(obj.numOfComments!)"
            
            myCell.lblName.text = userName
          
            
            
            let localDate = Utility.UTCToLocal(UTCDateString: obj.created_at ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
             myCell.lblDate.text = Utility.dateConvertToISOString(string: localDate)
            
           // myCell.lblDate.text = Utility.dateConvertToISOString(string: localDate)
            myCell.btnPlay.tag = indexPath.row
            myCell.txtViewDesc.text = obj.desc
           // myCell.urlSong = obj.post_upload_file
          //  myCell.callRefreshTable = self
            myCell.lblPrivacyText.text = obj.privacy_option
            let url = URL(string:  obj.profile_image ?? "")
            myCell.ivUser.kf.indicatorType = .activity
            myCell.ivUser.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])

            cell = myCell
        }
        else if (obj.post_upload_type == "VIDEO")
        {
            let myCell = myTableView.dequeueReusableCell(withIdentifier: CellClassMyVentsVideoCell.className) as! CellClassMyVentsVideoCell
            if(obj.privacy_option == "ONLYME")
            {
                myCell.bgViewVideoCell.backgroundColor = UIColor(red: 21/255.0, green: 42/255.0, blue: 53/255.0, alpha: 1.0)
                
                myCell.lblDesc.text = obj.desc
                myCell.ivPrivacy.image = UIImage(named:"Myventslock")
                myCell.btnLike.setTitleColor(UIColor.white, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.white
                myCell.btnShare.imageView?.tintColor = UIColor.white
                myCell.btnLike.imageView?.tintColor = UIColor.white
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblPrivacy.text = "Private vent"
                myCell.lblName.textColor = UIColor.white
                myCell.lblTime.textColor = UIColor.init(hex: 0x999999)
                myCell.lblDesc.textColor = UIColor.white
                myCell.lblPrivacy.textColor = UIColor.init(hex: 0x999999)
            }
            else
            {
                myCell.ivPrivacy.image = UIImage(named:"journelWorld")
                if(obj.privacy_option == "FRIENDS")
                {
                    myCell.ivPrivacy.image = UIImage(named:"friends")
                }
                
                myCell.bgViewVideoCell.backgroundColor = UIColor.init(hex: 0xE5E5E5)
                myCell.btnLike.setTitleColor(UIColor.black, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.black
                myCell.btnShare.imageView?.tintColor = UIColor.black
                myCell.btnLike.imageView?.tintColor = UIColor.black
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblName.textColor = UIColor.black
                myCell.lblTime.textColor = UIColor.init(hex: 0x999999)
                myCell.lblDesc.textColor = UIColor.black
                myCell.lblPrivacy.textColor = UIColor.init(hex: 0x999999)
                myCell.ivPrivacy.tintColor = UIColor.lightGray
                 myCell.lblPrivacy.text = "Public vent"
            }
            myCell.btnDropDownVideo.tag = indexPath.row
            myCell.btnComment.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnShare.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnLike.setTitle("\(obj.numOfLikes!)", for: .normal)
            let url = URL(string:  obj.profile_image ?? "")
            myCell.ivUser.kf.indicatorType = .activity
            myCell.ivUser.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
            myCell.lblDesc.text = obj.desc
            myCell.lblName.text = userName
            
             let localDate = Utility.UTCToLocal(UTCDateString: obj.created_at ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            
           myCell.lblTime.text = Utility.dateConvertToISOString(string: localDate ?? "")
            myCell.btnplay.tag = indexPath.row
            cell = myCell
        }
        else if (obj.post_upload_type == "TEXT")
        {
            let myCell = myTableView.dequeueReusableCell(withIdentifier: CellClass_MyVentsTab.className) as! CellClass_MyVentsTab
            if(obj.privacy_option == "ONLYME")
            {
                
                myCell.lblDesc.text = obj.desc
                myCell.bgViewTextVents.backgroundColor = UIColor(red: 21/255.0, green: 42/255.0, blue: 53/255.0, alpha: 1.0)
                myCell.ivPrivacy.image = UIImage(named:"Myventslock")
                myCell.ivPrivacy.image = UIImage(named:"Myventslock")
                myCell.btnLike.setTitleColor(UIColor.white, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.white, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.white
                myCell.btnShare.imageView?.tintColor = UIColor.white
                myCell.btnLike.imageView?.tintColor = UIColor.white
                // myCell.ivPrivacy.tintColor = UIColor.white
                //let image = UIImage(named: "your_image_name")
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblName.textColor = UIColor.white
                myCell.lblTime.textColor = UIColor.init(hex: 0x999999)
                myCell.lblDesc.textColor = UIColor.white
                myCell.lblPrivacy.textColor = UIColor.init(hex: 0x999999)
                 myCell.lblPrivacy.text = "Private vent"
               
            }
            else
            {
                myCell.ivPrivacy.image = UIImage(named:"journelWorld")
                if(obj.privacy_option == "FRIENDS")
                {
                   myCell.ivPrivacy.image = UIImage(named:"friends")
                }
                myCell.lblDesc.text = obj.desc
                myCell.bgViewTextVents.backgroundColor = UIColor.init(hex: 0xE5E5E5)
                myCell.btnLike.setTitleColor(UIColor.black, for: .normal)
                myCell.btnShare.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.setTitleColor(UIColor.black, for: .normal)
                myCell.btnComment.imageView?.tintColor = UIColor.black
                myCell.btnShare.imageView?.tintColor = UIColor.black
                myCell.btnLike.imageView?.tintColor = UIColor.black
                myCell.ivPrivacy.image = myCell.ivPrivacy.image?.maskWithColor(color: UIColor.lightGray)
                myCell.lblName.textColor = UIColor.black
                myCell.lblTime.textColor = UIColor.init(hex: 0x999999)
                myCell.lblDesc.textColor = UIColor.black
                myCell.lblPrivacy.textColor = UIColor.init(hex: 0x999999)
                myCell.ivPrivacy.tintColor = UIColor.lightGray
                 myCell.lblPrivacy.text = "Public vent"
            }
            myCell.ivUser.layer.cornerRadius = 30
            myCell.btnDropDownText.tag = indexPath.row
            
            myCell.btnComment.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnShare.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.btnLike.setTitle("\(obj.numOfLikes!)", for: .normal)
            myCell.lblName.text = userName
            let localDate = Utility.UTCToLocal(UTCDateString: obj.created_at ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
            
             myCell.lblTime.text = Utility.dateConvertToISOString(string: localDate)
            
            //myCell.lblTime.text = localDate
           // myCell.lblPrivacy.text = obj.privacy_option
            myCell.lblDesc.text = obj.desc
            let url = URL(string:  obj.profile_image ?? "")
            myCell.ivUser.kf.indicatorType = .activity
            myCell.ivUser.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
             cell = myCell
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 200.0
//    }
}


extension MyAllVentsTabVC:AllVentsViewDelegate
{
    
    
    func showAlert(alertMessage: String)
    {
        CommonVc.AllFunctions.showAlert(message: alertMessage, view: self, title: Constants.Global.ConstantStrings.KAppname)
    }
    
    func showLoader()
    {
       MBProgressHUD.showAdded(to: view, animated: true).detailsLabel.text = "Loading..."
    }
    
    func hideLoader()
    {
       MBProgressHUD.hide(for: view, animated: true)
    }
    
    func getSharedPostList()
    {
       self.myTableView.reloadData()
    }
    
}

extension MyAllVentsTabVC:AllVentsDelegate
{
    func AllVentsDidSucceeedDelete(message: String)
    {
        self.hideLoader()
        self.showAlert(alertMessage: message)
        self.callToApi(searchKeyWord: "")
    }
    
    func AllVentsDidFailedDelete(message: String?)
    {
        self.hideLoader()
        self.showAlert(alertMessage: message ??  "")
    }
    
    func AllVentsDidSucceeed(eventModel: [AllVentsModelDetail])
    {
        self.hideLoader()
        apiDATA.removeAll()
        apiDATA = eventModel
        
        if (self.fromPrivate == true)
        {
            self.configureData_private()
        }
        else
        {
            self.myTableView.reloadData()
        }
        
        if (apiDATA.count == 0)
        {
            self.myTableView.setEmptyMessage("No Records Found!")
        }
    }
    
    func AllVentsDidFailed(message: String?)
    {
        self.hideLoader()
        print(message ?? "")
    }
    
    
}


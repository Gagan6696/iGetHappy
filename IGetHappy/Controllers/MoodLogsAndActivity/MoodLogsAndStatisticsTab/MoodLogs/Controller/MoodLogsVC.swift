//
//  MoodLogsVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import Kingfisher
import AVKit
import AVFoundation

protocol MoodLogViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}

class MoodLogsVC: BaseUIViewController
{

    @IBOutlet weak var lblNoMoodLogs: UILabel!
    @IBOutlet weak var lblNoCareRcvr: UILabel!
    @IBOutlet weak var tblViewMoodLogs: UITableView!
    @IBOutlet weak var colViewListCareRecievers: UICollectionView!
    var presenter:ChooseCareRecieverPresenter?
    var presenterMoodLogs:MoodLogPresenter?
    var selectedIndex = Int()
    var selectedCareReciverId:String?
    var CareRecieverData:ChooseCareRecieverMapper?
    var MoodLogData:MoodLogGetMapper?
    var careRcvrCount = 0
    
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    let playerViewController = AVPlayerViewController()
    var indexForHighlightView  = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter = ChooseCareRecieverPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        self.presenterMoodLogs = MoodLogPresenter.init(delegate: self)
        self.presenterMoodLogs?.attachView(view: self)
        
        
        // getCareRecieverList()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
        self.playerViewController.player?.pause()
        self.playerViewController.player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
       // selectedCareReciverId = UserDefaults.standard.getUserId() ?? ""
        getCareRecieverList()
        getMoodLogs()
        
    }
    
    private func getCareRecieverList()
    {
        if self.checkInternetConnection()
        {
            self.presenter?.GetAllListCareReciever()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    @IBAction func actionDropDown(_ sender: UIButton)
    {
        //sender.tag
        var moodID = ""
        let obj = MoodLogData?.data?[sender.tag]
        moodID = obj?._id ?? ""
        
        FTPopOverMenu.showForSender(sender: sender, with: ["Delete", "Edit", "Share"], done: { (selected) in
            switch selected
            {
            case 0:
                self.presenterMoodLogs?.deleteMoodLogByMoodId(moodId: moodID)
                break
            case 1:
                //Reminder
                self.EDIT_MOOD_LOG(position: sender.tag)
                break
            case 2:
                self.presenterMoodLogs?.shareMoodLogByMoodId(moodId: moodID)
                break
            default:
                break
            }
        })
        {
            
        }
    }
    private func getMoodLogs()
    {
        if self.checkInternetConnection()
        {
            // selectedCareReciverId = UserDefaults.standard.getUserId() ?? ""
          //  if(selectedCareReciverId.count > 0)
           // {
                self.presenterMoodLogs?.getAllMoodLogsByCareRecieverId(careRecieverId: selectedCareReciverId)
           // }
           // else
           // {
           //     self.view.makeToast("Please select care Reciever")
           // }
            
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    
    @IBAction func playVideo(_ sender: UIButton)
    {
        
        NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
        let obj = MoodLogData?.data?[sender.tag]
        let file = obj?.post_upload_file ?? ""
        
        if(file.count > 0)
        {
            let cell  = self.tblViewMoodLogs.cellForRow(at: IndexPath.init(row: sender.tag, section: 0)) as! MoodLogVideoCell
            
            let player = AVPlayer(url: URL.init(string: file)!)
            self.playerViewController.player = player
            
            self.addChild(self.playerViewController)
            
            // Add your view Frame
            self.playerViewController.view.frame = cell.videoView.bounds
            
            // Add sub view in your view
            cell.videoView.addSubview(self.playerViewController.view)
            self.playerViewController.player?.play()
        }
        else
        {
            CommonVc.AllFunctions.show_automatic_hide_alert(controller: self, title: "Sorry! can not play this video, may be path isn't correct")
        }
        
        
    }
    
    
    private func deleteMoodLog(moodLogId:String?)
    {
        if self.checkInternetConnection()
        {
            if(moodLogId != nil)
            {
                self.presenterMoodLogs?.deleteMoodLogByMoodId(moodId: moodLogId)
            }
            else
            {
                self.view.makeToast("Please select care Reciever")
            }
            
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }
    
    
    func EDIT_MOOD_LOG(position:Int)
    {
        let story = UIStoryboard.init(name: "MoodLogs", bundle: nil)
        
        let controller = story.instantiateViewController(withIdentifier: "AddActivityWithMoodVC")as! AddActivityWithMoodVC
        controller.Edit_Data = [MoodLogData?.data?[position]] as? [MoodLogDetails]
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
extension MoodLogsVC:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if MoodLogData?.data?.count ?? 0  > 0{
            self.tblViewMoodLogs.backgroundView  = nil
            return MoodLogData?.data?.count ?? 0
        }else{
            self.tblViewMoodLogs.setEmptyMessage("No MoodLogs found")
            return 0
        }
        
        //return MoodLogData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = MoodLogData?.data?[indexPath.row]
        var returnCell = UITableViewCell()
        let emojyName = obj?.moodTrackResId ?? ""
        let privacy = obj?.privacy_option ?? ""
        
        if(obj?.post_upload_type == "AUDIO")
        {
            let cell  = self.tblViewMoodLogs.dequeueReusableCell(withIdentifier: MoodLogMusicCell.className, for: indexPath) as! MoodLogMusicCell
            
            
            if(cell.selectedIndex == indexPath.row)
            {
                //myCell.btnPlay.isSelected = false
            }
            else
            {
                cell.stopMusic()
                cell.btnPlay.isSelected = false
            }
            cell.lblMoodDetailDesc.text = obj?.description
            cell.lblMoodDesc.text = obj?.eventsActivity
            
            let localDate = Utility.UTCToLocal(UTCDateString: obj?.mood_track_time ?? "", format: "EEEE,ddMMM hh:mmaa")
            
           cell.lblMoodpostDate.text = localDate
           // cell.lblMoodpostDate.text = self.dateFromISOStringForMoodlogs(string: obj?.updated_at ?? "")
            //cell.lblMoodpostDate.text = Utility.dateConvertToISOString(string: obj?.updated_at ?? "")
           // cell.lblMoodpostDate.text = obj?.updated_at ?? ""
            
            
            if (obj?.privacy_option == "ONLYME"){
                cell.lblPrivacy.text = "Private"
                cell.lblPrivacy.textColor = .red
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsLocked")
                
            }else{
                cell.lblPrivacy.text = "Public"
                cell.lblPrivacy.textColor = .green
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsEye")
            }
            cell.btnPlay.tag = indexPath.row
            cell.urlSong = obj?.post_upload_file
            cell.btnDropDown.tag = indexPath.row
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.imgViewCuurentMood.image = CommonVc.AllFunctions.set_emojy_from_server(imgName: emojyName)
           // cell.imgViewPrivacyIcon.image = CommonVc.AllFunctions.set_privacy_from_server(privacy:privacy)
            
            returnCell = cell
        }
        else if(obj?.post_upload_type == "VIDEO")
        {
            let cell  = self.tblViewMoodLogs.dequeueReusableCell(withIdentifier: MoodLogVideoCell.className, for: indexPath) as! MoodLogVideoCell
            
            cell.lblMoodDetailDesc.text = obj?.description
            cell.lblMoodDesc.text = obj?.eventsActivity
            
           
            // cell.lblMoodpostDate.text = Utility.dateConvertToISOString(string: obj?.updated_at ?? "")
            //cell.lblMoodpostDate.text = obj?.updated_at ?? ""
           // cell.lblPrivacy.text = obj?.privacy_option
            
             let localDate = Utility.UTCToLocal(UTCDateString: obj?.mood_track_time ?? "", format: "EEEE,ddMMM hh:mmaa")
            cell.lblMoodpostDate.text = localDate
            //cell.lblMoodpostDate.text = self.dateFromISOStringForMoodlogs(string: obj?.updated_at ?? "")
            //cell.lblMoodpostDate.text = Utility.dateConvertToISOString(string: obj?.updated_at ?? "")
            // cell.lblMoodpostDate.text = obj?.updated_at ?? ""
            
            
            if (obj?.privacy_option == "ONLYME"){
                cell.lblPrivacy.text = "Private"
                  cell.lblPrivacy.textColor = .red
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsLocked")
                
            }else{
                cell.lblPrivacy.text = "Public"
                  cell.lblPrivacy.textColor = .green
                
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsEye")
            }
            
            cell.btnDropDown.tag = indexPath.row
            cell.btnplay.tag = indexPath.row
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            
            
            cell.imgViewCuurentMood.image = CommonVc.AllFunctions.set_emojy_from_server(imgName: emojyName)
            //cell.imgViewPrivacyIcon.image = CommonVc.AllFunctions.set_privacy_from_server(privacy:privacy)
            returnCell = cell
            
        }
        else
        {
            let cell  = self.tblViewMoodLogs.dequeueReusableCell(withIdentifier: MoodLogTableCell.className, for: indexPath) as! MoodLogTableCell
            
            cell.lblMoodDetailDesc.text = obj?.description
            cell.lblMoodDesc.text = obj?.eventsActivity
            
            
            // cell.lblMoodpostDate.text = Utility.dateConvertToISOString(string: obj?.updated_at ?? "")
            //cell.lblMoodpostDate.text = obj?.updated_at ?? ""
          //  cell.lblPrivacy.text = obj?.privacy_option
            let localDate = Utility.UTCToLocal(UTCDateString: obj?.mood_track_time ?? "", format: "EEEE,ddMMM hh:mmaa")
            
            
            cell.lblMoodpostDate.text = localDate
            //cell.lblMoodpostDate.text = self.dateFromISOStringForMoodlogs(string: obj?.updated_at ?? "")
            //cell.lblMoodpostDate.text = Utility.dateConvertToISOString(string: obj?.updated_at ?? "")
            // cell.lblMoodpostDate.text = obj?.updated_at ?? ""
            
            
            if (obj?.privacy_option == "ONLYME"){
                cell.lblPrivacy.text = "Private"
                  cell.lblPrivacy.textColor = .red
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsLocked")
                
            }else{
                cell.lblPrivacy.text = "Public"
                  cell.lblPrivacy.textColor = .green
                cell.imgViewPrivacyIcon.image = UIImage.init(named: "MoodLogsEye")
            }
            
            
            cell.btnDropDown.tag = indexPath.row
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell.imgViewCuurentMood.image = CommonVc.AllFunctions.set_emojy_from_server(imgName: emojyName)
           // cell.imgViewPrivacyIcon.image = CommonVc.AllFunctions.set_privacy_from_server(privacy:privacy)
            returnCell = cell
        }
        
      
        return returnCell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 175.0
//    }
    
    
}
extension MoodLogsVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        //if careRcvrCount ?? 1 > 0{
          //  self.colViewListCareRecievers.backgroundView = nil
        
        let careRcvrCount = CareRecieverData?.data?.count ?? 0
        
        return careRcvrCount + 1
        
//        let count = CareRecieverData?.data?.count ?? 0 + 1
//            return count
       // }else{
       //     self.colViewListCareRecievers.setEmptyMessage("No careReciever found")
       //     return 0
      //  }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = self.colViewListCareRecievers.dequeueReusableCell(withReuseIdentifier: MoodLogCollectionCell.className, for: indexPath) as! MoodLogCollectionCell
        if(indexForHighlightView == indexPath.row)
        {
            cell.contentView.backgroundColor = .clear
            cell.contentView.alpha = 1
        }else{
            cell.contentView.backgroundColor = .white
            cell.contentView.alpha = 0.2
        }
        
        cell.imgViewProfile.roundCorners(.allCorners, radius: cell.imgViewProfile.frame.width/2)
        if(indexPath.row == 0)
        {
            cell.lblName.text = UserDefaults.standard.getFirstName()
            cell.lblRelationship.text = "Me"
            
            let url = URL(string:  UserDefaults.standard.getProfileImage() ?? "")
            cell.imgViewProfile?.kf.indicatorType = .activity
            cell.imgViewProfile?.kf.setImage(
                with: url,
                placeholder: UIImage(named: "community_listing_user"),
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            
        }
        else
        {
                let obj = CareRecieverData?.data?[indexPath.row - 1]
                cell.lblName.text = obj?.first_name
                cell.lblRelationship.text = obj?.relationship
                
                let imgURL = obj?.profile_image ?? ""
                
                cell.lblName.text = obj?.first_name
                cell.lblRelationship.text = obj?.relationship
                
                if (imgURL.count > 0)
                {
                    
                    let url = URL(string: imgURL)
                    cell.imgViewProfile?.kf.indicatorType = .activity
                    cell.imgViewProfile?.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "community_listing_user"),
                        options: [
                            .scaleFactor(UIScreen.main.scale),
                            .transition(.fade(1)),
                            .cacheOriginalImage
                        ])
                    
                    //cell.imgViewProfile.kf.setImage(with: URL(string: imgURL))
                    
                }
        }
        
       

        
        //        cell.imgViewProfile.kf.indicatorType = .activity
        //        cell.imgViewProfile.kf.setImage(
        //            with: imgURL,
        //            placeholder: UIImage(named: "community_listing_user"),
        //            options: [
        //                .scaleFactor(UIScreen.main.scale),
        //                .transition(.fade(1)),
        //                .cacheOriginalImage
        //            ])
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        indexForHighlightView = indexPath.row
        
        if (indexPath.row == 0)
        {
            selectedCareReciverId = ""
        }
        else
        {
           selectedCareReciverId = CareRecieverData?.data?[indexPath.row-1]._id ?? ""
        }
        self.colViewListCareRecievers.reloadData()
        getMoodLogs()
    }
    
}
extension MoodLogsVC:ChooseCareRecieverDelegate,MoodLogDelegate
{
    func MoodLogDidSucceeed(data: Any?)
    {
        let dic = data as? NSDictionary
        let msg = dic?.value(forKey: "message")as? String ?? ""
        CommonVc.AllFunctions.showAlert(message: msg, view: self, title: Constants.Global.ConstantStrings.KAppname)
        getMoodLogs()
    }
    
    func MoodLog_success_data(data: String?)
    {
        self.showAlert(alertMessage: data ?? "")
    }
    
    func MoodLog_success_data(response:MoodLogGetMapper?)
    {
        MoodLogData = response
        if(MoodLogData?.data?.count ?? 0 > 0)
        {
           self.lblNoMoodLogs.isHidden = true
        }
        else
        {
           self.lblNoMoodLogs.isHidden = false
           self.tblViewMoodLogs.setEmptyMessage("No Records Found!")
        }
        self.tblViewMoodLogs.reloadData()
    }
    
    func MoodLogSuccess_Strig(message:String?)
    {
        self.showAlert(Message: message ?? "")
    }
    
    func MoodLogDidFailed(message: String?)
    {
        self.showAlert(alertMessage: message ?? "Internal Error!")
    }
    
    func ChooseCareRecieverDidSucceeed(data: ChooseCareRecieverMapper?)
    {
        CareRecieverData = data
        if (CareRecieverData?.data?.count ?? 0 > 0)
        {
            careRcvrCount = CareRecieverData?.data?.count ?? 0
            careRcvrCount = careRcvrCount + 1
            self.lblNoCareRcvr.isHidden = true
            self.colViewListCareRecievers.reloadData()
        }
        else
        {
            self.lblNoCareRcvr.isHidden = true
        }
        
    }
    
    func ChooseCareRecieverDidFailed(message:String?)
    {
        self.showAlert(Message: message ?? "")
    }
}

extension MoodLogsVC:ChooseCareRecieverViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader()
    {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}
extension MoodLogsVC:MoodLogViewDelegate
{
    
}

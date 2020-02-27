//
//  CommunityExtention.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/23/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import MediaPlayer
import AVFoundation
import ObjectMapper
//MARK:- UICollectionView DataSource
extension CommunityListingViewController: UICollectionViewDataSource
{
    
    static var placeholder = "community_listing_user"
    static var audioPlayer = AVPlayer()
    static var isPlaying = false
    static var current_Index = -1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        if postListingArray.count > 0{
            
            collectionView.restore()
            if searchActive == true
            {
                return self.postListingArray_filter.count
            }
            return postListingArray.count
        }else{
            //collectionView.setEmptyMessage("No post found")
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var postData = postListingArray[indexPath.item]
        
        //FILTER HANDLING FOR SEARCH LIST
        if searchActive == true
        {
            if (postListingArray_filter.count > 0)
            {
                postData = postListingArray_filter[indexPath.item]
            }
        }
        else
        {
            postData = postListingArray[indexPath.item]
        }
        
        
        
        if (postData?.isShared == 0)//ITS NOT SHARED POST
        {
         
               
                 if (postData?.isMoodLog == 1){//It is Mood data
                    
                    if postData?.postType == Constants.PostType.video
                    {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodPostWithVideoCell.className, for: indexPath as IndexPath) as! MoodPostWithVideoCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            
                            cell.commentTableViewHeightConstraint.constant = 0
                        }
                        debugPrint("Else Part Tableview height constraint:- \(cell.commentTableViewHeightConstraint.constant)")
                        
                        return cell
                        
                        
                        
                    }else if postData?.postType == Constants.PostType.audio{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodPostWithAudioCell.className, for: indexPath as IndexPath) as! MoodPostWithAudioCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        cell.playAudioButton.tag = indexPath.item
                        if (indexPath.row == Singleton.shared().selectedIndex)
                        {
                            cell.playAudioButton.setImage(UIImage(named: "community_audio_pause"), for: UIControl.State.normal)
                        }
                        else
                        {
                            cell.playAudioButton.setImage(UIImage(named: "community_audio_play"), for: UIControl.State.normal)
                        }
                        
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentViewHgtConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            cell.commentViewHgtConstraint.constant = 0
                        }
                        debugPrint("Else If Audio Part Tableview height constraint:- \(cell.commentViewHgtConstraint.constant)")
                        cell.layoutIfNeeded()
                        return cell
                    }else{
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoodPostWithTextCell.className, for: indexPath as IndexPath) as! MoodPostWithTextCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            cell.commentTableViewHeightConstraint.constant = 0
                        }
                        debugPrint("Else If Text Part Tableview height constraint:- \(cell.commentTableViewHeightConstraint.constant)")
                        cell.layoutIfNeeded()
                        return cell
                    }
                    
                }
            else{
                    if postData?.postType == Constants.PostType.text
                    {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostWithOutImageCell.className, for: indexPath as IndexPath) as! PostWithOutImageCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            cell.commentTableViewHeightConstraint.constant = 0
                        }
                        debugPrint("Else If Text Part Tableview height constraint:- \(cell.commentTableViewHeightConstraint.constant)")
                        cell.layoutIfNeeded()
                        return cell
                    }
                    else if postData?.postType == Constants.PostType.audio
                    {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostWithAudioCell.className, for: indexPath as IndexPath) as! PostWithAudioCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        cell.playAudioButton.tag = indexPath.item
                        if (indexPath.row == Singleton.shared().selectedIndex)
                        {
                            cell.playAudioButton.setImage(UIImage(named: "community_audio_pause"), for: UIControl.State.normal)
                        }
                        else
                        {
                            cell.playAudioButton.setImage(UIImage(named: "community_audio_play"), for: UIControl.State.normal)
                        }
                        
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentViewHgtConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            cell.commentViewHgtConstraint.constant = 0
                        }
                        debugPrint("Else If Audio Part Tableview height constraint:- \(cell.commentViewHgtConstraint.constant)")
                        cell.layoutIfNeeded()
                        return cell
                    }
                    else
                    {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostWithImageCell.className, for: indexPath as IndexPath) as! PostWithImageCell
                        cell.bottomBar.tag = indexPath.item
                        cell.dropDownButton.tag = indexPath.item
                        cell.item = postData
                        if postData?.commentDataArray.count ?? 0 > 0{
                            cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                        }else{
                            
                            cell.commentTableViewHeightConstraint.constant = 0
                        }
                        debugPrint("Else Part Tableview height constraint:- \(cell.commentTableViewHeightConstraint.constant)")
                        
                        return cell
                    }
            }
       
         
            
            //        else if postData?.postType == Constants.PostType.video
            //        {
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostWithVideoCell.className, for: indexPath as IndexPath) as! PostWithVideoCell
            //            cell.btnPlay.tag = indexPath.item
            //            cell.item = postData
            //            return cell
            //        }
            
        
            
        }
        else//IT IS SHARED POST
        {
          
            if postData?.isMoodLog == 1{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareMoodPost.className, for: indexPath as IndexPath) as! ShareMoodPost
                
                cell.btnPlay.tag = indexPath.item
                //cell.btnPlay.addTarget(self, action: #Selecter(), for: UIControl.Event.normal)
                
                cell.btnPlay.addTarget(self, action: #selector(HANDLE_PLAY_BUTTON_ACTION(sender:)), for: .touchUpInside)
                
                cell.item = postData
                cell.lblPostName.text = postData?.post_description
                
                //Profile Image who has shared post
                cell.lblMyUserName.text = postData?.userName
                let imagURL = postData?.shared_user_image
                
                self.setimage_for_cell_image(img: cell.ivMyUser, url: imagURL!, placeholder: CommunityListingViewController.placeholder)
                
                //PROFILE IMAGE FOR SHARED POST OF THAT SHARED USER
                cell.lblUserName.text = postData?.post_username
                let postUser = postData?.post_userimage
                
                self.setimage_for_cell_image(img: cell.ivUser, url: postUser!, placeholder: CommunityListingViewController.placeholder)
                
                cell.ivUser.setRounded()
                cell.ivMyUser.setRounded()
                
                // cell.lblMyTime.text = postData?.userNamec
                // cell.view_heightConstraint.constant = 0
                
                if(postData?.post_post_upload_type == Constants.PostType.video)
                {
                    cell.view_AudioVideoShared.isHidden = false
                    // cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 200
                    //  cell.lblFileName.text = Constants.PostType.video
                    //   cell.ivBG.image = CommonVc.AllFunctions.get_thumbnail_from_server_link(path: postData?.post_postfile ?? "")
                    cell.ivBG.image = nil
                    // cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                    
                    debugPrint("MySharedPost Video height:- \(cell.commentTableViewHeightConstraint.constant) and count is :- \(postData?.commentDataArray.count)")
                }
                else if(postData?.post_post_upload_type == Constants.PostType.audio)
                {
                    cell.view_AudioVideoShared.isHidden = false
                    //  cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 200
                    //  cell.lblFileName.text = Constants.PostType.audio
                    cell.ivBG.image = UIImage(named: "audioBG")
                    // cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                }
                    
                else if(postData?.post_post_upload_type == Constants.PostType.image)
                {
                    cell.view_AudioVideoShared.isHidden = true
                    // cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = false
                    cell.viewImageSharedHeightConstraint.constant = 200
                    let imagURL = postData?.post_postfile
                    self.setimage_for_cell_image(img: cell.ivSharedImage, url: imagURL!, placeholder: "imageBG")
                    //  cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                }
                else if(postData?.post_post_upload_type == Constants.PostType.text)
                {
                    cell.view_AudioVideoShared.isHidden = true
                    //  cell.view_textShared.isHidden = false
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 0
                    //  cell.shadowView.isHidden = true
                    //
                }
                
                //For Showing Comments Or Not
                if postData?.commentDataArray.count ?? 0 > 0{
                    cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                    cell.layoutIfNeeded()
                }else{
                    cell.commentTableViewHeightConstraint.constant = 0
                    cell.layoutIfNeeded()
                }
                
                
                
                if (indexPath.row == CommunityListingViewController.current_Index)
                {
                    cell.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                }
                else
                {
                    cell.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                }
                
                cell.view_bg.layer.cornerRadius = 10
                cell.view_bg.layer.masksToBounds = true
                
                cell.bottomBar.tag = indexPath.item
                cell.dropDownButton.tag = indexPath.item
                
                
                cell.layoutIfNeeded()
                return cell
                
                
                
            }else{
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MySharedPosts.className, for: indexPath as IndexPath) as! MySharedPosts
                
                cell.btnPlay.tag = indexPath.item
                //cell.btnPlay.addTarget(self, action: #Selecter(), for: UIControl.Event.normal)
                
                cell.btnPlay.addTarget(self, action: #selector(HANDLE_PLAY_BUTTON_ACTION(sender:)), for: .touchUpInside)
                
                cell.item = postData
                cell.lblPostName.text = postData?.post_description
                
                //Profile Image who has shared post
                cell.lblMyUserName.text = postData?.userName
                let imagURL = postData?.shared_user_image
                
                self.setimage_for_cell_image(img: cell.ivMyUser, url: imagURL!, placeholder: CommunityListingViewController.placeholder)
                
                //PROFILE IMAGE FOR SHARED POST OF THAT SHARED USER
                cell.lblUserName.text = postData?.post_username
                let postUser = postData?.post_userimage
                
                self.setimage_for_cell_image(img: cell.ivUser, url: postUser ?? "", placeholder: CommunityListingViewController.placeholder)
                
                cell.ivUser.setRounded()
                cell.ivMyUser.setRounded()
                
                // cell.lblMyTime.text = postData?.userNamec
                // cell.view_heightConstraint.constant = 0
                
                if(postData?.post_post_upload_type == Constants.PostType.video)
                {
                    cell.view_AudioVideoShared.isHidden = false
                    // cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 200
                    //  cell.lblFileName.text = Constants.PostType.video
                    //   cell.ivBG.image = CommonVc.AllFunctions.get_thumbnail_from_server_link(path: postData?.post_postfile ?? "")
                    cell.ivBG.image = nil
                    // cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                    
                    debugPrint("MySharedPost Video height:- \(cell.commentTableViewHeightConstraint.constant) and count is :- \(postData?.commentDataArray.count)")
                }
                else if(postData?.post_post_upload_type == Constants.PostType.audio)
                {
                    cell.view_AudioVideoShared.isHidden = false
                    //  cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 200
                    //  cell.lblFileName.text = Constants.PostType.audio
                    cell.ivBG.image = UIImage(named: "audioBG")
                    // cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                }
                    
                else if(postData?.post_post_upload_type == Constants.PostType.image)
                {
                    cell.view_AudioVideoShared.isHidden = true
                    // cell.view_textShared.isHidden = true
                    cell.view_ImageShared.isHidden = false
                    cell.viewImageSharedHeightConstraint.constant = 200
                    let imagURL = postData?.post_postfile
                    self.setimage_for_cell_image(img: cell.ivSharedImage, url: imagURL!, placeholder: "imageBG")
                    //  cell.shadowView.isHidden = false
                    // cell.item = postData
                    
                }
                else if(postData?.post_post_upload_type == Constants.PostType.text)
                {
                    cell.view_AudioVideoShared.isHidden = true
                    //  cell.view_textShared.isHidden = false
                    cell.view_ImageShared.isHidden = true
                    cell.viewImageSharedHeightConstraint.constant = 0
                    //  cell.shadowView.isHidden = true
                    //
                }
                
                //For Showing Comments Or Not
                if postData?.commentDataArray.count ?? 0 > 0{
                    cell.commentTableViewHeightConstraint.constant = CGFloat(100*(postData?.commentDataArray.count ?? 0))
                    cell.layoutIfNeeded()
                }else{
                    cell.commentTableViewHeightConstraint.constant = 0
                    cell.layoutIfNeeded()
                }
                
                
                
                if (indexPath.row == CommunityListingViewController.current_Index)
                {
                    cell.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
                }
                else
                {
                    cell.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
                }
                
                cell.view_bg.layer.cornerRadius = 10
                cell.view_bg.layer.masksToBounds = true
                
                cell.bottomBar.tag = indexPath.item
                cell.dropDownButton.tag = indexPath.item
                
                
                cell.layoutIfNeeded()
                return cell
                
            }
            
        }
       // collectionView.invalidateLayout()
    }
    
    
    func setimage_for_cell_image(img:UIImageView,url:String,placeholder:String)
    {
        img.kf.setImage(
            with: URL(string:url),
            placeholder: UIImage(named: placeholder),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        if indexPath.row == self.postListingArray.count - 1
        {
            // we are at last cell load more content
            if self.postListingArray.count < totalEnteries
            {
                // we need to bring more records as there are some pending records available
                var index = self.postListingArray.count
                limit = index + 20
                while index < limit
                {
                    self.postListingArray.append(self.fullArray[index])
                    index = index + 1
                }
                
                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
            }
        }
    }
    
    @objc func loadTable()
    {
        self.postCollectionView.reloadData()
    }
    
    
    
    
    //MARK: PLAYING VIDEOS AND AUDIOS
    @objc func HANDLE_PLAY_BUTTON_ACTION(sender:UIButton)
    {
        
        let indxData = postListingArray[sender.tag]

        let pathNew = indxData?.post_postfile ?? ""
        
        if (indxData?.post_post_upload_type == Constants.PostType.audio)
        {
            
            CommunityListingViewController.current_Index = sender.tag
            if(CommunityListingViewController.isPlaying == true)
            {
                CommunityListingViewController.audioPlayer.pause()
                CommunityListingViewController.isPlaying = false
                CommunityListingViewController.current_Index = -1
                self.loadTable()
               // self.SET_UP_AUDIO(path:pathNew)
            }
            else
            {
                self.SET_UP_AUDIO(path:pathNew)
            }
        }
        else
        {
            CommunityListingViewController.current_Index = -1
            let videoURL = NSURL(string: indxData?.post_postfile ?? "")
            let topController = CommonVc.AllFunctions.get_top_controller()
            
            let player = AVPlayer(url: videoURL! as URL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            topController.present(playerViewController, animated: true)
            {
                playerViewController.player!.play()
            }
        }
        
    }
    
    func SET_UP_AUDIO(path:String)
    {
        if (path.contains(".wav") || path.contains(".mp3") || path.contains(".m4r"))
        {
            guard let url = URL(string: path)
                else { return }
            
            NotificationCenter.default.addObserver(self,
                                                   selector:#selector(didEndPlayback),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object:nil)
            CommunityListingViewController.audioPlayer = AVPlayer(url: url as URL)
            CommunityListingViewController.audioPlayer.play()
            CommunityListingViewController.isPlaying = true
            self.loadTable()
        }
        else
        {
            CommunityListingViewController.current_Index = -1
            CommunityListingViewController.isPlaying = false
            let topController = CommonVc.AllFunctions.get_top_controller()
            CommonVc.AllFunctions.showAlert(message: "Sorry! file url is not correct.", view: topController, title: Constants.Global.ConstantStrings.KAppname)
            self.loadTable()
        }
    }
    
    
//    @objc func stopMusic()
//    {
//        CommunityListingViewController.isPlaying = false
//        CommunityListingViewController.audioPlayer.pause()
//        CommunityListingViewController.audioPlayer = AVPlayer()
//    }
    
    @objc func didEndPlayback(note: NSNotification)
    {
        CommunityListingViewController.current_Index = -1
        CommunityListingViewController.isPlaying = false
        CommunityListingViewController.audioPlayer.pause()
        //CommunityListingViewController.audioPlayer = AVPlayer()
       // NotificationCenter.default.post(name: Notification.Name("StopMusic"), object: nil)
      //  NotificationCenter.default.post(name: Notification.Name("StopMusicShare"), object: nil)
      //  NotificationCenter.default.post(name: Notification.Name("stopMusicShareMoods"), object: nil)
        self.loadTable()
    }
}

//MARK:- UICollectionView Delegate
extension CommunityListingViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
}

//MARK:- UICollectionView Delegate FlowLayout
extension CommunityListingViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print(postListingArray.count)
        let postData = postListingArray[indexPath.row]
        print("postData?",postData?.emojiType)
        let type = postData?.postType ?? ""
        var hgtOfTxt : Int = 0
        if postData?.isShared == 1{
             hgtOfTxt = Int(Utility.calculateHeight(inString: postData?.post_description ?? "") )
            print(hgtOfTxt)
        }else{
             hgtOfTxt = Int(Utility.calculateHeight(inString: postData?.postDescription ?? "") )
            print(hgtOfTxt)
        }
        
        
        let commentTableViewHeight = (100*(postData?.commentDataArray.count ?? 0  ) + hgtOfTxt)
        
        if postData?.isShared == 1
        {
             let sharedType = postData?.post_post_upload_type ?? ""
            if postData?.isMoodLog == 1{//MoodLog Post Share
                if sharedType == Constants.PostType.text
                {
                    return CGSize(width: self.view.frame.size.width, height: CGFloat(280+commentTableViewHeight))
                }
                else
                {
                    return CGSize(width: self.view.frame.size.width, height: CGFloat(500+commentTableViewHeight))
                }
            }else{//Normal Post Share
                if sharedType == Constants.PostType.text
                {
                    return CGSize(width: self.view.frame.size.width, height: CGFloat(240+commentTableViewHeight))
                }
                else
                {
                    return CGSize(width: self.view.frame.size.width, height: CGFloat(460+commentTableViewHeight))
                }
            }

        }else if postData?.isMoodLog == 1{
            
            if type == Constants.PostType.text
            {
                return CGSize(width: self.view.frame.size.width, height: CGFloat(220+commentTableViewHeight))
            }
            else if type == Constants.PostType.audio
            {
                return CGSize(width: self.view.frame.size.width, height: CGFloat(290+commentTableViewHeight))
            }
            else if type == Constants.PostType.video
            {
                return CGSize(width: self.view.frame.size.width, height: CGFloat(450+commentTableViewHeight))
            }else{
                return CGSize(width: self.view.frame.size.width, height: 400)
            }
            //return CGSize(width: self.view.frame.size.width, height: 250)
        }
        else
        {
            if type == Constants.PostType.text
            {
                return CGSize(width: self.view.frame.size.width, height: CGFloat(190+commentTableViewHeight))
            }
            else if type == Constants.PostType.audio
            {
                return CGSize(width: self.view.frame.size.width, height: CGFloat(290+commentTableViewHeight))
            }
            else if type == Constants.PostType.video
            {
               
                print("gagan heighjt check", 420+commentTableViewHeight)
                return CGSize(width: self.view.frame.size.width, height: CGFloat(370+commentTableViewHeight))
            }
        }
        
        return CGSize(width: self.view.frame.size.width, height: 380)
    }
}

extension CommunityListingViewController : UtilityDelegate
{
    func replyButtonTapped(selectedIndex: [String : Any])
    {
        print(selectedIndex)
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReplyCommentVC, Data: selectedIndex)
    }
    func commentButtonTapped(selectedIndex: Int)
    {
        print(selectedIndex)
        guard let selectedData = postListingArray[selectedIndex]else {return}
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Comment, Data: selectedData)
    }
    
    func shareButtonTapped(selectedIndex: Int)
    {
        print(selectedIndex)
      guard let selectedData = postListingArray[selectedIndex]else {return}
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .SharePost, Data: nil)
        
        
        self.AlertMessageWithOkCancelAction(titleStr: Constants.Global.ConstantStrings.KAppname, messageStr: "Do you want to share this post?", Target: self) { (action) in
            if action == "Yes"
            {
                
                if let userId = UserDefaults.standard.getUserId()
                {
                    CommonVc.AllFunctions.addLOADER(controller: self)
                    var parm = [String:AnyObject]()
                    
                    
                    if selectedData.isShared == 1{
                        if selectedData.isMoodLog == 1{
                            parm["check"] = "moodLog" as AnyObject
                            parm["mood_log_id"] = selectedData.share_mood_log_id as AnyObject
                        }else{
                            parm["check"] = "post" as AnyObject
                            parm["post_id"] = selectedData.post_id_post as AnyObject
                        }
                    }else{
                        if selectedData.isMoodLog == 1{
                            parm["check"] = "moodLog" as AnyObject
                            parm["mood_log_id"] = selectedData.postId as AnyObject
                        }else{
                            parm["check"] = "post" as AnyObject
                            parm["post_id"] = selectedData.postId as AnyObject
                        }
                    }
                    
                   
                    
                    
                    
                    parm["user_id"] = userId as AnyObject
                    parm["created_at"] = Utility.dateFromISOStringForCreatedAt(string: Date()) as AnyObject
                    CommunityViewModel.sharePostService(params: parm) { (status, message,data) in
                        
                        CommonVc.AllFunctions.hideLOADER(controller: self)
                        
                        if(status == true)
                        {
                            if (data.count > 0)
                            {
                                //  self.view.makeToast(data)
                                CommonVc.AllFunctions.showAlert(message: data, view: self, title: Constants.Global.ConstantStrings.KAppname)
                                self.getAllPost(startDateFilter: "", endDateFilter: "", searchWord: "")
                            }
                            else
                            {
                                //self.view.makeToast("Post shared succesfully")
                                CommonVc.AllFunctions.showAlert(message: "Post shared successfully", view: self, title: Constants.Global.ConstantStrings.KAppname)
                                
                            }
                            
                        }
                        else
                        {
                            self.view.makeToast(Constants.Global.MessagesStrings.SomethingWentWrong)
                        }
                    }
                }
                //CommonFunctions.sharedInstance.popTocontroller(from: self)
            }
        }
        
    }
    
    func popUpMenuButtonTappedForMoodLogs(selectedIndex: Int){
        guard let selectedData = postListingArray[selectedIndex]else {return}
        let json = JSONSerializer.toJson(selectedData)
//       let j1 =  json.replacingOccurrences(of: "postId", with: "_id")
//        let j2 = j1.replacingOccurrences(of: "userId", with: "user_id")
//       let j3 = j2.replacingOccurrences(of: "privacyOption", with: "privacy_option")
//        let j4 = j3.replacingOccurrences(of: "postDescription", with: "description")
        
        let modifiedJSON = json.replacingMultipleOccurrences(using: (of: "postId", with: "_id"), (of: "userId", with: "user_id"), (of: "privacyOption", with: "privacy_option"), (of: "postDescription", with: "description"), (of: "postfile", with: "post_upload_file"))
        
        let moodLogData = Mapper<MoodLogDetails>().mapArray(JSONString: modifiedJSON)
        let story = UIStoryboard.init(name: "MoodLogs", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "AddActivityWithMoodVC")as! AddActivityWithMoodVC
        controller.Edit_Data = moodLogData
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func popUpMenuButtonTapped(selectedIndex: Int, isEdit: Bool, isReportAbuse : Bool)
    {
        guard let selectedData = postListingArray[selectedIndex]else {return}
        if isEdit
        {
            selectedData.isEditingMode = true
            if selectedData.postType == Constants.PostType.text
            {
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .WriteThoughts, Data: [selectedData])
            }
            else if selectedData.postType == Constants.PostType.video
            {
                CommonFunctions.sharedInstance.PushToContrllerForEdit(from: self, ToController: .Preview, Data: [selectedData])
            }
            else
            {
                CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AudioRecord, Data: [selectedData])
            }
        }
        else if isReportAbuse
        {
            //Report Abuse API functionality
            
            let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: "Do you want to report this post?", preferredStyle: UIAlertController.Style.alert)
            let YesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                
                CommonVc.AllFunctions.addLOADER(controller: self)
                let userId = UserDefaults.standard.getUserId() ?? ""
                var parm = [String:AnyObject]()
                if selectedData.isMoodLog == 1{
                    parm["check"] = "moodLog" as AnyObject
                    parm["mood_log_id"] = selectedData.postId as AnyObject
                }else{
                    parm["check"] = "post" as AnyObject
                    parm["post_id"] = selectedData.postId as AnyObject
                }
                parm["user_id"] = userId as AnyObject
                
                
                
                    //parm["user_id"] = userId as AnyObject
                   // parm["post_id"] = selectedData.postId as AnyObject
                    CommunityViewModel.reportAbuseService(params: parm) { (status, message) in
                        if(status == true)
                        {
                            CommonVc.AllFunctions.hideLOADER(controller: self)
                            CommonVc.AllFunctions.showAlert(message: "Post reported successfully", view: self, title: Constants.Global.ConstantStrings.KAppname)
                        }
                        else
                        {
                            CommonVc.AllFunctions.hideLOADER(controller: self)
                            CommonVc.AllFunctions.showAlert(message: Constants.Global.MessagesStrings.SomethingWentWrong, view: self, title: Constants.Global.ConstantStrings.KAppname)
                        }
                    }
                
            }
            
            let NoAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default)
            {
                UIAlertAction in
                
            }
            // Add the actions
            alert.addAction(YesAction)
            alert.addAction(NoAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            
            var postId = selectedData.postId ?? "" + ""
//            var isShared : String
//            if (selectedData.isMoodLog == 1)
//            {
//                isShared += "/moodLog"
//            } else{
//                isShared += "/post"
//            }
            
            CommunityViewModel.deletePostService(postId:postId, isShared: selectedData.isShared ?? 0, isMoodLog:selectedData.isMoodLog ?? 0) { (status, message) in
                if(status == true)
                {
                    // self.view.makeToast("Post delete succesfully")
                    self.destroyMMPlayerInstance()
                    CommonVc.AllFunctions.showAlert(message: "Post deleted successfully!", view: self, title: Constants.Global.ConstantStrings.KAppname)
                    self.emojiButtonTapped()
                }
                else
                {
                    // self.view.makeToast(Constants.Global.MessagesStrings.SomethingWentWrong)
                    CommonVc.AllFunctions.showAlert(message: Constants.Global.MessagesStrings.SomethingWentWrong, view: self, title: Constants.Global.ConstantStrings.KAppname)
                    self.emojiButtonTapped()
                }
            }
            //Delete API functionality
        }
    }
    
    func emojiButtonTapped()
    {
        if(startDate != nil && endDate != nil)
        {
            let startDateFilter = dateFormatTime(date: startDate!)
            let endDateFilter = dateFormatTime(date: endDate!)
            getAllPost(startDateFilter: startDateFilter, endDateFilter: endDateFilter, searchWord: "")
        }
        else
        {
            self.getAllPost(startDateFilter: "", endDateFilter: "", searchWord: "")
        }
        
    }
    
}


extension ShareMoodPost : PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0 )
        // let ref = CommunityListingViewController()
        //  ref.getAllPost()
    }
}

extension MoodPostWithTextCell :PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
       // Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        
        print(Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}

extension MoodPostWithVideoCell :PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}
extension MoodPostWithAudioCell :PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        
       // Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(item!.postId as Any)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}
extension PostWithImageCell :PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
       // Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}

extension PostWithOutImageCell :PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
        
        //5dfce07b4ed86131f22e7fd4
        
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}

extension PostWithAudioCell :PostTabBarDelegate
{
  
    
    func shareButtonTapped(sender: UIButton)
    {
        
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(item!.postId as Any)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
        //Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
        print(Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
    }
}

extension MySharedPosts : PostTabBarDelegate
{
    func shareButtonTapped(sender: UIButton)
    {
        print(item!.postId as Any)
        //Utility.shareButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.shareButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func commentButtonTapped(sender: UIButton)
    {
       // Utility.commentButtonTapped(selectedIndex: item?.postId ?? "")
        Utility.commentButtonTapped(selectedIndex:Utility.selectedIndexOfThePost(sender: sender)!)
    }
    
    func supportButtonTapped(sender: UIButton, reactionTitle: String)
    {
        Utility.likePost(postID: item?.postId ?? "", likeType: reactionTitle,isMoodLog:item?.isMoodLog ?? 0)
        // let ref = CommunityListingViewController()
        //  ref.getAllPost()
    }
}

extension NSObject
{
    class var className: String
    {
        return String(describing: self)
    }
}

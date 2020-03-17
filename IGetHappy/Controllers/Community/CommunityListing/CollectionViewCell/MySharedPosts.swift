//
//  MySharedPosts.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

@objc protocol PostWithSharedCellDelegate
{
    @objc optional func audioPlayerInstance(sender: UIButton)
    @objc optional func dropDownMenuTapped(sender: UIButton)
}

class MySharedPosts: UICollectionViewCell
{
    
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var shadowView: RoundShadowView!
    @IBOutlet weak var ivSharedImage: UIImageView!
  //  @IBOutlet weak var lblTextShared: UILabel!
    @IBOutlet weak var lblPostName: UILabel!
    @IBOutlet weak var ivMyUser: UIImageView!
    @IBOutlet weak var lblMyUserName: UILabel!
    @IBOutlet weak var lblMyTime: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var view_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ivBG: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
   // @IBOutlet weak var view_textShared: UIView!
    @IBOutlet weak var view_ImageShared: UIView!
    @IBOutlet weak var view_AudioVideoShared: UIView!
    @IBOutlet weak var cellBottomBar: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var commentTabelView: UITableView!
    @IBOutlet weak var commentTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewImageSharedHeightConstraint: NSLayoutConstraint!
    
    let desc = UILabel()
    let bottomBar = PostTabBar.instanceFromNib()
    var delegate: PostWithSharedCellDelegate?
    var audioPlayer = AVPlayer()
    let stopAudioObserver = NotificationCenter.default
    var postCommentArray : [Post.CommentListModel]?

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        customizeView()
        registerNib()
        commentTabelView.layoutIfNeeded()
        commentTabelView.frame = CGRect(x: commentTabelView.frame.origin.x, y: commentTabelView.frame.origin.y, width: commentTabelView.frame.size.width, height: commentTabelView.contentSize.height)
        commentTabelView.delegate = self
        commentTabelView.dataSource = self
        stopAudioObserver.addObserver(self, selector: #selector(self.stopMusicShare), name: Notification.Name("stopMusicShare"), object: nil)
    }
    
    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        commentTabelView.register(commentNibCell, forCellReuseIdentifier: CommunityCommentCell.className)
    }
    
    
    var item: Post?
    {
        didSet
        {
            guard item != nil else
            {
                return
            }
            
            if (item?.post_postTimeStamp != nil){
                
               // Utility.UTCToLocal(UTCDateString: selectedData?.postTimeStamp ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                
                let localDate = Utility.UTCToLocal(UTCDateString: item?.post_postTimeStamp ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                
                lblTime.text =  Utility.dateConvertToISOString(string: localDate)
            }
            
            //Set name and images according to anonymus status
            Utility.setUserDetailOnPost(selectedData: item,
                                        userTitle: lblUserName,
                                        userImage: ivUser,
                                        postDescription: desc, postTimeStamp: lblMyTime)
            
            //Set emoji or like status
            if item?.post_liked == 1
            {
                bottomBar.supportButton.isSelected = true
                bottomBar.supportButton.reaction = Utility.setEmoji(selectedData: item)!
            }
            else
            {
                bottomBar.supportButton.isSelected = false
                //bottomBar.supportButton.reaction = Utility.setEmoji(selectedData: "LIKE")!
               // bottomBar.supportButton.reaction = Reaction.facebook.like
            }
            //Assign the Commented Array
            postCommentArray?.removeAll()
            postCommentArray = item?.commentDataArray
            commentTabelView.reloadData()
        }
    }
    
    
    func customizeView()
    {
        bottomBar.frame = cellBottomBar.bounds
        bottomBar.backgroundColor = UIColor.clear
        if !bottomBar.frame.contains(cellBottomBar.frame)
        {
            cellBottomBar.addSubview(bottomBar)
            bottomBar.delegate = self
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func videoPlayPauseButtonAction(_ sender: UIButton)
    {
        if (item?.post_post_upload_type == Constants.PostType.audio)
        {
            
            
            sender.isSelected = !sender.isSelected
            if sender.isSelected
            {
                sender.setImage(UIImage(named:"pause"), for: UIControl.State.normal)
                
                let path = item?.post_postfile ?? ""
                
                if (path.contains(".wav") || path.contains(".mp3") || path.contains(".m4r"))
                {
                    guard let url = URL(string: item?.post_postfile ?? "")
                        else { return }
                    
                    audioPlayer.pause()
                    NotificationCenter.default.addObserver(self,
                                                           selector:#selector(didEndPlayback),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                           object:nil)
                    audioPlayer = AVPlayer(url: url as URL)
                    audioPlayer.play()
                }
                else
                {
                    sender.setImage(UIImage(named:"play"), for: UIControl.State.normal)
                    let topController = CommonVc.AllFunctions.get_top_controller()
                    CommonVc.AllFunctions.showAlert(message: "Sorry! file url is not correct.", view: topController, title: Constants.Global.ConstantStrings.KAppname)
                }
                
            }
            else
            {
                audioPlayer.pause()
                sender.setImage(UIImage(named:"play"), for: UIControl.State.normal)
                let ref = CommunityListingViewController()
                ref.postCollectionView.reloadData()
            }
        }
        else
        {
            self.playvideo()
        }
        
        
    }
    
    func playvideo()
    {
        let videoURL = NSURL(string: item?.post_postfile ?? "")
        let topController = CommonVc.AllFunctions.get_top_controller()
        
        let player = AVPlayer(url: videoURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        topController.present(playerViewController, animated: true)
        {
            playerViewController.player!.play()
        }
    }
    
    
    private func setupAudioContent()
    {
        
        let path = item?.post_postfile ?? ""
        
        if (path.contains(".wav") || path.contains(".mp3") || path.contains(".m4r"))
        {
            guard let url = URL(string: item?.post_postfile ?? "")
                else { return }
            
            NotificationCenter.default.addObserver(self,
                                                   selector:#selector(didEndPlayback),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object:nil)
            audioPlayer = AVPlayer(url: url as URL)
            audioPlayer.play()
        }
        
    }
    
    @objc func stopMusicShare()
    {
        print("stopMusicShare called")
        CommunityListingViewController.current_Index = -1
        CommunityListingViewController.isPlaying = false
        CommunityListingViewController.audioPlayer.pause()
        btnPlay.isSelected = false
        btnPlay.setImage(UIImage(named:"play"), for: UIControl.State.normal)
        self.audioPlayer.pause()
        self.audioPlayer = AVPlayer()
    }
    
    @objc func didEndPlayback(note: NSNotification)
    {
        btnPlay.isSelected = false
    }
    
    
    @IBAction func dropDownMenuAction(_ sender: UIButton)
    {
        delegate?.dropDownMenuTapped!(sender: sender)
        Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}
extension MySharedPosts :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postCommentArray?.count ?? 0 == 0||postCommentArray == nil{
            return 0
        }else if postCommentArray?.count ?? 0 <= 2{
            return postCommentArray?.count ?? 0
        }else{
            return 2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = commentTabelView.dequeueReusableCell(withIdentifier: CommunityCommentCell.className, for: indexPath) as! CommunityCommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.btnReply.tag = indexPath.row
        let data = postCommentArray?[indexPath.row]
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        Utility.loadImage(onImageView: cell.imgView, imageURLString: data?.profileImage ?? "", placeHolder: "community_listing_user")
        cell.lblProfileName.text = data?.username
        cell.delegate = self
        cell.lblComment.text = data?.comment
        
        return cell
    }
    
}
extension MySharedPosts:CommentCellDelegate{
    func commentButtonClicked(index : Int){
        var dataToReplyOnComment = [String:String]()
        dataToReplyOnComment["post_id"] = item?.postId
        dataToReplyOnComment["commentId"] = item?.commentDataArray[index].id
        Utility.replyButtonTapped(selectedIndexDict: dataToReplyOnComment)
        //Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}

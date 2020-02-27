//
//  PostWithAudioCell.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/18/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import AVFoundation
import Reactions

@objc protocol PostWithAudioCellDelegate
{
    @objc optional func dropDownMenuTapped(sender: UIButton)
    @objc optional func selectProfileButtonTapped(sender: UIButton)
    @objc optional func audioPlayerInstance(sender: UIButton)
   
}

class PostWithAudioCell: UICollectionViewCell
{
    @IBOutlet weak var commentViewHgtConstraint: NSLayoutConstraint!
    //MARK:- Variables
    @IBOutlet weak var commentTblView: UITableView!
    var delegate: PostWithAudioCellDelegate?
    let bottomBar = PostTabBar.instanceFromNib()
    var audioPlayer = AVPlayer()
    let stopAudioObserver = NotificationCenter.default
    static var ref_community:CommunityListingViewController?
    var postCommentArray : [Post.CommentListModel]?

    var playing = false
    
    //MARK:- Properties
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var postTimeStampLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var cellBottomBar: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var CommentView: UIView!
    
    //Populating cell with data
    var item: Post?
    {
        didSet
        {
            guard item != nil else
            {
                return
            }
            
            //Set name and images according to anonymus status
            Utility.setUserDetailOnPost(selectedData: item,
                                        userTitle: userTitleLabel,
                                        userImage: userProfileImageView,
                                        postDescription: postTextLabel, postTimeStamp: postTimeStampLabel)
            
            //Check wether it is same user post
            if Utility.isSameUserID(selectedData: item)
            {
                dropDownButton.isHidden = false
            }
            else
            {
                dropDownButton.isHidden = false
            }
            
            //Set emoji or like status
            if item?.isLike == 1
            {
                bottomBar.supportButton.isSelected = true
                bottomBar.supportButton.reaction = Utility.setEmoji(selectedData: item)!
            }
            else
            {
                bottomBar.supportButton.isSelected = false
                bottomBar.supportButton.reaction = Reaction.facebook.like
            }
            
            //Assign the Commented Array
            postCommentArray?.removeAll()
            postCommentArray = item?.commentDataArray
            commentTblView.reloadData()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //Comment work is pemsding from backend ,So for now all comment View and delegate are disconneted and hide.
        
        //commentTblView.delegate = self
      //  commentTblView.dataSource = self
        customizeView()
        registerNib()
        commentTblView.layoutIfNeeded()
        //viewDidLayoutSubviews()
        commentTblView.frame = CGRect(x: commentTblView.frame.origin.x, y: commentTblView.frame.origin.y, width: commentTblView.frame.size.width, height: commentTblView.contentSize.height)
        commentTblView.delegate = self
        commentTblView.dataSource = self
        stopAudioObserver.addObserver(self, selector: #selector(self.stopMusic), name: Notification.Name("StopMusic"), object: nil)
    }
    
    
//    func viewDidLayoutSubviews(){
//        commentTblView.frame = CGRect(x: commentTblView.frame.origin.x, y: commentTblView.frame.origin.y, width: commentTblView.frame.size.width, height: commentTblView.contentSize.height)
//        commentTblView.reloadData()
//    }
    
    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        commentTblView.register(commentNibCell, forCellReuseIdentifier: CommunityCommentCell.className)
        
       
    }
    func customizeView()
    {
        bottomBar.frame = cellBottomBar.bounds
        if !bottomBar.frame.contains(cellBottomBar.frame)
        {
            cellBottomBar.addSubview(bottomBar)
            bottomBar.delegate = self
        }
    }
    
    private func setupAudioContent()
    {
        guard let url = URL(string: item?.postfile ?? "")
            else { return }
        
        playAudioButton.isSelected = false
        self.audioPlayer.pause()
        self.audioPlayer = AVPlayer()
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(didEndPlayback),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object:nil)
        audioPlayer = AVPlayer(url: url as URL)
        audioPlayer.play()
    }
    
    @objc func stopMusic()
    {
        playAudioButton.isSelected = false
        playAudioButton.setImage(UIImage(named: "community_audio_play"), for: UIControl.State.normal)
        self.audioPlayer.pause()
        Singleton.shared().selectedIndex = -1
       // PostWithAudioCell.ref_community?.loadTable()
        playing = false
        self.audioPlayer = AVPlayer()
        
    }
    
    @objc func didEndPlayback(note: NSNotification)
    {
        playAudioButton.isSelected = false
        Singleton.shared().selectedIndex = -1
        PostWithAudioCell.ref_community?.loadTable()
        playing = false
    }
    
    //MARK:- Button Actions
    @IBAction func audioPlayPauseButtonAction(_ sender: UIButton)
    {
        
        if (playing == false)
        {
            playing = true
            setupAudioContent()
            Singleton.shared().selectedIndex = sender.tag
            PostWithAudioCell.ref_community?.loadTable()
        }
        else
        {
            playing = false
            audioPlayer.pause()
            PostWithAudioCell.ref_community?.loadTable()
            Singleton.shared().selectedIndex = -1
        }
        
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected
//        {
//            setupAudioContent()
//            Singleton.shared().selectedIndex = sender.tag
//            PostWithAudioCell.ref_community?.loadTable()
//           // sender.setImage(UIImage(named: "community_audio_pause"), for: UIControl.State.normal)
//        }
//        else
//        {
//           // sender.setImage(UIImage(named: "community_audio_play"), for: UIControl.State.normal)
//            audioPlayer.pause()
//            PostWithAudioCell.ref_community?.loadTable()
//            Singleton.shared().selectedIndex = -1
//
//        }
    }
    
    @IBAction func selectProfileButtonAction(_ sender: UIButton)
    {
        delegate?.selectProfileButtonTapped!(sender: sender)
    }
    
    @IBAction func dropDownMenuAction(_ sender: UIButton)
    {
        delegate?.dropDownMenuTapped!(sender: sender)
        Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}

extension PostWithAudioCell :UITableViewDataSource,UITableViewDelegate{
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
        let cell  = commentTblView.dequeueReusableCell(withIdentifier: CommunityCommentCell.className, for: indexPath) as! CommunityCommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.btnReply.tag = indexPath.row
        let data = postCommentArray?[indexPath.row]
        //cell.btnReply.addTarget(self, action: "actionReply", for: UIControl.Event.touchUpInside)
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.lblProfileName.text = data?.username
        cell.delegate = self
        cell.layoutIfNeeded()
        cell.lblComment.text = data?.comment
        
        return cell
    }
    
}
extension PostWithAudioCell:CommentCellDelegate{
    func commentButtonClicked(index: Int){
        var dataToReplyOnComment = [String:String]()
        dataToReplyOnComment["post_id"] = item?.postId
        dataToReplyOnComment["commentId"] = item?.commentDataArray[index].id
        Utility.replyButtonTapped(selectedIndexDict: dataToReplyOnComment)
         //Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}

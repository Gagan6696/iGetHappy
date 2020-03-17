//
//  PostWithVideoCell.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import AVFoundation

class PostWithVideoCell: UICollectionViewCell
{

    @IBOutlet weak var commentTblViewVideo: UITableView!
    @IBOutlet weak var commentTableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    let desc = UILabel()
    @IBOutlet weak var cellBottomBar: UIView!
    
    @IBOutlet weak var lblPostTimestamp: UILabel!
    
    
    @IBOutlet weak var videoView: RoundShadowView!
    
    let bottomBar = PostTabBar.instanceFromNib()
    var postCommentArray : [Post.CommentListModel]?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        customizeView()
        
        registerNib()
        /** Comment work is pemsding from backend ,So for now all comment View and delegate are disconneted and hide.
         */
        commentTblViewVideo.delegate = self
        commentTblViewVideo.dataSource = self
        // Initialization code
    }
    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        commentTblViewVideo.register(commentNibCell, forCellReuseIdentifier: CommunityCommentCell.className)
        
    }
    
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
                                        userTitle: lblUserName,
                                        userImage: ivUser,
                                        postDescription: desc,postTimeStamp: lblPostTimestamp)
            
            //Set emoji or like status
            if item?.isLike == 1
            {
                bottomBar.supportButton.isSelected = true
                bottomBar.supportButton.reaction = Utility.setEmoji(selectedData: item)!
            }
            else
            {
                bottomBar.supportButton.isSelected = false
               // bottomBar.supportButton.reaction = Reaction.facebook.like
            }
            
            //Assign the Commented Array
            postCommentArray?.removeAll()
            postCommentArray = item?.commentDataArray
        }
    }
    
    
    func customizeView()
    {
        bottomBar.frame = cellBottomBar.bounds
        if !bottomBar.frame.contains(cellBottomBar.frame)
        {
            cellBottomBar.addSubview(bottomBar)
           // bottomBar.delegate = self
        }
    }

    
    //MARK:- Button Actions
    @IBAction func videoPlayPauseButtonAction(_ sender: UIButton)
    {
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            self.playvideo()
        }
        else
        {
            
        }
    }
    
    func playvideo()
    {
        let videoURL = NSURL(string: item?.postfile ?? "")
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
extension PostWithVideoCell :UITableViewDataSource,UITableViewDelegate{
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
        let cell  = commentTblViewVideo.dequeueReusableCell(withIdentifier: CommunityCommentCell.className, for: indexPath) as! CommunityCommentCell
        let data = postCommentArray?[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.btnReply.tag = indexPath.row
        //cell.btnReply.addTarget(self, action: "actionReply", for: UIControl.Event.touchUpInside)
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        Utility.loadImage(onImageView: cell.imgView, imageURLString: data?.profileImage ?? "", placeHolder: "community_listing_user")
        cell.lblProfileName.text = data?.username
        cell.delegate = self
        cell.lblComment.text = data?.comment
        
        return cell
    }
    
    
}
extension PostWithVideoCell:CommentCellDelegate{
    func commentButtonClicked(index: Int){
        var dataToReplyOnComment = [String:String]()
        dataToReplyOnComment["post_id"] = item?.postId
        dataToReplyOnComment["commentId"] = item?.commentDataArray[index].id
        Utility.replyButtonTapped(selectedIndexDict: dataToReplyOnComment)
        //Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}

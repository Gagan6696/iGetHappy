//
//  PostWithImageCell.swift
//  SamplePostApp
//
//  Created by Akash Dhiman on 7/15/19.
//  Copyright © 2019 Akash Dhiman. All rights reserved.
//

import UIKit
import FTPopOverMenu_Swift
import AVFoundation
import MMPlayerView
import Reactions

@objc protocol PostWithImageDelegate {
    @objc optional func dropDownMenuTapped(sender: UIButton)
    @objc optional func selectProfileButtonTapped(sender: UIButton)
}

class PostWithImageCell: UICollectionViewCell {
    
    //MARK:- Variables
    var delegate: PostWithImageDelegate?
    let bottomBar = PostTabBar.instanceFromNib()
    var postCommentArray : [Post.CommentListModel]?

    
    //MARK:- Properties
    
    @IBOutlet weak var commentTblViewWithImage: UITableView!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var userTitleLabel: UILabel!
    @IBOutlet weak var postTimeStampLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var cellBottomBar: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var commentTableViewHeightConstraint: NSLayoutConstraint!
    
    //Populating cell with data
    var item: Post? {
        didSet {
            guard item != nil else {
                return
            }
            
            //Set name and images according to anonymus status
            Utility.setUserDetailOnPost(selectedData: item,
                                        userTitle: userTitleLabel,
                                        userImage: userProfileImageView,
                                        postDescription: postTextLabel, postTimeStamp: postTimeStampLabel)
            
            //Check wether it is same user post
            if Utility.isSameUserID(selectedData: item) {
                dropDownButton.isHidden = false
            }else{
                dropDownButton.isHidden = false
            }
            
            //Set emoji or like status
            if item?.isLike == 1{
                bottomBar.supportButton.isSelected = true
                bottomBar.supportButton.reaction = Utility.setEmoji(selectedData: item)!
            }else{
                bottomBar.supportButton.isSelected = false
                bottomBar.supportButton.reaction = Reaction.facebook.like
            }
            
            //Assign the Commented Array
            postCommentArray?.removeAll()
            postCommentArray = item?.commentDataArray
            commentTblViewWithImage.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
        registerNib()
        
        /** Comment work is pemsding from backend ,So for now all comment View and delegate are disconneted and hide.
 */
        commentTblViewWithImage.frame = CGRect(x: commentTblViewWithImage.frame.origin.x, y: commentTblViewWithImage.frame.origin.y, width: commentTblViewWithImage.frame.size.width, height: commentTblViewWithImage.contentSize.height)
        commentTblViewWithImage.delegate = self
        commentTblViewWithImage.dataSource = self
    }
    
    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        commentTblViewWithImage.register(commentNibCell, forCellReuseIdentifier: CommunityCommentCell.className)
        
        
    }
    
    func customizeView() {
        bottomBar.frame = cellBottomBar.bounds
        if !bottomBar.frame.contains(cellBottomBar.frame) {
            cellBottomBar.addSubview(bottomBar)
            bottomBar.delegate = self
        }
    }
    
    //MARK:- Button Actions
    @IBAction func selectProfileButtonAction(_ sender: UIButton) {
        delegate?.selectProfileButtonTapped!(sender: sender)
    }
   
    @IBAction func dropDownMenuAction(_ sender: UIButton) {
        delegate?.dropDownMenuTapped!(sender: sender)
        Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}
extension PostWithImageCell :UITableViewDataSource,UITableViewDelegate{
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
        let cell  = commentTblViewWithImage.dequeueReusableCell(withIdentifier: CommunityCommentCell.className, for: indexPath) as! CommunityCommentCell
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
extension PostWithImageCell:CommentCellDelegate{
    func commentButtonClicked(index: Int){
        var dataToReplyOnComment = [String:String]()
        dataToReplyOnComment["post_id"] = item?.postId
        dataToReplyOnComment["commentId"] = item?.commentDataArray[index].id
        Utility.replyButtonTapped(selectedIndexDict: dataToReplyOnComment)
        //Utility.showDropDownMenu(sender: sender, selectedData: item)
    }
}
extension PostWithImageCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

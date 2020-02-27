//
//  ReplyVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.


import UIKit

class ReplyVC: UIViewController {

    @IBOutlet weak var replyTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
    }
    
    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        replyTblView.register(commentNibCell, forCellReuseIdentifier: "CommunityCommentCell")
    }
    
    @IBAction func actionBack(_ sender: Any) {
    CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
}
extension ReplyVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = replyTblView.dequeueReusableCell(withIdentifier: "CommunityCommentCell", for: indexPath) as! CommunityCommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.btnReply.isHidden = true
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.lblProfileName.text = "Username _____"
        cell.lblComment.text = "New Comment TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest"
        return cell
    }
    
    
}
extension ReplyVC:CommentCellDelegate{
    
    func commentButtonClicked() {
        print("Delegate called")
    }
    
}

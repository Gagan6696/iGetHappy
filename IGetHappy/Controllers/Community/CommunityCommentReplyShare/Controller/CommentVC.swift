//
//  CommentVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {

    @IBOutlet weak var commentTblView: UITableView!

    var commentCell:CommunityCommentCell?
    override func viewDidLoad() {
        super.viewDidLoad()

        registerNib()
    }

    func registerNib() {
        let commentNibCell = UINib(nibName: CommunityCommentCell.className, bundle: nil)
        commentTblView.register(commentNibCell, forCellReuseIdentifier: "CommunityCommentCell")


    }

    @IBAction func close(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }

}
extension CommentVC :UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = commentTblView.dequeueReusableCell(withIdentifier: CommunityCommentCell.className, for: indexPath) as! CommunityCommentCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.btnReply.tag = indexPath.row
        //cell.btnReply.addTarget(self, action: "actionReply", for: UIControl.Event.touchUpInside)
        cell.imgView.layer.cornerRadius = cell.imgView.frame.height/2
        cell.imgView.image = UIImage.init(named: "community_listing_user")
        cell.lblProfileName.text = "Username _____"
        //cell.delegate = self
        cell.lblComment.text = "New Comment TestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTestTest"

        return cell
    }


}
extension CommentVC:CommentCellDelegate{
    func commentButtonClicked() {
        print("Delegate called")
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReplyOnComment, Data: nil)
    }


}

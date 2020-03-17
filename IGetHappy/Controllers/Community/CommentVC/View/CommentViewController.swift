//
//  CommentVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol CommentViewControllerViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class CommentViewController: BaseUIViewController,UITextFieldDelegate,UISearchBarDelegate
{
    
    //MARK: OUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var view_TypeText: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var constant_height_sendView: NSLayoutConstraint!
    @IBOutlet weak var constant_bottom_sendView: NSLayoutConstraint!
    @IBOutlet weak var myTextField: UITextField!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    var commentPostData:CommentsMapper?
    var selectedPost:Post?
    var presenter:CommentPresenter?
    
    
    //MARK: VARIABLES
    let cellID = "CellClass_CommentVCTableViewCell"
    var keyboardHeight : CGFloat = 0.0
    
    var limit = 20
    let totalEnteries = 100
    
    var searchActive = false
    var resultArray = NSMutableArray()
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 110
        myTextField.layer.cornerRadius = 10
        myTextField.layer.masksToBounds = true
        self.presenter = CommentPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
     //   self.presenter?.getAllComments(postId: selectedPost, limit: "10",skip: "0", searchKeyWord: "")
        
        
//        var index = 0
//        while index < limit
//        {
//            resultArray.add(index)
//            index = index + 1
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        bowDown_sendView()
        self.cancel_search()
        self.view.endEditing(true)
        self.presenter?.getAllComments(postId: selectedPost?.postId, limit: "10",skip: "0", searchKeyWord: "", isMoodLog: selectedPost?.isMoodLog ?? 0)
        
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func cellReplyAction(_ sender: Any)
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReplyCommentVC, Data: nil)

    }
    
    @IBAction func ACTION_SEARCH(_ sender: Any)
    {
        if (self.btnSearch.tag == 0)
        {
            self.btnSearch.tag = 1
            search_button_tapped()
            self.mySearchBar.becomeFirstResponder()
        }
        else if (self.btnSearch.tag == 1)
        {
            self.btnSearch.tag = 0
            cancel_search()
            self.mySearchBar.resignFirstResponder()
        }
    }
    @IBAction func ACTION_SEND_MESSAGE(_ sender: Any)
    {
        self.view.endEditing(true)
        bowDown_sendView()
        if (self.myTextField.text?.trim().isEmpty ?? true){
            self.showAlert(alertMessage: "Please enter some comments before post")
        }else{
            
            var parm = [String:Any]()
            if selectedPost?.isMoodLog == 1{
                parm["check"] = "moodLog"
                parm["mood_log_id"] = selectedPost?.postId
            }else{
                parm["check"] = "post"
                parm["post_id"] = selectedPost?.postId
            }
            
             self.presenter?.postComment(postDict: parm, comment: self.myTextField.text)
            self.myTextField.text = ""
        }
        
       
       
        
        
       
     
        
       // self.myTextView.text = "Write a comment"
//        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
//            self.constant_height_sendView.constant = 52
//            self.view.layoutIfNeeded()
//        }) { _ in
//        }
        
       // self.scrollToBottom()
    }
    
    
    //MARK: TEXTVIEW DELEGATES
//    var previousRect = CGRect.zero
//    func textViewDidChange(_ textView: UITextView)
//    {
//        let pos = textView.endOfDocument
//        let currentRect = textView.caretRect(for: pos)
//        if previousRect != CGRect.zero
//        {
//            if currentRect.origin.y > previousRect.origin.y
//            {
//                self.increase_view_height()
//            }
//            else if currentRect.origin.y < previousRect.origin.y
//            {
//                self.decrease_view_height()
//            }
//        }
//        previousRect = currentRect
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
//    {
//        if(text == "\n")
//        {
//            textView.resignFirstResponder()
//            self.bowDown_sendView()
//            return false
//        }
//        return true
//    }
//
//    func textViewDidBeginEditing(_ textView: UITextView)
//    {
//        self.myTextView.text = ""
//        self.pullUp_sendView()
//    }
    
    //MARK: UITEXT FIELD DELEGATE FUNCTIONS
//    func textFieldDidBeginEditing(_ textField: UITextField)
//    {
//        self.pullUp_sendView()
//    }
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        bowDown_sendView()
        self.view.endEditing(true)
        return true
    }
    
    
    //MARK: HANDLING SEND VIEW WHEN KEYBOOARD IS APPEAR
    func pullUp_sendView()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.constant_bottom_sendView.constant = -self.keyboardHeight
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    func bowDown_sendView()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.constant_bottom_sendView.constant = 0
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    
    func increase_view_height()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            let height = self.constant_height_sendView.constant
            self.constant_height_sendView.constant = height+15
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    func decrease_view_height()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            let height = self.constant_height_sendView.constant
            self.constant_height_sendView.constant = height-15
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    func scrollToBottom()
    {
        let numRows = tableView(self.myTableView, numberOfRowsInSection: 0)
        var contentInsetTop = self.myTableView.bounds.size.height
        for i in 0..<numRows
        {
            let rowRect = self.myTableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0
            {
                contentInsetTop = 0
            }
        }
        self.myTableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
    
    @objc func keyboardWillShow(_ notification: NSNotification)
    {
        if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.keyboardHeight = keyboardRect.height
            
            if (searchActive == false)
            {
                self.pullUp_sendView()
            }
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        searchActive = false
        bowDown_sendView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = false;
       // self.postListingArray_filter.removeAll()
       // self.postCollectionView.reloadData()
        
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.mySearchBar.showsCancelButton = false
        self.cancel_search()
        self.btnSearch.tag = 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchActive = true
        
        
        
        self.presenter?.getAllComments(postId: selectedPost?.postId, limit: "10",skip: "0", searchKeyWord: self.mySearchBar.text, isMoodLog: selectedPost?.isMoodLog ?? 0)
        
//        self.postListingArray_filter.removeAll()
//
//        if (self.postListingArray.count > 0)
//        {
//            for obj in self.postListingArray
//            {
//                let str = obj?.userName ?? ""
//                let search = self.mySearchBar.text ?? ""
//
//                if let _ = str.range(of: search, options: .caseInsensitive)
//                {
//                    self.postListingArray_filter.append(obj)
//                }
//
//                //                if (str.contains("\(search)"))
//                //                {
//                //                   self.postListingArray_filter.append(obj)
//                //                }
//            }
//
//            self.postCollectionView.reloadData()
//        }
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchActive = true;
        self.mySearchBar.showsCancelButton = true
    }
    
    
    
    func search_button_tapped()
    {
        self.searchActive = true
        
        self.mySearchBar.isHidden = false
        self.btnBack.isHidden = true
        self.lblTitle.isHidden = true
    }
    
    func cancel_search()
    {
        self.searchActive = false
        
        self.mySearchBar.isHidden = true
        self.btnBack.isHidden = false
        self.lblTitle.isHidden = false
    }
    
}


extension CommentViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if commentPostData?.data?.count ?? 0 > 0{
            self.myTableView.backgroundView = nil
            return commentPostData?.data?.count ?? 0
        }else{
           // self.myTableView.setEmptyMessage("No comments found")
            return 0
        }

    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 20.0
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_CommentVCTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lbl_message.text = commentPostData?.data?[indexPath.row].comment
        cell.iv_Avatar.setRounded()
        let url = URL(string:  (commentPostData?.data?[indexPath.row].profile_image ?? ""))
        cell.iv_Avatar.kf.indicatorType = .activity
        cell.iv_Avatar.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.lbl_userName.text = commentPostData?.data?[indexPath.row].username

        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        if indexPath.row == resultArray.count - 1
//        {
//            self.presenter?.getAllComments(postId: selectedPost, limit: "10",skip: "\(resultArray.count)", searchKeyWord: "")
//
//
//            // we are at last cell load more content
//            if resultArray.count < totalEnteries
//            {
//                // we need to bring more records as there are some pending records available
//                var index = resultArray.count
//                limit = index + 20
//                while index < limit
//                {
//                    resultArray.add(index)
//                    index = index + 1
//                }
//
//                showLoader()
//                self.perform(#selector(loadTable), with: nil, afterDelay: 1.0)
//            }
//        }
//    }
    
    
    @objc func loadTable()
    {
        self.myTableView.reloadData()
        hideLoader()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dataToReplyOnComment = [String:String]()
        
        dataToReplyOnComment["commentId"] = commentPostData?.data?[indexPath.row]._id
        ///This check provide information  that we are dealing with mood log or simple post for backend database
        if selectedPost?.isMoodLog == 1{
            dataToReplyOnComment["check"] = "moodLog"
            dataToReplyOnComment["mood_log_id"] = commentPostData?.data?[indexPath.row].post_id
        }else{
            dataToReplyOnComment["post_id"] = commentPostData?.data?[indexPath.row].post_id
            dataToReplyOnComment["check"] = "post"
        }
        
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReplyCommentVC, Data: dataToReplyOnComment)
    }
    
}

extension CommentViewController: CommentViewControllerDelegate{
    func PostCommentViewControllerDidSucceeed(message: String?) {
        self.hideLoader()
        self.showAlert(alertMessage: message ?? "")
        self.presenter?.getAllComments(postId: selectedPost?.postId, limit: "10",skip: "0", searchKeyWord: "", isMoodLog: selectedPost?.isMoodLog ?? 0)
        self.myTextField.text = ""
    }

    func CommentViewControllerDidSucceeed(data: CommentsMapper) {
        self.hideLoader()
        self.commentPostData = data
        self.myTableView.reloadData()
    }
    func  CommentViewControllerDidFailed(message:String?)
    {
        self.hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension CommentViewController: CommentViewControllerViewDelegate{
    func showAlert(alertMessage: String) {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

//
//  ReplyViewController.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol ReplyViewControllerViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class ReplyViewController: BaseUIViewController,UITextFieldDelegate,UISearchBarDelegate
{

    //MARK: OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myTextView: UITextView!
    @IBOutlet weak var view_TypeText: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var constant_height_sendView: NSLayoutConstraint!
    @IBOutlet weak var constant_bottom_sendView: NSLayoutConstraint!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    //MARK: VARIABLES
    let cellID = "cellClass_ReplyVC"
    var keyboardHeight : CGFloat = 0.0
    var presenter:ReplyPresenter?
    var replyMapperData :ReplyMapper?
    
    var dataForPostReply = [String:String]()

    var limit = 20
    let totalEnteries = 100
    var resultArray = NSMutableArray()
    var searchActive = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 150
        myTextField.layer.cornerRadius = 10
        myTextField.layer.masksToBounds = true
        self.presenter = ReplyPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        self.presenter?.getAllReplyOnComment(postAndCommentId: dataForPostReply,searchtxt:"")

//        var index = 0
//        while index < limit
//        {
//            resultArray.add(index)
//            index = index + 1
//        }
        
    }
    

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.cancel_search()
        self.view.endEditing(true)
        
    }
    
    //MARK: BUTTON ACTIONS
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
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
        
        if (self.myTextField.text?.trim().isEmpty ?? true){
            self.showAlert(alertMessage: "Please enter some reply on comment before post")
        }else{
            bowDown_sendView()
            self.view.endEditing(true)
            self.cancel_search()
            self.presenter?.postReplyOnComment(postAndCommentId: dataForPostReply, comment:self.myTextField.text)
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
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        //self.pullUp_sendView()
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
        self.presenter?.getAllReplyOnComment(postAndCommentId: dataForPostReply,searchtxt:self.mySearchBar.text ?? "")
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

extension ReplyViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if replyMapperData?.data?.count ?? 0 > 0
        {
            self.myTableView.backgroundView = nil
            return replyMapperData?.data?.count ?? 0
        }
        else
        {
            self.myTableView.setEmptyMessage("No Replies on this post found")
            return 0
        }
     
    }
    
//    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//        return 20.0
//    }
//
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! cellClass_ReplyVC
        cell.lbl_message.text = replyMapperData?.data?[indexPath.row].comment
        cell.lbl_userName.text = replyMapperData?.data?[indexPath.row].username
        cell.iv_Avatar.setRounded()
        let url = URL(string: replyMapperData?.data?[indexPath.row].profile_image ?? "")
        cell.iv_Avatar?.kf.indicatorType = .activity
        cell.iv_Avatar?.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        if ()
//    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
//    {
//        if indexPath.row == resultArray.count - 1
//        {
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
//
    
    @objc func loadTable()
    {
        self.myTableView.reloadData()
        hideLoader()
    }
}

extension ReplyViewController: ReplyViewControllerDelegate{
    func ReplyViewControllergetRepliesDidSucceeed(data: ReplyMapper) {
        self.hideLoader()
        self.replyMapperData = data
        self.myTableView.reloadData()
    }
    
    
    func ReplyViewControllerDidSucceeed(data: String?)
    {
        self.hideLoader()
        self.showAlert(Message: data ?? "")
        self.presenter?.getAllReplyOnComment(postAndCommentId: dataForPostReply, searchtxt: "")
        self.myTextField.text = ""
    }
    
    func  ReplyViewControllerDidFailed(message:String?)
    {
        self.hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension ReplyViewController: ReplyViewControllerViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

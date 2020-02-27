//
//  ReplyPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

protocol ReplyViewControllerDelegate : class {
    func ReplyViewControllergetRepliesDidSucceeed(data:ReplyMapper)
    func ReplyViewControllerDidSucceeed(data:String?)
    func ReplyViewControllerDidFailed(message:String?)
}

class ReplyPresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:ReplyViewControllerDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var ReplyViewControllerDelegateView: ReplyViewControllerViewDelegate?
    
    init(delegate:ReplyViewControllerDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ReplyViewControllerViewDelegate) {
        ReplyViewControllerDelegateView = view
    }
    //Detaching login view
    func detachView() {
        ReplyViewControllerDelegateView = nil
    }
    func postReplyOnComment(postAndCommentId:[String:String],comment:String?){
        self.ReplyViewControllerDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "PostComment/postReplyComment"
        parm = postAndCommentId
        if let userID = UserDefaults.standard.getUserId(){
            parm["user_id"] = userID
        }else{
            self.delegate.ReplyViewControllerDidFailed(message: "")
        }
        parm["comment"] = comment
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
               self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidSucceeed(data: "Reply Posted Successfully")
            
        }, completionnilResponse: { (message) in
            print(message)
            self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
             self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
    }
    
    func getAllReplyOnComment(postAndCommentId:[String:String],searchtxt:String)
    {
        self.ReplyViewControllerDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        let url = "postComment/getCommentReply"
        parm = postAndCommentId
        if let userId = UserDefaults.standard.getUserId(){
            parm["user_id"] = userId
        }
        
        parm["limit"] =  "100"
        parm["skip"] = "0"
        parm["keyword"] = searchtxt
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.postReplyDataJSON(data: response, completionResponse: { (replyData) in
                self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllergetRepliesDidSucceeed(data: replyData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.ReplyViewControllerDelegateView?.hideLoader()
                self.delegate.ReplyViewControllerDidFailed(message: error?.localizedDescription)
                //print(error!)
            })

            
        }, completionnilResponse: { (message) in
            print(message)
            self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
              self.ReplyViewControllerDelegateView?.hideLoader()
            self.delegate.ReplyViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
    }
    private func postReplyDataJSON(data: [String : Any],completionResponse:  @escaping (ReplyMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let postReplyData = ReplyMapper(JSON: data)
        completionResponse(postReplyData!)
    }
}




//  CommentPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 11/18/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//
protocol CommentViewControllerDelegate : class
{
    func PostCommentViewControllerDidSucceeed(message:String?)
    func CommentViewControllerDidSucceeed(data:CommentsMapper)
    func CommentViewControllerDidFailed(message:String?)
    
}

class CommentPresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:CommentViewControllerDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var CommentViewControllerDelegateView: CommentViewControllerViewDelegate?
    
    init(delegate:CommentViewControllerDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: CommentViewControllerViewDelegate) {
        CommentViewControllerDelegateView = view
    }
    //Detaching login view
    func detachView() {
        CommentViewControllerDelegateView = nil
    }
    func postComment(postDict:[String:Any],comment:String?){
        self.CommentViewControllerDelegateView?.showLoader()
       
        
        parm = postDict
        //Remove this and add to global class //Reminder
        let url = "postComment/addComment"
        if let userID = UserDefaults.standard.getUserId(){
            parm["user_id"] = userID
        }else{
             self.delegate.CommentViewControllerDidFailed(message: "")
        }
       // parm["post_id"] = postId
        parm["comment"] = comment
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            self.CommentViewControllerDelegateView?.hideLoader()
            let message = response["message"] as? String
            print(response)
            self.delegate.PostCommentViewControllerDidSucceeed(message:message)
        }, completionnilResponse: { (message) in
            print(message)
            self.CommentViewControllerDelegateView?.hideLoader()
            self.delegate.CommentViewControllerDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.CommentViewControllerDelegateView?.hideLoader()
            self.delegate.CommentViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.CommentViewControllerDelegateView?.hideLoader()
            self.delegate.CommentViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
    
    }
   
    func getAllComments(postId:String?,limit:String,skip:String,searchKeyWord:String?,isMoodLog:Int)
    {
        self.CommentViewControllerDelegateView?.showLoader()
        //Remove this and add to global class //Reminder
        
        if isMoodLog == 1{
            parm["check"] = "moodLog"
            parm["mood_log_id"] = postId
        }else{
            parm["check"] = "post"
            parm["post_id"] = postId
        }

        let url = "postComment/getComment"
        if let userId = UserDefaults.standard.getUserId()
        {
             parm["user_id"] = userId
        }
//        if let postid = postId
//        {
//            parm["post_id"] = postid
//        }

        parm["limit"] = limit
        parm["skip"] = skip
        parm["keyword"] = searchKeyWord
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response in
            print(response)
            self.CommentViewControllerDataJSON(data: response, completionResponse: { (commentsData) in
                self.CommentViewControllerDelegateView?.hideLoader()
                self.delegate.CommentViewControllerDidSucceeed(data: commentsData)
                //send data to delegate
                
            }, completionError: { (error) in
                self.CommentViewControllerDelegateView?.hideLoader()
                self.delegate.CommentViewControllerDidFailed(message: error?.localizedDescription)
                //print(error!)
            })
              
        }, completionnilResponse: { (message) in
                print(message)
                self.CommentViewControllerDelegateView?.hideLoader()
                self.delegate.CommentViewControllerDidFailed(message: message)
                //send data to delegate
        
            }, completionError: { (error) in
                self.CommentViewControllerDelegateView?.hideLoader()
                self.delegate.CommentViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                    //send data to delegate
        
            }) { (error) in
                self.CommentViewControllerDelegateView?.hideLoader()
                self.delegate.CommentViewControllerDidFailed(message: Constants.Global.MessagesStrings.ServerError)
                   print(error)
        
            }
    }
    
    private func CommentViewControllerDataJSON(data: [String : Any],completionResponse:  @escaping (CommentsMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let commentsData = CommentsMapper(JSON: data)
        completionResponse(commentsData!)
    }
}


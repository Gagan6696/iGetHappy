//
//  ChatBotPresenter.swift
//  IGetHappy
//
//  Created by Gagan on 10/31/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
protocol ChatBotDelegate : class {
    func ChatBotDidSucceeed(data:ChooseCareRecieverMapper?)
    func ChatBotDidFailed(message:String?)
}


class ChatBotPresenter{
    //ChooseCareRecieverPresenter Delegate
    var delegate:ChatBotDelegate
    var parm = [String:Any]()
    // ChooseCareRecieverPresenter  weak object to save from being retain cycle
    weak var ChatBotDelegateView: ChatBotViewDelegate?
    
    init(delegate:ChatBotDelegate) {
        self.delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: ChatBotViewDelegate) {
        ChatBotDelegateView = view
    }
    //Detaching login view
    func detachView() {
        ChatBotDelegateView = nil
    }
    
    func GetAllListCareReciever()
    {
        
        self.ChatBotDelegateView?.showLoader()
         let userId = UserDefaults.standard.getUserId() ?? ""
        
        parm["user_id"] = userId
        
        //Remove this and add to global class //Reminder
        let url = "careReceivers/getApprovedCareReceiver"
        ServiceCall.sharedManager.PostApi(url: url, parameter: parm, completionResponse: { response
            in
            print(response)
            self.CareRecieverDataJSON(data: response, completionResponse: { (careRecieverData) in
                self.ChatBotDelegateView?.hideLoader()
                self.delegate.ChatBotDidSucceeed(data: careRecieverData)
                //send data to delegate
                
            }, completionError: { (error) in
                  self.ChatBotDelegateView?.hideLoader()
                print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
             self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
        
        
        //        ChooseCareRecieverService.sharedInstance.GetEmaotionService(urlMedia: url as! URL, url: UrlStrings.UploadPost.AllTypePost,completionResponse: { (message) in
        //
        //            self.BaseTabDelegateView?.hideLoader()
        //            self.delegate.BaseTabDidSucceeed(message: message)
        //        }, completionnilResponse: { (message) in
        //            self.BaseTabDelegateView?.hideLoader()
        //            self.BaseTabDelegateView?.showAlert(alertMessage: message)
        //        }, completionError: { (error) in
        //            print(error)
        //            self.BaseTabDelegateView?.showAlert(alertMessage: "\(error)")
        //        }) { (networkerror) in
        //
        //            self.BaseTabDelegateView?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        //
        //        }
        
        
    }
    /**
     Reused mapper here ChooseCareRecieverMapper instead of creating new one
     */
    
    func hitMessageSend(dict: [String:Any],userId:String , completion: @escaping(chatBotOutput) -> Void) {
        guard let userid = UserDefaults.standard.getUserId() else{
            return
        }
        
        let url = "http://np.seasiafinishingschool.com:7078/chatbot/message/" + "\(userid)" + "/"
        self.ChatBotDelegateView?.showLoader()
        ServiceCall.sharedManager.PostApiChatBot(url: url, parameter: dict, completionResponse: { response
            in
            print(response)
             self.ChatBotDelegateView?.hideLoader()
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                let getAllPostsResponse = try JSONDecoder().decode(chatBotOutput.self, from: jsonData)
                print(getAllPostsResponse)
                completion(getAllPostsResponse)
                
            } catch {
                print(error.localizedDescription)
                 self.delegate.ChatBotDidFailed(message: error.localizedDescription)
            }
         
        }, completionnilResponse: { (message) in
            print(message)
            self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: message)
            //send data to delegate
            
        }, completionError: { (error) in
            self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            //send data to delegate
            
        }) { (error) in
            self.ChatBotDelegateView?.hideLoader()
            self.delegate.ChatBotDidFailed(message: Constants.Global.MessagesStrings.ServerError)
            print(error)
            
        }
    }
    private func CareRecieverDataJSON(data: [String : Any],completionResponse:  @escaping (ChooseCareRecieverMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let careRecieverData = ChooseCareRecieverMapper(JSON: data)
        completionResponse(careRecieverData!)
    }
    
}

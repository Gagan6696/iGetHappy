//
//  GalleryVcPresenter.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit


protocol GalleryPresenterDelegate : class
{
    func api_success_result(results:GetHappyMemoriesMapper)
}

class GalleryVcPresenter
{
    weak var view_delegate: GalleryVCViewDelegate?
    var presenter_delegate:GalleryPresenterDelegate
    var getResponse:Handle_Response?
    var parm = [String:Any]()
    
    init(delegate:GalleryPresenterDelegate)
    {
        self.presenter_delegate = delegate
    }
    
    //Attaching login view
    func attachView(view: GalleryVCViewDelegate)
    {
        view_delegate = view
    }
    //Detaching login view
    func detachView()
    {
        view_delegate = nil
    }
    
    
    
//    func CALL_API_GET_HAPPY_MEMORIES_FILES()
//    {
//        let userID = UserDefaults.standard.getUserId() ?? "0"
//        self.view_delegate?.showLoader()
//
//        let urlfinal = UrlStrings.BASE_URL + UrlStrings.HappyMemories.getHappyMemories + userID
//        let param : [String:Any] = [:]
//
//        CommonVc.AllFunctions.HeaderWithGETRequestToken_MODEL(forURL: urlfinal, params: param as [String : AnyObject], success: { (response, error) in
//
//            if((error == nil))
//            {
//                self.getResponse = response
//                if self.getResponse?.status == 200
//                {
//
//                    if let getData = self.getResponse?.HappyMemoriesGallery_Respnse
//                    {
//                        self.view_delegate?.hideLoader()
//                        self.presenter_delegate.api_success_result(results: getData)
//                    }
//                    else
//                    {
//                        self.view_delegate?.hideLoader()
//                        self.view_delegate?.showAlert(alertMessage: Constants.Global.MessagesStrings.SomethingWentWrong)
//                    }
//                }
//                else
//                {
//                    let msg = self.getResponse?.messege ?? "Internal Error!"
//                    self.view_delegate?.hideLoader()
//                    self.view_delegate?.showAlert(alertMessage: msg)
//                }
//
//            }
//            else
//            {
//                self.view_delegate?.hideLoader()
//                self.view_delegate?.showAlert(alertMessage: Constants.Global.MessagesStrings.SomethingWentWrong)
//            }
//        })
//
//
//    }
    
    
    
    
    func CALL_API_GET_HAPPY_MEMORIES_FILES()
    {
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        self.view_delegate?.showLoader()
        
        let url = UrlStrings.HappyMemories.getHappyMemories + userID
        
        ServiceCall.sharedManager.GetApi(url: url, completionResponse: { response in
            
            self.view_delegate?.hideLoader()
            print(response)
            
            self.MemoriesDataJSON(data: response, completionResponse: { (memoryData) in
                self.presenter_delegate.api_success_result(results: memoryData)
                
            }, completionError: { (error) in
                 self.view_delegate?.hideLoader()
                self.view_delegate?.showAlert(alertMessage: error?.localizedDescription ?? "Error in Mapping")
            })
            
        }, completionnilResponse: { (message) in
            print(message)
            self.view_delegate?.hideLoader()
            self.view_delegate?.showAlert(alertMessage: message)
            
        }, completionError: { (error) in
            self.view_delegate?.hideLoader()
            self.view_delegate?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
            
        }) { (error) in
            self.view_delegate?.hideLoader()
            self.view_delegate?.showAlert(alertMessage: Constants.Global.MessagesStrings.ServerError)
        }
        
    }
    
    
    
    
    

    
    private func MemoriesDataJSON(data: [String : Any],completionResponse:  @escaping (GetHappyMemoriesMapper) -> Void,completionError: @escaping (Error?) -> Void)
    {
        let Data = GetHappyMemoriesMapper(JSON: data)
        completionResponse(Data!)
    }
    
}

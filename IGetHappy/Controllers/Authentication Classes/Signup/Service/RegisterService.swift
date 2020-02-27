//
//  RegisterService.swift
//  IGetHappy
//
//  Created by Gagan on 5/20/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class RegisterService:NSObject{
    
    static let sharedInstance = RegisterService()
    
    func UserRegisterService(url : String,postDict:[String : Any],completionResponse:  @escaping (LoginData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: postDict, completionResponse: { response
            in
            print(response)
            
            //completionResponse(response)
            //Map Json here
            
            
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
            print(error)
        }
        
        
    }
}

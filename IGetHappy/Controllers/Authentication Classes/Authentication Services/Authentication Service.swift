//
//  Authentication Service.swift
//  IGetHappy
//
//  Created by Gagan on 7/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
class AuthenticationService:NSObject{
    
    static let sharedInstance = AuthenticationService()
    
    func UserLoginService(url : String,postDict:[String : Any],completionResponse:  @escaping (LoginData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: postDict, completionResponse: { response
            in
            self.LoginDataJSON(data: response, completionResponse: { (loginData) in
            completionResponse(loginData)
            }, completionError: { (error) in
            print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
            print(error)
        }
    }
    
    private func LoginDataJSON(data: [String : Any],completionResponse:  @escaping (LoginData) -> Void,completionError: @escaping (Error?) -> Void)  {
        let loginData = LoginData(JSON: data)
        completionResponse(loginData!)
    }

    func UserForgotService(url : String,postDict:[String : Any],completionResponse:  @escaping (ForgotData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: postDict, completionResponse: { response
            in
            self.ForgotDataJSON(data: response, completionResponse: { (forgotData) in
                completionResponse(forgotData)
            }, completionError: { (error) in
                print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
            print(error)
        }
    }
    
    private func ForgotDataJSON(data: [String : Any],completionResponse:  @escaping (ForgotData) -> Void,completionError: @escaping (Error?) -> Void)  {
        let forgotData = ForgotData(JSON: data)
        completionResponse(forgotData!)
    }
    
    func CheckEmailService(url : String,email:String?,completionResponse:  @escaping (CheckEmailMapper) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        let urlfinal = url + email!
        
        ServiceCall.sharedManager.GetApi(url: urlfinal, completionResponse: { response
            in
            self.CheckEmailDataJSON(data: response, completionResponse: { (checkEmailData) in
                print(checkEmailData)
                completionResponse(checkEmailData)
            }, completionError: { (error) in
                print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
            print(error)
        }
    }
    
    func CheckPhoneService(url : String,phoneNum:String?,completionResponse:  @escaping (CheckEmailMapper) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        let urlfinal = url + phoneNum!
        
        ServiceCall.sharedManager.GetApi(url: urlfinal, completionResponse: { response
            in
            self.CheckEmailDataJSON(data: response, completionResponse: { (checkEmailData) in
                print(checkEmailData)
                completionResponse(checkEmailData)
            }, completionError: { (error) in
                print(error!)
            })
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
            print(error)
        }
    }
    
    private func CheckEmailDataJSON(data: [String : Any],completionResponse:  @escaping (CheckEmailMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let checkEmailData = CheckEmailMapper(JSON: data)
        completionResponse(checkEmailData!)
    }
    
    func UploadMultipartRegisterData(url : String,postDict:[String:Any],imageData :UIImage,completionResponse:  @escaping (RegisterCompleteMapper) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.MultipartServiceApi(type: .Image, urlMedia: nil, urlString: url, fileData: imageData, requestDict: postDict, method: .post, compBlock: { (responseDict, response) in
            print(responseDict)
            if let statusCodeNew = responseDict["status"] {
                print(statusCodeNew)
                let statusCode = "\(statusCodeNew)"
                if(statusCode == "200"){
                    self.UploadMultipartRegisterDataJSON(data: responseDict, completionResponse: { (SignupData) in
                        print(SignupData)
                        completionResponse(SignupData)
                    }, completionError: { (error) in
                        
                    })
                }else{
               
                    if let message = responseDict["message"]{
                        let message = "\(message)"
                        completionnilResponse(message)
                    }
                    
                }
                
                
            }
            
            
            
            
            
        }) { (networkError) in
            print(networkError)
        }
        
        
    }
    
    private func UploadMultipartRegisterDataJSON(data: [String : Any],completionResponse:  @escaping (RegisterCompleteMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let SignupData = RegisterCompleteMapper(JSON: data)
        completionResponse(SignupData!)
    }
    
    func UploadMultipartAddCareRecieverData(url : String,postDict:[String:Any],imageData:UIImage,completionResponse:  @escaping (AddCareRecieverData) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.MultipartServiceApi(type:.Image,urlMedia: nil, urlString: url, fileData: imageData, requestDict: postDict, method: .post, compBlock: { (responseDict, response) in
            self.UploadMultipartAddCareRecieverDataJSON(data: responseDict, completionResponse: { (addCareRecieverData) in
                print(addCareRecieverData.status)
                if(addCareRecieverData.status != 200){
                    if(addCareRecieverData.status == 203){
                        completionnilResponse(addCareRecieverData.message!)
                    }else{
                         completionnilResponse(addCareRecieverData.message!)
                    }
                }else{
                     completionResponse(addCareRecieverData)
                }

            }, completionError: { (error) in
                completionError(error)
               // print(error!)

            })
            print(responseDict)
        }) { (networkError) in
            completionError(networkError) //networkError(Constants.Global.MessagesStrings.ServerError)
             //completionError(networkError)
            print(networkError)
        }
        
    }
    
    private func UploadMultipartAddCareRecieverDataJSON(data: [String : Any],completionResponse:  @escaping (AddCareRecieverData) -> Void,completionError: @escaping (Error?) -> Void)  {
        
        let addCareRecieverData = AddCareRecieverData(JSON: data)
        completionResponse(addCareRecieverData!)
        
    }
    func FindLanguagesService(url : String,completionResponse:  @escaping (LanguagesMapper) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        
        let urlfinal = url
        
        ServiceCall.sharedManager.GetApi(url: urlfinal, completionResponse: { response
            in
            self.FindLanguagesDataJSON(data: response, completionResponse: { (languagesData) in
                completionResponse(languagesData)
            }, completionError: { (error) in
                print(error!)
                
            })
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
    
    private func FindLanguagesDataJSON(data: [String : Any],completionResponse:  @escaping (LanguagesMapper) -> Void,completionError: @escaping (Error?) -> Void)  {
        let languagesData = LanguagesMapper(JSON: data)
        completionResponse(languagesData!)
    }
    
    func DeleteCareRecieverService(url : String,completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        let appendIdUrl = UrlStrings.AddCareReciever.careReceivers + url
        ServiceCall.sharedManager.deleteApi(url: appendIdUrl, completionResponse: { (message) in
            completionResponse(message)
        }, completionnilResponse: { (message) in
            print(message)
            completionnilResponse(message)
        }, completionError: { (error) in
            completionError(error)
        }) { (error) in
           completionnilResponse(Constants.Global.MessagesStrings.ServerError)
             //print(error)
        }
    }
    
    func AddTextPostService(url : String,postDict:[String : Any],completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        
        ServiceCall.sharedManager.PostApi(url: url, parameter: postDict, completionResponse: { response in
            
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

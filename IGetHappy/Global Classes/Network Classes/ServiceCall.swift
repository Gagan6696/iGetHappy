//
//  ServiceCall.swift
//  IGetHappy
//
//  Created by Gagan on 5/16/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import Alamofire
enum DataType
{
    case Image
    case Video
    case Audio
    case none
}


class ServiceCall  {
    
    typealias completionBlock = ([String: Any], DataResponse<Any>) -> Void
    typealias failureBlock = (Error) -> Void
    static let sharedManager = ServiceCall()
    private init() {
        
    }
    
    func serviceApi(_ urlString: String, requestDict : [String :AnyObject]?, method: HTTPMethod, compBlock : @escaping completionBlock, failure : @escaping failureBlock) {
        
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        //let headers    = ["Content-Type" : "application/x-www-form-urlencoded","Authorization": "\(accessTokken)","Accept" : "application/json"]
        let headers    = ["Content-Type" : "application/x-www-form-urlencoded","Authorization": "\(accessTokken)","Accept" : "application/json"]
        
        AlamofireManager.shared.request(urlString, method: method, parameters: requestDict, encoding:  URLEncoding.default, headers: headers).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result)
            {
                
            case .success(_):
                if response.result.value != nil
                {
                    let statusCode = (response.response?.statusCode)!
                    print("...HTTP code: \(statusCode)")
                    var responseDict = [String: Any]()
                    if let jsonDict = response.result.value as? [String: Any]
                    {
                        responseDict = jsonDict
                    }
                    compBlock(responseDict, response)
                }
                break
                
            case .failure(_):
                failure(response.result.error!)
                break
            }
        }
    }
    
    func  PostApi(url : String, parameter : [String:Any] ,completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void)
    {
        let urlComplete =  UrlStrings.BASE_URL + url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers    = ["Content-Type" : "application/json","Authorization": "\(accessTokken)","Accept" : "application/json"]
        AlamofireManager.shared.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                DispatchQueue.main.async {
                    if response.result.isSuccess
                    {
                        if let dic = response.value as? NSDictionary
                        {
                            if (dic.value(forKey: "status") as! Int)  != 200
                            {
                                if (dic.value(forKey: "status") as! Int)  == 400
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else if (dic.value(forKey: "status") as! Int) == 204
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else if (dic.value(forKey: "status") as! Int) == 401
                                {
                                    //completionnilResponse(dic.value(forKey: "message") as! String)
                                    self.LOGOUT_VIEW()
                                }
                                else
                                {
                                    completionError(response.error)
                                }
                            }
                            else
                            {
                                guard let data = response.value else{return}
                                completionResponse(data as? [String : Any] ?? ["":""])
                            }
                        }
                        else
                        {
                            print(response as Any)
                            completionError(response.error)
                            // completionnilResponse(dic.value(forKey: "message") as! String)
                        }
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
                }
        }
    }
    
    func GetApi(url : String, completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void)
    {
        let urlComplete =  UrlStrings.BASE_URL + url
        print(urlComplete)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        
        let headers    = ["Content-Type" : "application/json","Authorization": "\(accessTokken)","Accept" : "application/json"]
        
        AlamofireManager.shared.request(urlComplete, method: .get, parameters: nil, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                DispatchQueue.main.async {
                    if response.result.isSuccess
                    {
                        //                        guard let data = response.value else{return}
                        //                        let  responseData  = data as! NSDictionary
                        //                        let statusCode = responseData["code"]  as! Int
                        //                        guard let dataFinal = response.value as? [String:Any] else {
                        //                            completionError(response.error)
                        //                            return
                        //                        }
                        //
                        //                        if statusCode == 200
                        //                        {
                        //                            completionResponse(responseData as NSDictionary)
                        //                        }
                        //                        else
                        //                        {
                        //                            completionnilResponse(responseData as NSDictionary)
                        //                        }
                        if let dic = response.value as? NSDictionary
                        {
                            if (dic.value(forKey: "status") as! Int)  != 200
                            {
                                //completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                if (dic.value(forKey: "status") as! Int)  ==  204 || (dic.value(forKey: "status") as! Int)  ==  503
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else if ((dic.value(forKey: "status") as! Int)  ==  401)
                                {
                                    self.LOGOUT_VIEW()
                                }
                                else
                                {
                                    if ((dic.value(forKey: "status") as! Int)  == 400)
                                    {
                                        let msg = dic.value(forKey: "message") as? String ?? ""
                                        networkError(msg)
                                    }
                                    else
                                    {
                                        completionError(response.error)
                                    }
                                    
                                }
                            }
                            else
                            {
                                
                                guard let data = response.value else{return}
                                print(data)
                                completionResponse(data as? [String : Any] ?? ["":""])
                            }
                        }
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
                }
        }
    }
    
    
    func PostApiChatBot(url : String, parameter : [String:Any] ,completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void) {
        let urlComplete =  url
        var accessTokken = ""
        
        let headers    = ["Content-Type" : "application/json"]
        AlamofireManager.shared.request(urlComplete, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                DispatchQueue.main.async {
                    if response.result.isSuccess
                    {
                        if let dic = response.value as? NSDictionary
                        {
                            if (dic.value(forKey: "status") as! Int)  != 200
                            {
                                if (dic.value(forKey: "status") as! Int)  == 400
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else if (dic.value(forKey: "status") as! Int) == 204
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else if (dic.value(forKey: "status") as! Int) == 401
                                {
                                    //completionnilResponse(dic.value(forKey: "message") as! String)
                                    self.LOGOUT_VIEW()
                                }
                                else
                                {
                                    completionError(response.error)
                                }
                            }
                            else
                            {
                                guard let data = response.value else{return}
                                completionResponse(data as? [String : Any] ?? ["":""])
                            }
                        }
                        else
                        {
                            print(response as Any)
                            completionError(response.error)
                            // completionnilResponse(dic.value(forKey: "message") as! String)
                        }
                    }
                    else
                    {
                        print(response.error?.localizedDescription)
                        completionError(response.error)
                        return
                    }
                }
        }
    }
    
    
    func PutApi(url : String, parameter : [String:Any] ,completionResponse:  @escaping ([String : Any]) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void)
    {
        let urlComplete =  UrlStrings.BASE_URL + url
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers    = ["Content-Type" : "application/json","Authorization": "\(accessTokken)","Accept" : "application/json"]
        
        
        AlamofireManager.shared.request(urlComplete, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers : headers)
            .responseJSON { response in
                
                DispatchQueue.main.async {
                    if response.result.isSuccess
                    {
                        if let dic = response.value as? NSDictionary {
                            if (dic.value(forKey: "status") as! Int)  != 200 {
                                if (dic.value(forKey: "status") as! Int)  == 503
                                {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else {
                                    completionError(response.error)
                                }
                            }
                            else{
                                guard let data = response.value else{return}
                                completionResponse(data as? [String : Any] ?? ["":""])
                            }
                        }
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
                }
        }
    }
    func deleteApi(url : String, completionResponse:  @escaping (String) -> Void,completionnilResponse:  @escaping (String) -> Void,completionError: @escaping (Error?) -> Void,networkError: @escaping (String) -> Void)
    {
        let urlComplete =  UrlStrings.BASE_URL + url
        print(urlComplete)
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        
        let headers    = [ "Content-Type" : "application/json","Authorization": "\(accessTokken)","Accept" : "application/json"]
        
        AlamofireManager.shared.request(urlComplete, method: .delete, parameters: nil, encoding: URLEncoding.default, headers : headers)
            .responseJSON { response in
                DispatchQueue.main.async {
                    if response.result.isSuccess
                    {
                        
                        if let dic = response.value as? NSDictionary {
                            if (dic.value(forKey: "status") as! Int)  != 200 {
                                completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                if (dic.value(forKey: "status") as! Int)  ==  204 || (dic.value(forKey: "status") as! Int)  ==  503 {
                                    completionnilResponse(dic.value(forKey: "message") as? String ?? "")
                                }
                                else {
                                    completionError(response.error)
                                }
                            }
                            else{
                                guard let data = response.value else{return}
                                print(data)
                                completionResponse(dic.value(forKey: "message") as? String ?? "")
                            }
                        }else{
                            completionnilResponse(Constants.Global.MessagesStrings.SomethingWentWrong)
                        }
                    }
                    else
                    {
                        completionError(response.error)
                        return
                    }
                }
        }
    }
    
    //Multipart API
    
    typealias RequestHandler = (_ error:Error?, _ url:String?, _ urlWatermark:String?)->(Void)
    
    func UploadDataWholePUT(url:URL?, param : [String : Any],completionHandler:@escaping RequestHandler,completionnilResponse:  @escaping ([String : Any]) -> Void,networkError: @escaping (String) -> Void){
        var checkMediaType:String?
        
        // MBProgressHUD.showAdded(to: KappDelegate.window, animated: true).labelText = KLoading
        var parameters = [String:Any]()
        parameters = param
        if let type = param["post_upload_type"] as? String{
            checkMediaType = type
        }
        //checkMediaType = param["post_upload_type"]
        print("your parameters : \(parameters)")
        let OrigiinalFileName = url?.lastPathComponent
        print(OrigiinalFileName ?? "")
        
        //        if (url?.absoluteString.contains("amazonaws"))!
        //        {
        //            completionHandler(nil,"\(url?.absoluteString ?? "")","")
        //            return
        //        }
        
        var accessTokken = ""
        if let str = UserDefaults.standard.value(forKey: "sessionToken")
        {
            accessTokken = "\(str)"
        }
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data","Authorization": "Bearer \(accessTokken)","Accept" : "application/json"
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 1200
        let alamoManager = Alamofire.SessionManager(configuration: configuration)
        
        print(parameters)
        alamoManager.upload(multipartFormData: { (multipartFormData) in
            
            
            for (key, value) in parameters {
                print(key)
                print(value)
                
                //                if key == "post_upload_type"{
                //
                //                    if let type = value as? String{
                //
                //                         checkMediaType = type
                //
                //                        let checkMediaType = "\(value)"
                //                        if(checkMediaType  == "AUDIO"){
                //                            multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".wav", mimeType: "audio/wave")
                //                        }else if(checkMediaType  == "VIDEO"){
                //                            multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".mp4", mimeType: "Video/mp4")
                //                        }else{
                //                            multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".jpg", mimeType: "Image/jpg")
                //                        }
                //
                //                    }
                
                if value is URL{
                    
                    if(checkMediaType  == "AUDIO"){
                        multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".wav", mimeType: "audio/wave")
                    }else if(checkMediaType  == "VIDEO"){
                        multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".mp4", mimeType: "Video/mp4")
                    }else{
                        multipartFormData.append(value as! URL, withName: "\(Double(Date.timeIntervalSinceReferenceDate * 1000))", fileName: "\(key)"+".jpg", mimeType: "Image/jpg")
                    }
                    
                }
                else
                {
                    
                    if let Item = value as? String
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    if let Item = value as? Int
                    {
                        print(Item)
                        multipartFormData.append("\(Item)".data(using: String.Encoding.utf8)!, withName: key as String)
                        
                    }
                }
            }
            
            
            
            //            for (key, value) in parameters {
            //                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            //            }
            //            let testImage = NSData(contentsOf: url! as URL)
            //print("Upload DataUrl: \(String(describing: url))")
            // print("Upload Data: \(String(describing: testImage))")
            
            //   multipartFormData.append(url!, withName: "media", fileName: randomFileName, mimeType: mimType)
            
        }, to: url!, method: .put, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    print(response)
                    
                    print(response.response?.statusCode ?? "")
                    print(response.request ?? "")  // original URL request
                    print(response.response ?? "") // URL response
                    print(response.data ?? "")     // server data
                    print(response.result)   // result of response serialization
                    print(response.result.value ?? "" )
                    if let error = response.error
                    {
                        
                        completionHandler(error,nil,nil)
                        print("Upload failed with error: (\(error))")
                        print("Upload failed with error: (\(error.localizedDescription))")
                    }
                    else
                    {
                        guard let data = response.value else{return}
                        let responseData  = data as! [String : Any]
                        let statusCode = responseData["code"] as! Int
                        print(statusCode)
                        if statusCode == 200
                        {
                            //MBProgressHUD.hide(for: KappDelegate.window, animated: true)
                            //                            let mediaUrl = responseData["media_original_url"] as! String
                            //                            let waterMark = responseData["media_preview_url"] as? String ?? ""
                            print("my response data for image : \(responseData)")
                            
                            let message = responseData["message"] as? String ?? ""
                            
                            //  print("Uploaded to:\(mediaUrl)")
                            completionHandler(nil,message,nil)
                            
                        }
                        else
                        {
                            completionnilResponse(responseData)
                        }
                    }
                    //  }
                    // onCompletion?(nil)
                    alamoManager.session.invalidateAndCancel()
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //MBProgressHUD.hide(for: KappDelegate.window, animated: true)
                completionHandler(error,nil,nil)
                //onError?(error)
            }
        }
    }
    
    
    
    func MultipartMultipleFilesServiceApi(type:DataType,fileData: [String],imageDataArr:[UIImage], requestDict : [String :Any]?, method: HTTPMethod, compBlock : @escaping completionBlock, failure : @escaping failureBlock) {
        
        let urlComplete =  UrlStrings.BASE_URL + UrlStrings.HappyMemories.uploadHappyMemories
        print("new api",urlComplete)
        var randomFileName = ""
        var mimType = ""
        var mediaType = ""
        var accessTokken = ""
        
        
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers  : HTTPHeaders  = ["Content-type": "application/x-www-form-urlencode","Authorization": "\(accessTokken)","Accept" : "application/json"]
        switch type {
        case .Video:
            mimType = "Video/mp4"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
            mediaType = "Video"
        case .Audio:
            mimType = "audio/wave"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).wav"
            mediaType = "Audio"
        case .Image:
            mimType = "Image/jpeg"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpeg"
            mediaType = "Image"
        case .none:
            mimType = ""
            randomFileName = ""
            mediaType = ""
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if(imageDataArr.count > 0)
            {
                for obj in imageDataArr
                {
                    let imageFile = obj
                    
                    if let imageData =  imageFile.jpegData(compressionQuality: 0.5)
                    {
                        multipartFormData.append(imageData, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
                    }
                }
                
            }
            if(!fileData.isEmpty)
            {
                
                for i in 0...fileData.count-1
                {
                    let mediaFile =  fileData[i]
                    multipartFormData.append(URL(string: mediaFile)!, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
                }
            }
            
            for (key, value) in requestDict ?? [:]
            {
                print(key)
                print(value)
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
           
        }, to: urlComplete, method: method, headers: headers, encodingCompletion: { (Result) in
            switch Result {
            case .success(let upload, _, _):
                upload.responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    //print(response.re)
                })
                upload.responseJSON(completionHandler: { response in
                    switch(response.result) {
                        
                    case .success(_):
                        
                        if response.result.value != nil
                        {
                            let statusCode = (response.response?.statusCode)!
                            print("...HTTP code: \(statusCode)")
                            var responseDict = [String: Any]()
                            
                            if let jsonDict = response.result.value as? [String: Any]
                            {
                                responseDict = jsonDict
                            }
                            //let message = responseDict["message"] as! String
                            print(responseDict)
                            compBlock(responseDict, response)
                        }
                        break
                    case .failure(_):
                        failure(response.result.error!)
                        break
                    }
                })
                break
            case .failure(let Result):
                print(Result.localizedDescription)
                failure(Result)
                break
            }
        })
        //}
    }
    
    
    
    
    
    func MultipartMultipleFilesServiceApi_with_url_array(type:DataType,fileData: [URL],imageDataArr:[UIImage], requestDict : [String :Any]?, method: HTTPMethod, compBlock : @escaping completionBlock, failure : @escaping failureBlock) {
        
        let urlComplete =  UrlStrings.BASE_URL + UrlStrings.HappyMemories.uploadHappyMemories
        print("new api",urlComplete)
        var randomFileName = ""
        var mimType = ""
        var mediaType = ""
        var accessTokken = ""
        
        
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers  : HTTPHeaders  = ["Content-type": "application/x-www-form-urlencode","Authorization": "\(accessTokken)","Accept" : "application/json"]
        switch type {
        case .Video:
            mimType = "Video/mp4"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
            mediaType = "Video"
        case .Audio:
            mimType = "audio/wave"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).wav"
            mediaType = "Audio"
        case .Image:
            mimType = "Image/jpeg"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpeg"
            mediaType = "Image"
        case .none:
            mimType = ""
            randomFileName = ""
            mediaType = ""
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if(imageDataArr.count > 0)
            {
                for obj in imageDataArr
                {
                    let imageFile = obj
                    
                    if let imageData =  imageFile.jpegData(compressionQuality: 0.5)
                    {
                        multipartFormData.append(imageData, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
                    }
                }
                
            }
            if(!fileData.isEmpty)
            {
                for i in 0...fileData.count-1
                {
                    let mediaFile =  fileData[i]
                    multipartFormData.append(mediaFile, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
                }
            }
            
            for (key, value) in requestDict ?? [:]
            {
                print(key)
                print(value)
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            
        }, to: urlComplete, method: method, headers: headers, encodingCompletion: { (Result) in
            switch Result {
            case .success(let upload, _, _):
                upload.responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    //print(response.re)
                })
                upload.responseJSON(completionHandler: { response in
                    switch(response.result) {
                        
                    case .success(_):
                        
                        if response.result.value != nil
                        {
                            let statusCode = (response.response?.statusCode)!
                            print("...HTTP code: \(statusCode)")
                            var responseDict = [String: Any]()
                            
                            if let jsonDict = response.result.value as? [String: Any]
                            {
                                responseDict = jsonDict
                            }
                            //let message = responseDict["message"] as! String
                            print(responseDict)
                            compBlock(responseDict, response)
                        }
                        break
                    case .failure(_):
                        failure(response.result.error!)
                        break
                    }
                })
                break
            case .failure(let Result):
                print(Result.localizedDescription)
                failure(Result)
                break
            }
        })
        //}
    }
    
    
    
    func MultipartServiceApi(type:DataType,urlMedia:URL?, urlString: String,fileData: UIImage?, requestDict : [String :Any]?, method: HTTPMethod, compBlock : @escaping completionBlock, failure : @escaping failureBlock) {
        
        let urlComplete =  UrlStrings.BASE_URL + urlString
        print("new api",urlComplete)
        var randomFileName = ""
        var mimType = ""
        var mediaType = ""
        var accessTokken = ""
        
        if let str = UserDefaults.standard.value(forKey: UserDefaultsKeys.accessTokken.rawValue)  as?  String
        {
            accessTokken = str
        }
        let headers  : HTTPHeaders  = ["Content-type": "application/x-www-form-urlencode","Authorization": "\(accessTokken)","Accept" : "application/json"]
        switch type {
        case .Video:
            mimType = "Video/mp4"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
            mediaType = "Video"
        case .Audio:
            mimType = "audio/wave"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).wav"
            mediaType = "Audio"
        case .Image:
            mimType = "Image/jpg"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            mediaType = "Image"
        case .none:
            mimType = ""
            randomFileName = ""
            mediaType = ""
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if(mediaType == "Image")
            {
                if let imageData =  fileData!.jpegData(compressionQuality: 0.5)
                {
                    multipartFormData.append(imageData, withName: "profile_image", fileName:randomFileName, mimeType: mimType)
                }
            }
            else if(mediaType == "Audio" || mediaType == "Video")
            {
                multipartFormData.append(urlMedia!, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
            }
            else
            {
                
            }
            
            for (key, value) in requestDict ?? [:]
            {
                print(key)
                print(value)
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            //                                for (key, value) in requestDict ?? [:] {
            //                                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            //                                }
        }, to: urlComplete, method: method, headers: headers, encodingCompletion: { (Result) in
            switch Result
            {
            case .success(let upload, _, _):
                upload.responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    //print(response.re)
                })
                upload.responseJSON(completionHandler: { response in
                    switch(response.result) {
                        
                    case .success(_):
                        
                        if response.result.value != nil
                        {
                            let statusCode = (response.response?.statusCode)!
                            
                            if statusCode != 200
                            {
                                if (statusCode == 401)
                                {
                                   //Reminder
                                    self.LOGOUT_VIEW()
                                }
                                else
                                {
                                  //
                                }
                            }
                            else
                            {
                                print("...HTTP code: \(statusCode)")
                                var responseDict = [String: Any]()
                                
                                if let jsonDict = response.result.value as? [String: Any]
                                {
                                    responseDict = jsonDict
                                }
                                //let message = responseDict["message"] as! String
                                print(responseDict)
                                compBlock(responseDict, response)
                            }
                            
                        }
                        break
                    case .failure(_):
                        failure(response.result.error!)
                        break
                    }
                })
                break
            case .failure(let Result):
                failure(Result)
                print(Result.localizedDescription)
                break
            }
        })
        //}
    }
    func MultipartServiceFacialApi(type:DataType, urlString: String,fileData: UIImage?, requestDict : [String :Any]?, method: HTTPMethod, compBlock : @escaping completionBlock, failure : @escaping failureBlock) {
        
        let urlComplete =  urlString
        var randomFileName = ""
        var mimType = ""
        var mediaType = ""
        
        
        let headers: HTTPHeaders = [
            "Content-type": "application/x-www-form-urlencode"
        ]
        switch type {
        case .Video:
            mimType = "Video/mp4"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp4"
            mediaType = "Video"
        case .Audio:
            mimType = "Audio/mp3"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).mp3"
            mediaType = "Audio"
        case .Image:
            mimType = "Image/jpg"
            randomFileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            mediaType = "Image"
        case .none:
            mimType = ""
            randomFileName = ""
            mediaType = ""
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if(mediaType == "Image"){
                if let imageData =  fileData!.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "file", fileName:randomFileName, mimeType: mimType)
                }
            }else if(mediaType == "Audio" || mediaType == "Video") {
                //multipartFormData.append(urlMedia!, withName: "post_upload_file", fileName:randomFileName, mimeType: mimType)
            }else{
                
            }
            
            for (key, value) in requestDict ?? [:] {
                print(key)
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            //                                for (key, value) in requestDict ?? [:] {
            //                                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            //                                }
        }, to: urlComplete, method: method, headers: headers, encodingCompletion: { (Result) in
            switch Result {
            case .success(let upload, _, _):
                upload.responseJSON(queue: DispatchQueue.main, options: JSONSerialization.ReadingOptions.allowFragments, completionHandler: { (response) in
                    print(response)
                })
                upload.responseJSON(completionHandler: { response in
                    switch(response.result) {
                        
                    case .success(_):
                        
                        if response.result.value != nil{
                            let statusCode = (response.response?.statusCode)!
                            print("...HTTP code: \(statusCode)")
                            var responseDict = [String: Any]()
                            
                            if let jsonDict = response.result.value as? [String: Any] {
                                responseDict = jsonDict
                            }
                            //let message = responseDict["message"] as! String
                            print(responseDict)
                            compBlock(responseDict, response)
                        }
                        break
                    case .failure(_):
                        failure(response.result.error!)
                        break
                    }
                    
                })
                break
            case .failure(let Result):
                print(Result.localizedDescription)
                break
            }
            
        })
        //}
    }
    
    
    
    func LOGOUT_VIEW()
    {
        CommonFunctions.sharedInstance.clearUserDefaults()
        
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "StartUpVCNav")
        
        Constants.Global.ConstantStrings.KappDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        Constants.Global.ConstantStrings.KappDelegate.window?.rootViewController = initialViewControlleripad
        Constants.Global.ConstantStrings.KappDelegate.window?.makeKeyAndVisible()
    }
    
}

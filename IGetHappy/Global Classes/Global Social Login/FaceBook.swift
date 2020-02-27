//
//  FaceBook.swift
//  E-Comm-FB-ogin
//
//  Created by Gagan on 5/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore


protocol FacebookDelegate : class {
    func Success(result:NSDictionary)
    func Failure(message:String)
}


class FaceBook {
    var Facebookdelagate :FacebookDelegate?
    var view:UIViewController
    
    init(viewController: UIViewController,delegate : FacebookDelegate) {
        Facebookdelagate = delegate
        view =  viewController
        
    }
    
    public func LoginIntoFacebook() {
        
        self.CallToFb()
    }
    
    
    private func CallToFb(){
        
        
        print("\(AccessToken.current)")
        
        if(AccessToken.current != nil) {
           
            removeFbData()
            
        } else {
            
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.loginBehavior = (LoginBehavior.browser)
            
            
            fbLoginManager.logIn(permissions: ["public_profile", "email", "user_friends"], from: view) { (result, error) in
                if (error != nil){
                    
                    self.Facebookdelagate?.Failure(message: "\(error!)")
                    //print("Error: \(error!)")
                }
                else if (result?.isCancelled)! {
                    self.Facebookdelagate?.Failure(message: "isCancelled")
                    // print("isCancelled")
                    //handle cancellation
                }
                else
                {
                    //print("Error: 1\(error)")
                    let fbloginresult : LoginManagerLoginResult = (result)!
                    
                    UserDefaults.standard.setAnonymous(value: "YES")
                    print("facebook data",fbloginresult)
                    
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        // print("FB 3")
                        self.returnUserData()
                    }
                    
                }
            }
        }
}
    private func removeFbData() {
       
        let fbManager = LoginManager()
        fbManager.logOut()
        AccessToken.current = nil
    }
    
    
    private func returnUserData()
    {
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, first_name, last_name, gender,name"])
        
        // let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,gender,name, email, picture.type(large)"])
        
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            
            let response = connection as AnyObject?
            //  print("error123456798\(error)")
            
            
            
            if (error != nil)
            {
                // Process error
                   print("Error: \(error?.localizedDescription)")
                self.Facebookdelagate?.Failure(message: "\(error?.localizedDescription ?? "")")
                
            }
            else
            {
                
                //  print("fetched user: \(result!) and ")
                let response = result as! NSDictionary
                let userId :NSString? = response.object(forKey:"id") as? NSString
                let fb_email:NSString? = response.object(forKey:"email") as? NSString
                let fb_firstName:NSString? = response.object(forKey:"first_name") as? NSString
                let fb_lastName:NSString? = response.object(forKey:"last_name") as? NSString
                let fb_name:NSString? = response.object(forKey:"name") as? NSString
                UserDefaults.standard.setUserId(value: userId! as String)
                UserDefaults.standard.setFirstName(value: fb_firstName! as String)
                UserDefaults.standard.setLastName(value: fb_lastName! as String)
                CompleteRegisterData.sharedInstance?.password = "Seasia@123"
               //UserDefaults.standard.setNickName(value: fb_name! as String)
                UserDefaults.standard.setEmail(value: fb_email! as String)
                self.Facebookdelagate?.Success(result: response)
                
                let fb_id:NSString? = response.object(forKey:"id") as? NSString
                
                let fbToken = "\(AccessToken.current!.tokenString)"
               
            }
           
        })
        
    }
   
   
}

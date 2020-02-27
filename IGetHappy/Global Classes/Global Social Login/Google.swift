//
//  Google.swift
//  E-Comm-FB-ogin
//
//  Created by Gagan on 5/10/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import GoogleSignIn
import GoogleToolboxForMac
protocol GoogleDelagate : class {
    func Success(result:String)
    func Fail(message:String)
}
class Google :NSObject{
    var Googledelagate :GoogleDelagate?
    
    var view:UIViewController
    
    init(viewController: UIViewController,delegate : GoogleDelagate) {
        Googledelagate = delegate
        view =  viewController
        
    }
    
    
    public func LoginIntoGoogle() {
        
        self.CallToGoogle()
    }
    
    private func CallToGoogle(){
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
}
extension Google:GIDSignInDelegate,GIDSignInUIDelegate{
    
   
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        view.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        view.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if(user != nil){
            GIDSignIn.sharedInstance()?.signOut()
        }
        
        if let error = error {
            Googledelagate?.Fail(message: error.localizedDescription)
            print("\(error.localizedDescription)")
        } else {
             let userId = user.userID
             let fullName = user.profile.name
            //UserDefaults.standard.setAnonymous(value: "YES")
            UserDefaults.standard.setUserId(value: userId)
            UserDefaults.standard.setFirstName(value: user.profile.givenName)
            UserDefaults.standard.setLastName(value: user.profile.familyName)
            //UserDefaults.standard.setNickName(value: user.profile.name)
            UserDefaults.standard.setEmail(value: user.profile.email)
            CompleteRegisterData.sharedInstance?.email = UserDefaults.standard.getEmail()
            CompleteRegisterData.sharedInstance?.password = "Seasia@123"
            Googledelagate?.Success(result: "\(fullName!)")
            // Perform any operations on signed in user here.
                          // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
           
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            // ...
        }
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                  withError error: Error!) {
            // Perform any operations when the user disconnects from app here.
            // ...
            print("Disconnect")
        }
    }
    
}

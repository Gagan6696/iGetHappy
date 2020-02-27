//
//  StartBeginVC.swift
//  IGetHappy
//
//  Created by Gagan on 7/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class StartBeginVC: BaseUIViewController {

    @IBOutlet weak var lbl_name: UILabel!
    var name:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        if(name == nil){
//        name  = "Arya"
//        }
        if let Name = UserDefaults.standard.getFirstName(){
            name = Name
        }
        if (name == "" || name == nil){
            let email = CompleteRegisterData.sharedInstance?.email
            if let subStringName = email?.components(separatedBy: CharacterSet(charactersIn: ("@0123456789"))).first {
                name = subStringName
            }
        }else{
            
            
        }
        let myString = "Hi ," + (name ?? "")
        let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
        // set attributed text on a UILabel
        lbl_name.attributedText = myAttrString
        
       // _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(StartBeginVC.begin), userInfo: nil, repeats: false)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
   override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
//    if(name == nil){
//        name  = "Arya"
//    }
//
    if let Name = UserDefaults.standard.getFirstName(){
        name = Name
    }
    if (name == "" || name == nil){
        let email = CompleteRegisterData.sharedInstance?.email
        if let subStringName = email?.components(separatedBy: CharacterSet(charactersIn: ("@0123456789"))).first {
            name = subStringName
        }
    }else{
        
        
    }
    let myString = "Hi ," + (name ?? "")
    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black]
    let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
    // set attributed text on a UILabel
    lbl_name.attributedText = myAttrString
    
    _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(StartBeginVC.begin), userInfo: nil, repeats: false)
    
    }
    
    @objc func begin()
    {
        print("Done calling")
        self.Continue((Any).self)
      
    }
    @IBAction func backActn(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func Continue(_ sender: Any) {
         dismissKeyboardBeforeAction()
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .UserProfileSetupVC, Data: nil)
    }
   
}

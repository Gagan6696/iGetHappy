//
//  MyProfileVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
let arrMenuItems = ["Mood Logs","Private Vents","Documents", "Appointments", "Reminders", "Care-Recievers"]
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblHappyTime: UILabel!
    @IBOutlet weak var lblVents: UILabel!
    @IBOutlet weak var lblMeditationSession: UILabel!
    
    @IBOutlet weak var tableViewOptions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

      self.lblUserName.text = UserDefaults.standard.getFirstName()
    }
    
    @IBAction func actionSetting(_ sender: Any) {
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
}
extension MyProfileVC :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewOptions.dequeueReusableCell(withIdentifier: MyProfileTableViewCell.className, for: indexPath) as! MyProfileTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblMenuItems.text = arrMenuItems[indexPath.row]
     //   cell.imgViewArrow.image = UIImage.init(named: "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ( indexPath.row == 0) {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MoodLogAndStatBase, Data: nil)
        }else if(indexPath.row == 4){
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReminderVC, Data: nil)
            
        }else if(indexPath.row == 5){
            
                 CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AllCareReceiverList, Data: nil)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        }
    }
    
}

//
//  MyProfileVC.swift
//  IGetHappy
//
//  Created by Gagan on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

protocol MyProfileViewDelegate:class {
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class MyProfileVC: BaseUIViewController
{
let arrMenuItems = ["Mood Logs","Private Vents","Documents", "Appointments", "Reminders", "Care-Recievers"]
    var presenter:MyProfilePresenter?
    var myProfileData :MyProfileMapper?
    
    @IBOutlet weak var lblJoinDate: UILabel!
    @IBOutlet weak var lblHappyTime: UILabel!
    
    @IBOutlet weak var lblMeditationSession: UILabel!
    
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var lblVents: UILabel!
    @IBOutlet weak var tableViewOptions: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = MyProfilePresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        getMyProfile()
      self.lblUserName.text = UserDefaults.standard.getFirstName()
    }
    @IBAction func actionSetting(_ sender: Any) {
        self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    private func getMyProfile(){
        if self.checkInternetConnection(){
            self.presenter?.getMyProfile()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if ( indexPath.row == 0)
        {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MoodLogAndStatBase, Data: nil)
        }
        else if (indexPath.row == 1)
        {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: MyVentsTabVC.className)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if(indexPath.row == 4)
        {
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .ReminderVC, Data: nil)
            
        }
        else if(indexPath.row == 5)
        {
            
            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AllCareReceiverList, Data: nil)
        }
        else
        {
            self.view.makeToast(Constants.Global.MessagesStrings.ComingSoon)
        }
    }
    
}
extension MyProfileVC:MyProfileDelegate
{
    func MyProfileDidSucceeed(data: MyProfileMapper?)
    {
        self.hideLoader()
        myProfileData = data
        lblHappyTime.text =  myProfileData?.data?.happyTimesCount
        lblVents.text = myProfileData?.data?.ventsCount
        lblMeditationSession.text = myProfileData?.data?.meditationSessionCount
        let date   = self.dateFromISOString(string: myProfileData?.data?.created_at ?? "")
//        let date  = self.convertIsoStringToDate(isoDate: myProfileData?.data?.created_at ?? "")
       // let localTimeZone = date.toLocalTime()
        lblJoinDate.text = "in IgetHappy Since" + " \(date!)"
    }
    
    func MyProfileDidFailed(message:String?)
    {
        self.hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension MyProfileVC:MyProfileViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader()
    {
        ShowLoaderCommon()
    }
    
    func hideLoader()
    {
        HideLoaderCommon()
    }
    
    
}

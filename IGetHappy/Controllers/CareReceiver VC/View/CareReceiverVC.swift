//
//  CareReceiverVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
protocol CareReceiverViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}
class CareReceiverVC: BaseUIViewController
{
    //MARK: OUTLETS
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var btnAddNewCare: PSCustomButton!
    var presenter:CareReceiverPresenter?
    var CareRecieverData:CareReceiverMapper?
    //MARK: VARIABLES
    let cellID = "CellClass_CareReceiverVC"
    let greenColor = UIColor(red: 39/255.0, green: 174/255.0, blue: 96/255.0, alpha: 1.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter = CareReceiverPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        getCareRecieverListWithStatus()
        self.btnAddNewCare.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getCareRecieverListWithStatus()
    }
    private func getCareRecieverListWithStatus(){
        if self.checkInternetConnection(){
            self.presenter?.getCareRecieverListWithStatus()
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .Home, Data: nil)
        }else{
            self.view.makeToast(Constants.Global.MessagesStrings.NoConnection)
        }
    }

    @IBAction func ACTION_DISMISS_VIEW(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func ACTION_ADD_NEW_CARE(_ sender: Any)
    {
        //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .CareReciverTabs, Data: nil)
        
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .AddCareReciever, Data: nil)
    }

}

extension CareReceiverVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CareRecieverData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_CareReceiverVC
        let status = CareRecieverData?.data?[indexPath.row].status
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lblName.text = CareRecieverData?.data?[indexPath.row].first_name
        cell.lblDesc.text = CareRecieverData?.data?[indexPath.row].relationship
        let url = URL(string:  (CareRecieverData?.data?[indexPath.row].profile_image ?? ""))
        cell.ivUser.kf.indicatorType = .activity
        
        cell.ivUser.layer.cornerRadius = 25
        
        cell.ivUser.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        if (status == "ACCEPTED")
        {
           cell.lblStatus.text = "Approved"
           cell.lblStatus.textColor = greenColor
        }
        if (status == "PENDING")
        {
            cell.lblStatus.text = "Waiting for approval"
            cell.lblStatus.textColor = UIColor.orange
        }
        if (status == "REJECTED")
        {
            cell.lblStatus.text = "Rejected"
            cell.lblStatus.textColor = UIColor.red
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .CareReciverTabs, Data: CareRecieverData?.data?[indexPath.row])
   
    }
}
extension CareReceiverVC:CareReceiverDelegate{
    func CareReceiverDidSucceeed(data: CareReceiverMapper) {
        self.hideLoader()
        self.CareRecieverData = data
        self.myTableView.reloadData()
    }
    
    
//    func CareReceiverDidSucceeed(data: ChooseCareRecieverMapper) {
//        self.hideLoader()
//        self.CareRecieverData = data
//        self.myTableView.reloadData()
//    }

    func CareReceiverDidFailed(message:String?) {
        self.hideLoader()
        self.showAlert(Message: message ?? "")
    }
}

extension CareReceiverVC:CareReceiverViewDelegate
{
    
    func showAlert(alertMessage: String) {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

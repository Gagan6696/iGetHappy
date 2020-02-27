//
//  MyAllVentsTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol AllVentsViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    func getSharedPostList()
}

class MyAllVentsTabVC: UIViewController
{

    //MARK: <-OUTLETS ->
    @IBOutlet weak var myTableView: UITableView!
    
    
    //MARK: <- VARIABLES->
    let cellID = "CellClass_MyVentsTab"
    let cellIDPrivate = "CellClassMyVentsPrivate"
    let cellIDAudio = "CellClass_MyVentsPlayer"
    let cellIDFeeling = "CellClassMyVentsFeeling"
    
    var presenter:AllVentsPresenter?
    var apiDATA = [AllVentsModel]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        myTableView.rowHeight = UITableView.automaticDimension
        myTableView.estimatedRowHeight = 200
        self.presenter = AllVentsPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        presenter?.CALL_API_GET_SHARED_POSTS()
    }
    

    

}

extension MyAllVentsTabVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
     //   return apiDATA.count
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
      //  let obj = apiDATA[indexPath.row]
        
        if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 6 || indexPath.row == 8)
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDPrivate) as! CellClassMyVentsPrivate
            cell = myCell
        }
        
        else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9)
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDAudio) as! CellClass_MyVentsPlayer
            cell = myCell
        }
        
        else if (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 14)
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_MyVentsTab
            cell = myCell
        }
        else
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDFeeling) as! CellClassMyVentsFeeling
            cell = myCell
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 200.0
//    }
}


extension MyAllVentsTabVC:AllVentsViewDelegate
{
    func showAlert(alertMessage: String)
    {
        CommonVc.AllFunctions.showAlert(message: alertMessage, view: self, title: Constants.Global.ConstantStrings.KAppname)
    }
    
    func showLoader()
    {
       MBProgressHUD.showAdded(to: view, animated: true).detailsLabel.text = "Loading..."
    }
    
    func hideLoader()
    {
       MBProgressHUD.hide(for: view, animated: true)
    }
    
    func getSharedPostList()
    {
       self.myTableView.reloadData()
    }
    
}
extension MyAllVentsTabVC:AllVentsDelegate
{
    func AllVentsDidSucceeed(eventModel: [AllVentsModel])
    {
        self.myTableView.reloadData()
    }
    
    func AllVentsDidFailed(message: String?)
    {
        print(message)
    }
    
    
}

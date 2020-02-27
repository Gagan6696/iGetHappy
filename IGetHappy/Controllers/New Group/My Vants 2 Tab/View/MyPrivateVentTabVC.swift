//
//  MyPrivateVentTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

protocol PrivateVentsViewDelegate:class
{
    func configureData(arr:[AllVentsModel])
    func filterArray(searchText:String)
    func search_dismiss()
}


class MyPrivateVentTabVC: UIViewController
{
    
    //MARK: <-OUTLETS ->
    @IBOutlet weak var myTableView: UITableView!
    
    
    //MARK: <- VARIABLES->
   // let cellID = "CellClass_MyPrivateVentsTab"
    
    let cellID = "CellClass_MyVentsTab"
    let cellIDPrivate = "CellClassMyVentsPrivate"
    let cellIDAudio = "CellClass_MyVentsPlayer"
    let cellIDFeeling = "CellClassMyVentsFeeling"
    
    var apiDATA_filter:[AllVentsModelDetail] = []
    var apiDATA_private:[AllVentsModelDetail] = []
    var searchActivePrivate = false
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        MyVentsTabVC.refNewPrivate = self
    }
    

    func configureData(arr:[AllVentsModelDetail])
    {
        for obj in arr
        {
            if (obj.privacy_option == "Only Me")
            {
               apiDATA_private.append(obj)
            }
        }
        
        self.myTableView.reloadData()
    }
    

}

extension MyPrivateVentTabVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (searchActivePrivate == true)
        {
           return apiDATA_filter.count
        }
        return apiDATA_private.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       // let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_MyPrivateVentsTab
       // cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        var cell = UITableViewCell()
        var obj = apiDATA_private[indexPath.row]
        
        if (searchActivePrivate == true)
        {
            obj = apiDATA_filter[indexPath.row]
        }
        else
        {
            obj = apiDATA_private[indexPath.row]
        }
        
        
        
        
        if (obj.privacy_option == "Only Me")
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDPrivate) as! CellClassMyVentsPrivate
            myCell.lblDesc.text = obj.desc
            myCell.lblUserName.text = "John Snow"
            myCell.lblTime.text = obj.created_at
            myCell.lblPrivacy.text = obj.privacy_option
            myCell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            cell = myCell
        }
            
            //        else if (indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 7 || indexPath.row == 9)
            //        {
            //            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDAudio) as! CellClass_MyVentsPlayer
            //
            //            myCell.lblName.text = userName
            //            myCell.lblTime.text = obj.created_at
            //            myCell.lblPrivacy.text = obj.privacy_option
            //            myCell.lblFeeling.text = obj.moodTrack
            //            myCell.lblDesc.text = obj.description
            //
            //            cell = myCell
            //        }
            
            //        else if (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13 || indexPath.row == 14)
            //        {
            //            let myCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_MyVentsTab
            //
            //
            //
            //            cell = myCell
            //        }
        else
        {
            let myCell = tableView.dequeueReusableCell(withIdentifier: cellIDFeeling) as! CellClassMyVentsVideoCell
            myCell.selectionStyle = UITableViewCell.SelectionStyle.none
            
            myCell.lblName.text = "john"
            myCell.lblTime.text = obj.created_at
            myCell.lblPrivacy.text = obj.privacy_option
           // myCell.lblFeeling.text = obj.moodTrack
            myCell.lblDesc.text = obj.desc
            
            cell = myCell
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 160.0
//    }
    
    
    func filterArray(searchText:String)
    {
        searchActivePrivate = true
        self.apiDATA_filter.removeAll()
        
        if (self.apiDATA_private.count > 0)
        {
            for obj in self.apiDATA_private
            {
                let str = obj.user_name ?? ""
                
                if let _ = str.range(of: searchText, options: .caseInsensitive)
                {
                    self.apiDATA_filter.append(obj)
                }
            }
            
            self.myTableView.reloadData()
        }
    }
    
    func search_dismiss()
    {
        searchActivePrivate = false
        self.apiDATA_filter.removeAll()
        self.myTableView.reloadData()
    }
    
    
}



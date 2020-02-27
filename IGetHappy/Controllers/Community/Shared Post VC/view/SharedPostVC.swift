//
//  SharedPostVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/1/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class SharedPostVC: UIViewController
{

    //MARK: OUTLETS
    @IBOutlet weak var myTableView: UITableView!
    
    
    //MARK: VARIABLES
    let cellID = "CellClass_SharePostVC"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    

    //MARK: BUTTON ACTIONS
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func ACTION_SEARCH(_ sender: Any)
    {
        
    }
    @IBAction func ACTION_FILTER(_ sender: Any)
    {
        
    }
    @IBAction func ACTION_SWIPE(_ sender: Any)
    {
        
    }
    @IBAction func ACTION_ADD(_ sender: Any)
    {
        
    }
    @IBAction func ACTION_MESSAGES(_ sender: Any)
    {
        
    }
   

}

extension SharedPostVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int
//    {
//        return 1
//    }
    
    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
//    {
//       return  40.0
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_SharePostVC
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 500.0
    }
}


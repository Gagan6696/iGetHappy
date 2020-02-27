//
//  MyPrivateVentTabVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MyPrivateVentTabVC: UIViewController
{
    
    //MARK: <-OUTLETS ->
    @IBOutlet weak var myTableView: UITableView!
    
    
    //MARK: <- VARIABLES->
    let cellID = "CellClass_MyPrivateVentsTab"
    

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    

    

}

extension MyPrivateVentTabVC : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! CellClass_MyPrivateVentsTab
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160.0
    }
}

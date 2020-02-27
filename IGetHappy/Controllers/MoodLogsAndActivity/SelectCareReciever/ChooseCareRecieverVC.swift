//
//  ChooseCareRecieverVC.swift
//  IGetHappy
//
//  Created by Gagan on 10/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.

import UIKit

class ChooseCareRecieverVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actnAddCareReceiver(_ sender: Any) {
        
        
    }
    @IBAction func dropdown(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseCareRecieverVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseCareRecieverCell", for: indexPath) as! ChooseCareRecieverCell
        cell.lblProfileName.text = "profile Name"
        cell.lblRelationShip.text = "Me"
        if(selectedIndex == indexPath.row){
            cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityChecked"), for: .normal)
        }else{
            cell.btnSelectCareReciever.imageView?.image = nil
             //cell.btnSelectCareReciever.setImage(UIImage.init(named: "ActivityCheck"), for: .normal)
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
    
}

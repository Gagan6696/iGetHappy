//
//  CommunityFeedVC.swift
//  IGetHappy
//
//  Created by Gagan on 5/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
//import Reactions
class CommunityFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        //tableView.estimatedRowHeight = 44.0
//        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CommunityFeedVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTVC", for: indexPath) as! FeedTVC
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
        
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       return UITableView.automaticDimension
    }
    
}

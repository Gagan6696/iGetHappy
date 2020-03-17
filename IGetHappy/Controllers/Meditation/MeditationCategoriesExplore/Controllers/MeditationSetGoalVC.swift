//
//  MeditationSetGoalVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/25/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MeditationSetGoalVC: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var btnSkip: UIButton!
    var selectedCell = Int()
    var array  = ["3 Days","7 Days","14 Days","1 Month","3 Months","6 Months"," 1 Year"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        btnSkip.roundCorners(.allCorners, radius: 10.0)
        // Do any additional setup after loading the view.
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
        if let vc = self.navigationController?.getPreviousViewController() {
            if vc is RemindersVC{
                self.btnSkip.isHidden = true
            }
        }
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
//        if (sender.direction == .left)
//        {
//            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationHowItWorks, Data: nil)
//            
//        }
//        
//        if (sender.direction == .right)
//        {
//            CommonFunctions.sharedInstance.popTocontroller(from: self)
//        }
    }
    
    @IBAction func actionBtnSkip(_ sender: Any)
    {
       // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationExploree, Data: nil)
        MeditationExplore.refrncPagerParent.skip()
    }
    @IBAction func actionBack(_ sender: Any) {
         MeditationExplore.refrncPagerParent.moveback(self)
        //CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func actionNext(_ sender: Any)
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationHowItWorks, Data: nil)
    }
    
}
extension MeditationSetGoalVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = self.tableView.dequeueReusableCell(withIdentifier: "MeditationSetGoalCell", for: indexPath) as! MeditationSetGoalCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.lbl.text = array[indexPath.row]
        if(selectedCell == indexPath.row)
        {
            cell.lbl.textColor = UIColor.init(hex: 0x33BEE0)
        }
        else
        {
            cell.lbl.textColor = .black
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell =  self.tableView.cellForRow(at: indexPath) as! MeditationSetGoalCell
        
        if(indexPath.row != selectedCell)
        {
            cell.lbl.text = array[indexPath.row]
            //cell.lbl.textColor = .blue
            selectedCell = indexPath.row
            Singleton.shared().setGoalDays = cell.lbl.text ?? "3 Days"
            Singleton.shared().totalDays = CommonVc.AllFunctions.return_days_from_selection_of_time(hint: cell.lbl.text ?? "3 Days")
        }
        
        self.tableView.reloadData()
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60.0
    }
    
    
    
}

//
//  MeditationExplore.swift
//  IGetHappy
//
//  Created by Gagan on 9/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MeditationExplore: BaseUIViewController {
    
    @IBOutlet weak var btnBegin: UIButton!
    static var refrncPagerParent = MeditationPagerVC()
    
    @IBAction func txtFld(_ sender: Any) {
    }
    var cell: UITableViewCell!
    var categories = ["Live Now", "Recommended for you", "Meditate"]
    override func viewDidLoad() {
        self.btnBegin.layer.cornerRadius = 20
    }
    
    @IBAction func actionBack(_ sender: Any)
    {
       CommonFunctions.sharedInstance.popTocontroller(from: self)
        
       // MeditationExplore.refrncPagerParent.didTapGoToLeft()
        
    }
    @IBAction func actionBegin(_ sender: Any)
    {
        //self.showToast(message: Constants.Global.MessagesStrings.ComingSoon)
        
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .BreatheInhaleExhaleViewController, Data: nil)
       // BreatheInhaleExhaleVCNavIDz
        
        
//        let breatheInhaleExhale = UIStoryboard.init(name: "Meditation", bundle: nil).instantiateViewController(withIdentifier: BreatheInhaleExhaleViewController.className) as? BreatheInhaleExhaleViewController
//        let nav = UINavigationController(rootViewController: breatheInhaleExhale!)
//        self.present(nav, animated: true, completion: nil)
        
        
    }
    
}

extension MeditationExplore : UITableViewDelegate { }

extension MeditationExplore : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var sectionNumber = indexPath.section
        if (sectionNumber == 2){
            return 500
        }else{
            return 120
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sectionNumber = indexPath.section
        print(sectionNumber)
        if (sectionNumber == 0){
            
            cell = tableView.dequeueReusableCell(withIdentifier: "LiveSessionTableViewCell") as! LiveSessionTableViewCell
        }else if (sectionNumber == 2){
            cell = tableView.dequeueReusableCell(withIdentifier: "MeditateCatTableViewCell") as! MeditateCatTableViewCell
            cell.imageView?.backgroundColor = UIColor.blue
            
        }else if (sectionNumber == 1){
            cell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCell") as! RecommendTableViewCell
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
}

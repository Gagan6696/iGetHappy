//
//  MeditationWecomeVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/25/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class MeditationWecomeVC: UIViewController {
    var selectedIndex = [Int]()
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    let array  = ["+ Happy","+ Sleep","+ Healthy","+ Present","+ Focused","+ Calm","+ Stressed","+ Anxious"]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 30
            layout.minimumInteritemSpacing = 5
            // layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        btnSkip.roundCorners(.allCorners, radius: 10.0)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        self.view.addGestureRecognizer(leftSwipe)
        self.view.addGestureRecognizer(rightSwipe)
    
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
//        if (sender.direction == .left)
//        {
//            CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationSetGoal, Data: nil)
//
//        }
//
//        if (sender.direction == .right)
//        {
//            CommonFunctions.sharedInstance.popTocontroller(from: self)
//        }
    }
    
    @IBAction func actionBack(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func actionBtnSkip(_ sender: Any)
    {
       // CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationExploree, Data: nil)
        
        MeditationExplore.refrncPagerParent.skip()
    }
    @IBAction func actionNext(_ sender: Any)
    {
        CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .MeditationSetGoal, Data: nil)
    }
    
}
extension MeditationWecomeVC :UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = self.collectionView.dequeueReusableCell(withReuseIdentifier: "MeditaionWelcomeCell", for: indexPath) as! MeditaionWelcomeCell
        cell.imageView.layer.cornerRadius = cell.frame.height/2
        cell.contentView.layer.cornerRadius = cell.frame.height/2
        cell.lblTitle.text = array[indexPath.row]
        
        if(selectedIndex.contains(indexPath.row)){
            cell.imageView.backgroundColor = UIColor.blue
            cell.imageView.layer.borderColor = UIColor.white.cgColor
            cell.imageView.image = UIImage.init(named: "globalBackground")
        }else{
            cell.imageView.layer.borderColor = UIColor.black.cgColor
            cell.imageView.layer.borderWidth = 1
            cell.imageView.backgroundColor = UIColor.white
            cell.imageView.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!selectedIndex.contains(indexPath.row)){
            selectedIndex.append(indexPath.row)
            //selectedIndex = indexPath.row
            collectionView.reloadData()
            
        }else{
             selectedIndex.remove(at: selectedIndex.firstIndex(of: indexPath.row)!)
            collectionView.reloadData()
        }
        
    }
    
}
extension MeditationWecomeVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width/2 - 10, height: 40)
    }
}

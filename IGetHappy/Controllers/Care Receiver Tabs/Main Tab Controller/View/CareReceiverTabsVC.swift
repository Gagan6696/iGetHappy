//
//  CareReceiverTabsVC.swift
//  IGetHappy
//
//  Created by Mohit Sharma on 11/4/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class CareReceiverTabsVC: BaseUIViewController
{
    
    //MARK: <-OUTLETS ->
    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var btnAbout: UIButton!
    @IBOutlet weak var btnMood: UIButton!
    @IBOutlet weak var iv_underLine_About: UIImageView!
    @IBOutlet weak var iv_underLine_MoodReport: UIImageView!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblCareRecieverName: UILabel!
    
    @IBOutlet weak var lblRelationShip: UILabel!
    
    //MARK: <- VARIABLES->
    var aboutTabVC = AboutTabVC()
    var moodReportVC = MoodReportTabVC()
    var dataCareReciever:CareReceiverDetail?
    var currentController = UIViewController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string:  (dataCareReciever?.profile_image ?? ""))
        self.imgView.kf.indicatorType = .activity
        self.imgView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "community_listing_user"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        self.imgView.layer.cornerRadius = 30
       //self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2
        self.lblRelationShip.text = dataCareReciever?.relationship
        self.lblCareRecieverName.text  = dataCareReciever?.first_name
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.imgView.layer.cornerRadius = 30
        //self.imgView.setRounded()
        self.AboutSelected()
    }
    
    
    //MARK: <-BUTTON ACTIONS ->
    @IBAction func ACTION_MOVE_BACK(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func ACTION_ABOUT_SELECTED(_ sender: Any)
    {
        self.AboutSelected()
    }
    
    @IBAction func openCamera(_ sender: Any) {
        self.addImageOptions()
        
    }
    
    @IBAction func ACTION_MOODREPORT_SELECTED(_ sender: Any)
    {
        self.MoodReportSelected()
    }
    
    
    
    
    //MARK: <-HANDLING OF SELECTED TABS AND CHILD VIEW CONTROLLERS ->
    private var activeViewController: UIViewController?
    {
        didSet
        {
            removeInactiveViewController(inactiveViewController: oldValue)
            updateActiveViewController()
        }
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?)
    {
        if let inActiveVC = inactiveViewController
        {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMove(toParent: nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParent()
        }
    }
    
    private func updateActiveViewController()
    {
        
        let mapViewController = self.currentController
        mapViewController.willMove(toParent: self)
        
        mapViewController.view.frame.size.width = self.myContainerView.frame.size.width
        mapViewController.view.frame.size.height = self.myContainerView.frame.size.height
        // Add to containerview
        self.myContainerView.addSubview(mapViewController.view)
        self.addChild(mapViewController)
        mapViewController.didMove(toParent: self)
    }
    
   
    func AboutSelected()
    {
        self.btnAbout.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        self.btnMood.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        
        self.iv_underLine_About.isHidden = false
        self.iv_underLine_MoodReport.isHidden = true
        
        
         let selected = self.storyboard?.instantiateViewController(withIdentifier: "AboutTabVC") as? AboutTabVC
        
        selected?.selectedCareRecieverData = dataCareReciever
        self.currentController = selected ?? (self.storyboard?.instantiateViewController(withIdentifier: "AboutTabVC") as? AboutTabVC)!

        ///currentController.selectedCareRecieverData
        self.activeViewController = selected
    }
    
    func MoodReportSelected()
    {
        self.btnAbout.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        self.btnMood.setTitleColor(UIColor.darkGray, for: UIControl.State.normal)
        
        self.iv_underLine_About.isHidden = true
        self.iv_underLine_MoodReport.isHidden = false
        
        let story = UIStoryboard.init(name: "SideBarOptions", bundle: nil)
        let selected = story.instantiateViewController(withIdentifier: "MoodStatisticsVC") as? MoodStatisticsVC
        
        selected?.isFromCareReciversTab = true
        selected?.showDataCareReciverId = dataCareReciever?._id ?? ""
        
        self.currentController = selected ?? (self.storyboard?.instantiateViewController(withIdentifier: "MoodStatisticsVC") as? MoodStatisticsVC)!
        self.activeViewController = selected
    }
    
}
extension CareReceiverTabsVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // choose a name for your image
            let fileName = "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            if let data = pickedImage.jpegData(compressionQuality: 1.0),
                !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    self.imgView.layer.cornerRadius = 30
                    self.imgView.image = pickedImage
                    AboutTabVC.careReciverProfileImage = pickedImage
                    //print("file saved")
                } catch {
                    //print("error saving file:", error)
                }
            }
        }else{
            
        }
        dismiss(animated: true)
    }
}

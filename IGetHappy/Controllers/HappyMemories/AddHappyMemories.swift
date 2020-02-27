//
//  AddHappyMemories.swift
//  IGetHappy
//
//  Created by Gagan on 8/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import CircleMenu
import MediaPlayer


extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor
    {
        return UIColor(
            red: 1.0 / 255.0 * CGFloat(red),
            green: 1.0 / 255.0 * CGFloat(green),
            blue: 1.0 / 255.0 * CGFloat(blue),
            alpha: CGFloat(alpha))
    }
}
class AddHappyMemories: UIViewController
{
    

    @IBOutlet weak var swipeUpArea: UIView!
    @IBOutlet weak var btnCircleMenu: CircleMenu!
    
    let items: [(icon: String, color: UIColor, name: String)] = [
        ("icon_audioMic", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1),"Record"),
        ("icon_gallery", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1),"Image"),
        ("icon_videoCamera", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1),"Video"),
        ("icon_music", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1),"Music")
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) {
            self.btnCircleMenu.onTap()
        }
        btnCircleMenu.delegate  = self
        
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeUpArea.addGestureRecognizer(viewTapGesture)
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        
        leftSwipe.direction = .up
        swipeUpArea.addGestureRecognizer(leftSwipe)
        
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer)
    {
        if (sender.direction == .up)
        {
            print("Swipe Left")
            guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: "NavigationGallery") as? NavigationGallery else { return }
            
            popupNavController.shouldDismissInteractivelty = true
            self.present(popupNavController, animated: true, completion: nil)
        }
    }
    
    
    @objc private func dismissKeyboard()
    {
        view.endEditing(true)
    }
    // Do any additional setup after loading the view.
    
    //    @IBAction func btnShow(_ sender: Any) {
    //        guard let popupNavController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
    //        popupNavController.view.backgroundColor = .clear
    //        popupNavController.modalPresentationStyle = .overCurrentContext
    //        self.present(popupNavController, animated: true, completion: nil)
    //
    //    }
    
    
    
    
    
}
extension AddHappyMemories: CircleMenuDelegate
{
    
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = .clear
        
        
        //        button.setTitle(items[atIndex].name, for: .normal)
        //        button.setTitleColor(UIColor.lightGray, for: .normal)
        //        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        //        button.contentVerticalAlignment = .bottom
        //        button.contentHorizontalAlignment = .center
        //        button.titleEdgeInsets = UIEdgeInsets(top: 190.0, left: -150.0, bottom: -20.0, right: -85.0)
        
        
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
    }
    
    func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    func menuHide()
    {
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(name: Notification.Name("refreshArray"), object: nil)
        })
        print("menuHide")
        
    }
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        
        print("button did selected: \(atIndex)")
        
        if(atIndex == 0)
        {
            let vc = UIStoryboard.init(name: "HappyMemories", bundle: Bundle.main).instantiateViewController(withIdentifier: "RecordAudioMemories") as? RecordAudioMemoriesVC
            var controlers = self.navigationController?.viewControllers
            let vcRecordAudio = UIStoryboard.init(name: "Auth", bundle: Bundle.main).instantiateViewController(withIdentifier: RecordAudioVC.className) as? RecordAudioVC
            controlers?.append(vc!)
            self.navigationController?.viewControllers = controlers!
            vcRecordAudio?.delegatePassUrl = vc
            Constants.isFromHappyMemories = true
            
            navigationController?.pushViewController(vcRecordAudio!, animated: true)
            
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .UploadMemoriesMultipleRecordedAudio, Data: nil)
            
            
        }
        else if(atIndex == 3)
        {
            let vc = UIStoryboard.init(name: "HappyMemories", bundle: Bundle.main).instantiateViewController(withIdentifier: SelectMusicVC.className) as? SelectMusicVC
            var controlers = self.navigationController?.viewControllers
            let picker = MPMediaPickerController(mediaTypes:.music)
            
            present(picker, animated: true) {
                picker.delegate = vc
                picker.showsCloudItems = false
                picker.allowsPickingMultipleItems = true
                picker.modalPresentationStyle = .fullScreen
                picker.preferredContentSize = CGSize(500,600)
                controlers?.append(vc!)
                self.navigationController?.viewControllers = controlers!
                
                //self.navigationController?.pushViewController(vc!, animated: true)
            }
            
            // vc!.navigationController?.pushViewController(picker, animated: true)
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .UploadMemoriesSelectMusic, Data: nil)
        }
        else if (atIndex == 2)
        {
            
            
//            let vc = UIStoryboard.init(name: "HappyMemories", bundle: Bundle.main).instantiateViewController(withIdentifier: SelectVideoMemoriesVC.className) as? SelectVideoMemoriesVC
//            var controlers = self.navigationController?.viewControllers
//
//
//            var config = TatsiConfig.default
//            config.showCameraOption = true
//            config.supportedMediaTypes = [.video]
//            config.firstView = .userLibrary
//            config.maxNumberOfSelections = 5
//
//            let pickerViewController = TatsiPickerViewController(config: config)
//
//            present(pickerViewController, animated: true) {
//                pickerViewController.pickerDelegate = vc
//                controlers?.append(vc!)
//                self.navigationController?.viewControllers = controlers!
//            }
            
            
            let vc = UIStoryboard.init(name: "HappyMemories", bundle: Bundle.main).instantiateViewController(withIdentifier: SelectVideoMemoriesVC.className) as? SelectVideoMemoriesVC
            var controlers = self.navigationController?.viewControllers
            
            
            let imagePick = UIImagePickerController()
            
            // Access has been granted.
            imagePick.allowsEditing = true
            imagePick.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePick.mediaTypes = ["public.movie"]
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            imagePick.navigationBar.tintColor = UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            imagePick.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            ]
            
            imagePick.videoMaximumDuration = 30.0
            imagePick.delegate = vc
            
            present(imagePick, animated: true)
            {
                //imagePick = vc
                controlers?.append(vc!)
                self.navigationController?.viewControllers = controlers!
            }
            
        }
        else
        {
            let vc = UIStoryboard.init(name: "HappyMemories", bundle: Bundle.main).instantiateViewController(withIdentifier: AddPhotosMemories.className) as? AddPhotosMemories
            self.navigationController?.pushViewController(vc!, animated: false)
            //CommonFunctions.sharedInstance.PushToContrller(from: self, ToController: .UploadMemoriesMultiplePhotos, Data: nil)
        }

    }
}


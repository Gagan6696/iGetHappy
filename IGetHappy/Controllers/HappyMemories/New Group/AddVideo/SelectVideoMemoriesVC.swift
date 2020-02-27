//
//  SelectVideoMemoriesVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/26/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import Photos
import AVKit
import CoreLocation

class SelectVideoMemoriesVC: BaseUIViewController,UITextFieldDelegate
{
    
    @IBOutlet weak var tfDesc: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: HappyMemoriesCommonPresenter?
 //   var arrVideos = [PHAsset]()
    var arrUploads = [String]()
    var arrNew = [URL]()
    var selectedIndex = Int()
    let playerViewController = AVPlayerViewController()
    
    var oldFiles = Bool()
   // var config = TatsiConfig.default
    
    static var imagePick = UIImagePickerController()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.presenter = HappyMemoriesCommonPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // getCurrentLatLon(vc: self, obj: location)
        
        let location = UserDefaults.standard.getLocation() ?? ""
        self.btnLocation.setTitle(location, for: .normal)
        
//        config.showCameraOption = true
//        config.supportedMediaTypes = [.video]
//        config.firstView = .userLibrary
//        config.maxNumberOfSelections = 1
        
        self.get_video_arr_for_upload()
        
       // openGallery(self)
    }
    override func viewDidDisappear(_ animated: Bool)
    {
        playerViewController.player?.pause()
        playerViewController.player = nil
    }
    
    @IBAction func actionUpload(_ sender: Any)
    {
        self.view.endEditing(true)
        CommonVc.AllFunctions.bowDown_view_for_keyboard(view:self.view)
        
        if (self.arrNew.count > 2)
        {
            CommonVc.AllFunctions.showAlert(message: "You can not add more than 2 Videos at a time!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            if (CommonVc.AllFunctions.have_internet() == false)
            {
                self.showLoader()
               // self.convert_asset_into_url()
                delete_group_offline_for_happy_memories_changes()
            }
            else
            {
                //upload
                self.oldFiles = false
                self.showLoader()
               // self.convert_asset_into_url()
                
                
             //   self.presenter?.uploadHappyMemoriesData(mediaType: .Video, mediaData: self.arrNew, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.tfDesc.text)
                
                
                self.presenter?.uploadHappyMemoriesData_with_url_array(mediaType: .Video, mediaData: self.arrNew, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.tfDesc.text)
                
          
            }
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        CommonVc.AllFunctions.pullUp_view_for_keyboard(view:self.view)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        CommonVc.AllFunctions.bowDown_view_for_keyboard(view:self.view)
        return true
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDelete(_ sender: Any)
    {
        
        if arrNew.count != 0
        {
            
            if (selectedIndex >= 0)
            {
                // self.selectedIndex = selectedIndex - 1
                
                if(arrNew.count == selectedIndex){
                    selectedIndex = selectedIndex - 1
                    
                }
                arrNew.remove(at: selectedIndex)
                if(arrNew.count <= 0){
                    CommonFunctions.sharedInstance.popTocontroller(from: self)
                }
                self.selectedIndex = selectedIndex - 1
                if (selectedIndex <= 0)
                {
                    selectedIndex = arrNew.count
                }
                self.collectionView.reloadData()
            }
            
            
            //            if (selectedIndex != 0){
            //
            //            }
            
        }
        
    }
    
    @IBAction func openGallery(_ sender: Any)
    {
        
        SelectVideoMemoriesVC.imagePick.allowsEditing = true
        SelectVideoMemoriesVC.imagePick.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        openGalleryy(imagePicker: SelectVideoMemoriesVC.imagePick)
        
//        let pickerViewController = TatsiPickerViewController(config: config)
//        pickerViewController.pickerDelegate = self
//        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func plavideo(path:String)
    {
        let player = AVPlayer(url: URL(string: path)!)
        
        self.playerViewController.player = player
        
        self.addChild(self.playerViewController)
        
        // Add your view Frame
        self.playerViewController.view.frame = self.videoView.frame
        
        // Add sub view in your view
        self.view.addSubview(self.playerViewController.view)
        self.playerViewController.player?.play()
    }
    
    func playVideoViaAssets (asset:PHAsset)
    {
        
        guard (asset.mediaType == PHAssetMediaType.video)
            
            else {
                self.view.makeToast("File is corrupted")
                return
        }
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
            DispatchQueue.main.async {
                if let asset = asset as? AVURLAsset
                {
                    let player = AVPlayer(url: asset.url)
                    
                    self.playerViewController.player = player
                    
                    self.addChild(self.playerViewController)
                    
                    // Add your view Frame
                    self.playerViewController.view.frame = self.videoView.frame
                    
                    // Add sub view in your view
                    self.view.addSubview(self.playerViewController.view)
                    self.playerViewController.player?.play()
                    
                }
                
                
                
                
                //                self.present(playerViewController, animated: true) {
                //                    playerViewController.player?.play()
                //                }
            }
        })
    }
    
    
    func convert_phasset_into_url(myasset:PHAsset)
    {
        
        PHCachingImageManager().requestAVAsset(forVideo: myasset, options: nil)
        { (asset, audioMix, args) in
            if let assetnew = asset as? AVURLAsset
            {
                let vidUrl = assetnew.url
                self.arrNew.append(vidUrl)
                
                DispatchQueue.main.async {
                    self.hideLoader()
                }
            }
            else
            {
                //err
                DispatchQueue.main.async {
                    self.hideLoader()
                }
            }
        }
    }
    
    
    
    func SAVE_FILE_IN_DIRECTORY_and_In_DATABASE(fileURL:URL)
    {
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        
        let saveDic = NSMutableDictionary()
        var fileNAme = CommonVc.AllFunctions.generateRandomString()
        fileNAme = fileNAme + ".mp4"
        CommonVc.AllFunctions.save_file_in_document_directory(pathNew: fileNAme, fileUrl: fileURL)
        
        saveDic.setValue(fileNAme, forKey: coreDataKeys_HappyMemories_Changes.video_path)
        saveDic.setValue("VIDEO", forKey: coreDataKeys_HappyMemories_Changes.group)
        saveDic.setValue("VIDEO", forKey: coreDataKeys_HappyMemories_Changes.type)
        saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.image_data)
        saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.audio_path)
        saveDic.setValue(userID, forKey: coreDataKeys_HappyMemories_Changes.user_id)
        saveDic.setValue(self.btnLocation.titleLabel?.text, forKey: coreDataKeys_HappyMemories_Changes.location)
        saveDic.setValue(self.tfDesc.text, forKey: coreDataKeys_HappyMemories_Changes.desc)
        
        DatabaseModel_HappyMemris_Offline_API_DATA.save_HappyMemris_Changes_offline(data_for_save: saveDic)
        
    }
    
    
    func get_video_arr_for_upload()
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.get_offline_saved_Happy_memris_for_upload(groupKEY: "VIDEO", success: { (data) in
            var desc = ""
            
            DispatchQueue.main.async {
                
                if (data.count > 0)
                {
                    self.oldFiles = true
                    let descDic = data.object(at: 0)as! NSDictionary
                    for obj in data
                    {
                        let dic = obj as! NSDictionary
                        let path = dic.value(forKey: coreDataKeys_HappyMemories_Changes.video_path)as? String ?? ""
                        
                        if (path.count > 0)
                        {
                            let fUrl = documentURL().appendingPathComponent(path)
                            self.arrUploads.append(fUrl.absoluteString)
                        }
                    }
                    
                    self.showLoader()
                    
                    let location = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.location)as? String ?? ""
                    desc = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.desc)as? String ?? ""
                    
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Video, mediaData: self.arrUploads, imageData: [], location:location,description:desc)
                }
                    
                else
                {
                    self.oldFiles = false
                    if (self.arrNew.count > 0)
                    {
                        self.showLoader()
                        self.presenter?.uploadHappyMemoriesData_with_url_array(mediaType: .Video, mediaData: self.arrNew, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.tfDesc.text)
                        
                        
                    }
                }
            }
            
        })
        { (err) in
            print(err)
        }
    }
    
    
    func convert_asset_into_url()
    {
        self.arrUploads = [String]()
//        if (self.arrVideos.count > 0)
//        {
//            for asst in self.arrVideos
//            {
//                self.convert_phasset_into_url(myasset: asst)
//            }
//        }
//        else
//        {
//            self.hideLoader()
//        }
    }
    
    
    func delete_group_offline_for_happy_memories_changes()//IT WILL DELETE ALL IMAGES AND VIDEOS/AUDIOS -> ALL GROUP AND SAVE NEW VALUE
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY: "VIDEO", success: { (sccss) in
            
            DispatchQueue.main.async {
                
                self.save_asset_in_database()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        })
        { (err) in
            
            DispatchQueue.main.async {
                
                self.save_asset_in_database()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        }
    }
    
    func save_asset_in_database()
    {
        if (self.arrNew.count > 0)
        {
            for obj in self.arrNew
            {
                let url = obj
                self.SAVE_FILE_IN_DIRECTORY_and_In_DATABASE(fileURL: url)
            }
        }
    }
    
    
    func handle_success_and_pop_controller(msg:String)
    {
        // Create the alert controller
        let alertController = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: msg, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Functions
    func openGalleryy(imagePicker:UIImagePickerController)
    {
        
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized)
        {
            // Access has been granted.
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.mediaTypes = ["public.movie"]
            navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            imagePicker.navigationBar.tintColor = UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            imagePicker.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.init(red: 43.0/255.0, green: 18.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            ]
            
            imagePicker.videoMaximumDuration = 30.0
            present(imagePicker, animated: true)
        }
            
        else if (status == PHAuthorizationStatus.denied)
        {
            // Access has been denied.
            let alert = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: "Please go to settings and allow the permission of gallery", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Open setting", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString)
                    {
                        UIApplication.shared.openURL(settingsURL)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
            
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized)
                {
                    
                }
                else
                {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted)
        {
            // Restricted access - normally won't happen.
        }
    }
    
    
   
    
    
}
extension SelectVideoMemoriesVC: TatsiPickerViewControllerDelegate
{
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset])
    {
        pickerViewController.dismiss(animated: true, completion: nil)
        print("Assets \(assets)")
        selectedIndex = assets.count - 1
        for ast in assets
        {
          //  arrVideos.append(ast)
        }
        if (assets.count > 0)
        {
            // let currImageVideo = arrVideos[0]
            // self.playVideoViaAssets(asset: currImageVideo)
        }
        
        self.showLoader()
        self.convert_asset_into_url()
        self.collectionView.reloadData()
    }
    
}
extension SelectVideoMemoriesVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrNew.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = self.collectionView.dequeueReusableCell(withReuseIdentifier: SelectVideoMemoriesCell.className, for: indexPath) as! SelectVideoMemoriesCell
        if(indexPath.row == 0)
        {
            cell.imgView.image = UIImage.init(named: "AddMedia")
        }
        else
        {
            cell.imgView.image = UIImage.init(named: "videoBG")//videoPlay
        }
        //cell.imgView.image = arrVideos[indexPath.row - 1].getAssetThumbnail(size: cell.imgView!.frame.size)
        //cell.imgView.image = UIImage.init(named: "play")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            openGallery(self)
        }
        else
        {
            selectedIndex = indexPath.row - 1
            let path = arrNew[indexPath.row - 1]
            
            self.plavideo(path: path.absoluteString)
          //  self.playVideoViaAssets(asset: currImageVideo)
            //            let finalImage = currImage.getImageFromPHAsset()
            //            let finalImage = currImage.getAssetThumbnail(size: imgView.frame.size)
            //            self.imgView.image = finalImage
        }
        
    }
}

extension SelectVideoMemoriesVC:HappyMemoriesCommonDelegate
{
    func HappyMemoriesCommonDidSucceeed(message: String)
    {
        self.hideLoader()
        
        if (self.oldFiles == false)
        {
            self.handle_success_and_pop_controller(msg: message)
        }
        else
        {
            self.handle_success_and_pop_controller(msg: "Your offline saved videos for Happy Memories has been uploaded successfully!")
        }
        
    }
    
    func HappyMemoriesCommonDidFailed(message: String)
    {
        self.hideLoader()
        self.showAlert(Message: message)
    }
    
}

extension SelectVideoMemoriesVC:HappyMemoriesCommonViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader() {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

extension SelectVideoMemoriesVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var fileErr = false
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        {
            if mediaType == "public.movie"
            {
                print(info[UIImagePickerController.InfoKey.mediaURL] as Any)
                if let path = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
                {
                    self.arrNew.append(path as URL)
                    self.plavideo(path: "\(arrNew[0])")
                    self.collectionView.reloadData()
                }
                else
                {
                    fileErr = true
                }
            }
        }
        
        let contorller = CommonVc.AllFunctions.get_top_controller()
        contorller.dismiss(animated: true, completion: nil)
        
        if (fileErr == true)
        {
            CommonVc.AllFunctions.show_automatic_hide_alert(controller: contorller, title: "Sorry! file path is not valid")
        }
    }
}

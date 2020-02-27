//
//  GalleryVC.swift
//  IGetHappy
//
//  Created by Gagan on 8/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
import Photos
import MediaPlayer
import AVFoundation

protocol GalleryVCViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
}


class GalleryVC: BaseUIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet var myPagerView: UIPageControl!
    @IBOutlet weak var lblDefault: UILabel!
    @IBOutlet weak var heightConstant_view_collection: NSLayoutConstraint!
    @IBOutlet weak var collectionView_selectedItems: UICollectionView!
    @IBOutlet weak var view_collection: UIView!
    @IBOutlet var happyMemoriesCollectionView: UICollectionView!
    @IBOutlet var loadMoreButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var fileNAME = ""
    var audioPlayer : AVAudioPlayer?
    var playingAudio = false
    var arrData = NSMutableArray()
    var arrSlideMemories = NSMutableArray()// This is your data array
    var arrSelectedIndex = NSMutableArray() // This is selected cell Index array
    // var arrSelectedData = [String]() // This is selected cell data array
    
    var presenter:GalleryVcPresenter?
    var apiDATA:[AllVentsModelDetail]?
    var showAlert_for_large_videos = false
    var showAlert_for_currptedFile_videos = false
    var ping_for_asset_conversion = 0
    var pickedAssets = [PHAsset]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        GalleryVC_Controller_Extension.Ref_GalleryVC = self
        
        self.GET_HAPPY_MEMORY_SLIDE()
        
        self.presenter = GalleryVcPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        happyMemoriesCollectionView.delegate = self
        happyMemoriesCollectionView.dataSource = self
        happyMemoriesCollectionView.allowsMultipleSelection = true
        happyMemoriesCollectionView.reloadData()
        // Do any additional setup after loading the view.
        
        loadMoreButton.layer.cornerRadius = 30
        
        //navigationController?.navigationBar.barTintColor = UIColor.orange
        //self.view.backgroundColor = UIColor.orange
        
        
        //
        
        //   self.GET_HAPPY_MEMORY_SLIDE()
        
        presenter?.CALL_API_GET_HAPPY_MEMORIES_FILES()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
    
    @IBAction func ACTION_DISMISS_VIEW(_ sender: Any)
    {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: GalleryVC.self)
            {
                self.dismiss(animated: true, completion: nil)
                break
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func ACTION_DELETE_SAVED_MEMORIES_FROM_CELL(_ sender: UIButton)
    {
        let indexpth = IndexPath(item: sender.tag, section: 0)
        self.HANDLE_DELETE_SAVED_MEMORIES(tag: sender.tag,indx: indexpth)
    }
    
    @IBAction func ACTION_PLAY_VIDEO(_ sender: UIButton)
    {
        let dic = self.arrSlideMemories.object(at: sender.tag) as! NSDictionary
        let fileURL = dic.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
        let type = dic.value(forKey: coreDataKeys_HappyMemories.type) as? String ?? ""
        if fileURL.count == 0
        {
            CommonVc.AllFunctions.showAlert(message: "Sorry video path not available!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            if (type == "VIDEO")
            {
                self.play_sliding_video(fileName: fileURL)
            }
            else
            {
                if playingAudio == false
                {
                    playingAudio = true
                    self.play_sliding_audio(fileName: fileURL, sender: sender)
                    self.collectionView_selectedItems.reloadData()
                }
                else
                {
                    self.fileNAME = ""
                    audioPlayer?.pause()
                    playingAudio = false
                    self.collectionView_selectedItems.reloadData()
                }
                
            }
        }
    }
    
    
    @IBAction func loadMoreButtonAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func openPhoneGalleryButtonAction(_ sender: UIButton)
    {
        
        //  self.present(imagePicker, animated: true, completion: nil)
        
        var config = TatsiConfig.default
        config.showCameraOption = true
        config.supportedMediaTypes = [.image,.video]
        config.firstView = .userLibrary
        config.maxNumberOfSelections = 10
        
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
        
        
        
        /*if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
         print("Button capture")
         
         checkPermission()
         
         imagePicker.delegate = self
         imagePicker.allowsEditing = false
         imagePicker.sourceType = .photoLibrary
         
         present(imagePicker, animated: true, completion: nil)
         }*/
    }
    
    func checkPermission()
    {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                //  print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: GalleryVC.self)
            {
                self.dismiss(animated: true, completion: nil)
                break
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //        {
        //            //self.imgView.contentMode = .scaleAspectFit
        //            //self.imgView.image = pickedImage
        //        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("cancel is clicked")
    }
    
    
    //MARK: < HANDLING SELECTED ITEMS COLLECTION VIEW CONSTRAINTS ->
    func show_selected_items_in_collection()
    {
        // UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations:
        //     {
        //  self.heightConstant_view_collection.constant = 210
        //  self.viewDidLayoutSubviews()
        // })
    }
    
    func hide_selected_items_collectionView()
    {
        // UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear, animations:
        //     {
        //  self.heightConstant_view_collection.constant = 0
        //  self.viewDidLayoutSubviews()
        // })
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == self.collectionView_selectedItems
        {
            for cell in collectionView_selectedItems.visibleCells
            {
                let indexPath = collectionView_selectedItems.indexPath(for: cell)
                self.myPagerView.currentPage = indexPath?.row ?? 0
            }
        }
        
    }
    
    
    func HANDLE_DELETE_SAVED_MEMORIES(tag:Int,indx:IndexPath)
    {
        // Create the alert controller
        let alertController = UIAlertController(title: Constants.Global.ConstantStrings.KAppname, message: Constants.Global.ConstantStrings.KDoYouWantDelete, preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            
            let objDic : NSDictionary = self.arrSlideMemories.object(at: tag) as! NSDictionary
            let type = objDic.value(forKey: coreDataKeys_HappyMemories.type) as? String
            // let fileNAME = objDic.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
            
            let tableID : String = objDic.value(forKey: coreDataKeys_HappyMemories.table_id) as? String ?? ""
            CoreData_Model.delete_memories_offline_in_coreData(tableID: tableID, success: { (result) in
                
                //  print(result)
                
            }) { (error) in
                print(error)
            }
            
            
            let tmparr = self.arrSlideMemories.mutableCopy() as! NSMutableArray
            tmparr.removeObject(at: tag)
            //  self.collectionView_selectedItems.deleteItems(at: [indx])
            self.arrSlideMemories = tmparr
            self.collectionView_selectedItems.reloadData()
            
            self.myPagerView.numberOfPages = self.arrSlideMemories.count
            
            if self.arrSlideMemories.count == 0
            {
                self.lblDefault.isHidden = false
            }
            
            if (type == "VIDEO" || type == "AUdIO")
            {
                //  self.delete_file_from_document_dirctory(fileName: fileNAME)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func ACTION_DOWNLOAD_IMAGES(_ sender: UIButton)
    {
        
        DispatchQueue.main.async {
            CommonVc.AllFunctions.addLOADER(controller: self)
        }
        
        let dic = self.arrData.object(at: sender.tag)as? NSMutableDictionary
        let filePath = dic?.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
        
        GalleryVC_Controller_Extension.download_file_from_server(fileURL: filePath, tag: sender.tag, arr: self.arrData, successArr: { (reslt) in
            
            DispatchQueue.main.async {
                CommonVc.AllFunctions.hideLOADER(controller: self)
                self.arrData = reslt.mutableCopy() as! NSMutableArray
                self.happyMemoriesCollectionView.reloadData()
                CommonVc.AllFunctions.showAlert(message: "File downloaded successfuly!", view: self, title: Constants.Global.ConstantStrings.KAppname)
            }
            
        })
        { (err) in
            DispatchQueue.main.async {
                CommonVc.AllFunctions.hideLOADER(controller: self)
                CommonVc.AllFunctions.showAlert(message: err, view: self, title: Constants.Global.ConstantStrings.KAppname)
            }
        }
        
        
    }
    
    @IBAction func ACTION_DELETE_IMAGES(_ sender: UIButton)
    {
        // let indexpth = IndexPath(item: sender.tag, section: 0)
        let objDic = self.arrData.object(at: sender.tag)as? NSDictionary
        let tb = objDic!.value(forKey: coreDataKeys_HappyMemories.table_id) as? String ?? ""
        let file = objDic!.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
        
        DatabaseModel_Gallery.delete_GALLERY_offline_FROM_coreData(tableID: tb, success: { (result) in
            
            DispatchQueue.main.async {
                
                let tmparr = self.arrData.mutableCopy() as! NSMutableArray
                tmparr.removeObject(at: sender.tag)
                // self.happyMemoriesCollectionView.deleteItems(at: [indexpth])
                self.arrData = tmparr
                self.happyMemoriesCollectionView.reloadData()
                
                let temp = self.arrSelectedIndex.mutableCopy() as! NSMutableArray
                if (temp.contains(sender.tag))
                {
                    temp.remove(sender.tag)
                    self.arrSelectedIndex = temp
                    self.collectionView_selectedItems.reloadData()
                }
                
                self.MATCH_FILE_WITH_SLIDE_MEMORY(name: file)//if matched then remove it from document directory
                GalleryVC_Controller_Extension.get_saved_happy_memories()
                
            }
            
            
            
        }, failure: { (err) in
            print(err)
        })
    }
    
}

extension GalleryVC: TatsiPickerViewControllerDelegate
{
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset])
    {
        // self.arrData = NSMutableArray()
        // self.arrSelectedIndex = NSMutableArray()
        
        pickerViewController.dismiss(animated: true, completion: nil)
        
        pickedAssets = assets
        self.showAlert_for_currptedFile_videos = false
        
        if (assets.count > 0)
        {
            self.addLOADER()
            for myasset in assets
            {
                
                //  print(myasset.mediaType.rawValue)
                let dic = NSMutableDictionary()
                let tableID = CommonVc.AllFunctions.generateRandomString()
                let userID = UserDefaults.standard.getUserId() ?? ""
                
                let imageNew = myasset.thumbnailImage
                let imgData = imageNew?.pngData()
                let base64String = imgData?.base64EncodedString()
                let location = UserDefaults.standard.getLocation()
                
                dic.setValue("1", forKey: coreDataKeys_HappyMemories.is_downloaded)
                dic.setValue("1", forKey: coreDataKeys_HappyMemories.is_offline)
                dic.setValue("", forKey: coreDataKeys_HappyMemories.url)
                dic.setValue(base64String, forKey: coreDataKeys_HappyMemories.asset)
                dic.setValue(tableID, forKey: coreDataKeys_HappyMemories.table_id)
                dic.setValue(userID, forKey: coreDataKeys_HappyMemories.user_id)
                dic.setValue(location, forKey: coreDataKeys_HappyMemories.location)
                
                if (myasset.mediaType.rawValue == 1)
                {
                    dic.setValue("IMAGE", forKey: coreDataKeys_HappyMemories.type)
                    dic.setValue("IMAGE", forKey: coreDataKeys_HappyMemories.name)
                    //saving images in gallery database
                    self.SAVE_IMAGES_IN_COREDATE_GALLERY(obj: dic)
                    self.arrData.add(dic)
                }
                else
                {
                    dic.setValue("VIDEO", forKey: coreDataKeys_HappyMemories.type)
                    dic.setValue("VIDEO", forKey: coreDataKeys_HappyMemories.name)
                    
                    //getting URL of Videos and aftr conversion -> saving in database
                    self.convert_phasset_into_url(myasset: myasset, dic: dic)
                    {
                        (reslt) in
                        print(reslt as Any)
                        self.display_video_currepted_alert()
                    }
                    
                    
                }
            }
            
        }
        
        self.hideLOADER()
        self.happyMemoriesCollectionView.reloadData()
        

        
        
    }
    
    
    func display_video_duration_exceed_alert()
    {
        if (self.showAlert_for_large_videos == true)
        {
            if (self.ping_for_asset_conversion >= pickedAssets.count)
            {
                self.showAlert_for_large_videos = false
                self.ping_for_asset_conversion = 0
                // the alert view
                let tit = "Videos which are more than 30 seconds can not be used for happy memories because they are larger in size!"
                CommonVc.AllFunctions.show_automatic_hide_alert(controller:self,title:tit)
            }
        }
    }
    
    
    func display_video_currepted_alert()
    {
        if (self.showAlert_for_currptedFile_videos == true)
        {
            let tit = "Path for the videos are not correct. Please choose different files."
            CommonVc.AllFunctions.show_automatic_hide_alert(controller:self,title:tit)
        }
    }
}





extension UIImage
{
    enum JPEGQuality: CGFloat
    {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data?
    {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension PHAsset
{
    var thumbnailImage:UIImage?
    {
        
        get
        {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                if let rslt = result
                {
                    thumbnail = rslt
                }
                else
                {
                    thumbnail = UIImage(named:"currepted")!
                }
                
            })
            return thumbnail
        }
    }
}

extension GalleryVC : UICollectionViewDataSource,UICollectionViewDelegate
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if (collectionView == self.collectionView_selectedItems)
        {
            return self.arrSlideMemories.count
        }
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell = UICollectionViewCell()
        
        if (collectionView == self.collectionView_selectedItems)
        {
            let cellNew = collectionView.dequeueReusableCell(withReuseIdentifier: "CellClass_Selected_Items", for: indexPath) as! CellClass_Selected_Items
            let dic : NSDictionary = self.arrSlideMemories.object(at: indexPath.row) as! NSDictionary
            
            let asset = dic.value(forKey: coreDataKeys_HappyMemories.asset)as? String ?? ""
            let file = dic.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
            
            let imag = CommonVc.AllFunctions.decodeImage(base64: asset)
            cellNew.ivThumb.image = imag
            
            let type = dic.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            
            if (type == "VIDEO")
            {
                cellNew.btnPlay.isHidden = false
            }
            else if (type == "AUDIO")
            {
                cellNew.btnPlay.isHidden = false
                cellNew.ivThumb.image = UIImage(named: "audioBG")
            }
            else
            {
                cellNew.btnPlay.isHidden = true
            }
            
            if (file == self.fileNAME && playingAudio == true)
            {
                cellNew.btnPlay.setImage(UIImage(named: "pause"), for: UIControl.State.normal)
            }
            else
            {
                cellNew.btnPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
            }
            
            cellNew.btnDelete.tag = indexPath.row
            cellNew.btnPlay.tag = indexPath.row
            cellNew.layer.cornerRadius = 10
            cellNew.layer.masksToBounds = true
            cell = cellNew
        }
        else
        {
            let cellNew = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryScreenCollectionViewCell", for: indexPath) as! GalleryScreenCollectionViewCell
            let dic : NSDictionary = self.arrData.object(at: indexPath.row) as! NSDictionary
            let asset = dic.value(forKey: coreDataKeys_HappyMemories.asset)as? String ?? ""
            let imgURL = dic.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
            let type = dic.value(forKey: coreDataKeys_HappyMemories.type)as? String ?? ""
            
            let is_downloaded = dic.value(forKey: coreDataKeys_HappyMemories.is_downloaded) as? String ?? ""
            
            // let is_offline = dic.value(forKey: coreDataKeys_HappyMemories.is_offline) as? String ?? ""
            
            
            if arrSelectedIndex.contains(indexPath.row)
            {
                // You need to check wether selected index array contain current index if yes then change the color
                cellNew.ivSelected.isHidden = false
            }
            else
            {
                cellNew.ivSelected.isHidden = true
            }
            
            
            if(is_downloaded == "1")
            {
                cellNew.btnDownload.isHidden = true
                cellNew.btnDeleteGallery.isHidden = false
                
                if (type != "IMAGE")
                {
                    cellNew.ivPlay.isHidden = false
                    cellNew.imageView.image = CommonVc.AllFunctions.get_placeholder_image(type:type)
                }
                else
                {
                    cellNew.ivPlay.isHidden = true
                    let imag = CommonVc.AllFunctions.decodeImage(base64: asset)
                    cellNew.imageView.image = imag
                }
            }
            else
            {
                cellNew.btnDownload.isHidden = false
                cellNew.btnDeleteGallery.isHidden = true
                
                // cellNew.imageView.image = CommonVc.AllFunctions.get_placeholder_image(type:type)
                
                if (type == "IMAGE")
                {
                    cellNew.ivPlay.isHidden = true
                    cellNew.imageView.kf.setImage(with: URL(string:imgURL))
                }
                else
                {
                    cellNew.ivPlay.isHidden = false
                    cellNew.imageView.image = CommonVc.AllFunctions.get_placeholder_image(type:type)
                }
                
                
                //  if (imgURL.count > 0)
                //  {
                //      cellNew.imageView.kf.setImage(with: URL(string:imgURL))
                //  }
            }
            
            //            if(is_downloaded == "1")
            //            {
            //                cellNew.btnDownload.isHidden = true
            //            }
            //            else
            //            {
            //                cellNew.btnDownload.isHidden = false
            //            }
            
            
            
            cellNew.btnDeleteGallery.tag = indexPath.row
            cellNew.btnDownload.tag = indexPath.row
            cell = cellNew
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        
        if (collectionView == self.collectionView_selectedItems)
        {
            collectionView_selectedItems.reloadData()
        }
        else
        {
            let objDic : NSDictionary = arrData.object(at: indexPath.row) as! NSDictionary
            let from_offline = objDic.value(forKey: coreDataKeys_HappyMemories.is_offline)as? String ?? "1"
            
            //PREVENTING DID SELECT FOR SLIDE BEFORE DOWNLOADING
            if (from_offline == "0")
            {
                CommonVc.AllFunctions.showAlert(message: "In Order to select this file for Happy Memories Slide, it should be downloaded first!", view: self, title: Constants.Global.ConstantStrings.KAppname)
            }
                
                //WE HAVE DOWNLOADED FILE THEN IT SHOULD BE IN ELSE CONDITION
            else
            {
                var fName = ""
                
                if arrSelectedIndex.contains(indexPath.row)
                {
                    let temp = self.arrSelectedIndex.mutableCopy() as! NSMutableArray
                    temp.remove(indexPath.row)
                    arrSelectedIndex = temp
                    
                    if arrSlideMemories.contains(objDic)
                    {
                        let indx = arrSlideMemories.index(of: objDic)
                        let dic = arrSlideMemories.object(at: indx) as? NSDictionary
                        fName = dic?.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
                        
                        let tmpArr = arrSlideMemories.mutableCopy() as! NSMutableArray
                        tmpArr.remove(objDic)
                        arrSlideMemories = tmpArr
                        collectionView_selectedItems.reloadData()
                        self.myPagerView.numberOfPages = self.arrSlideMemories.count
                    }
                    
                    collectionView.reloadData()
                    
                    let tableID : String = objDic.value(forKey: coreDataKeys_HappyMemories.table_id) as? String ?? ""
                    CoreData_Model.delete_memories_offline_in_coreData(tableID: tableID, success: { (result) in
                        
                        // print(result)
                        //   self.delete_file_from_document_dirctory(fileName: fName)
                        
                    }) { (error) in
                        print(error)
                        
                    }
                }
                else
                {
                    let saveDIC = self.arrData.object(at: indexPath.row)as? NSDictionary
                    
                    CoreData_Model.save_memories_offline_in_coreData(data_for_save: saveDIC!, success: { (result) in
                        // print(result)
                        
                        DispatchQueue.main.async {
                            self.arrSelectedIndex.add(indexPath.row)
                            self.update_slide_memories(obj: objDic)
                            //  let indx = self.arrSlideMemories.count-1
                            //   self.collectionView_selectedItems.scrollToItem(at: IndexPath(item: indx, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
                        }
                        
                        
                    }) { (error) in
                        print(error)
                    }
                    
                }
            }
            
        }
        
        if self.arrSlideMemories.count == 0
        {
            self.lblDefault.isHidden = false
        }
        
    }
    
    
    func update_slide_memories(obj:NSDictionary)
    {
        DispatchQueue.main.async {
            if (self.arrSlideMemories.contains(obj))
            {
                let temp = self.arrSlideMemories.mutableCopy() as! NSMutableArray
                temp.remove(obj)
                self.arrSlideMemories = temp
            }
            else
            {
                self.arrSlideMemories.add(obj)
            }
            
            self.myPagerView.numberOfPages = self.arrSlideMemories.count
            
            if (self.arrSlideMemories.count == 0)
            {
                self.hide_selected_items_collectionView()
                self.lblDefault.isHidden = false
                self.viewDidLayoutSubviews()
            }
            else
            {
                self.lblDefault.isHidden = true
                self.show_selected_items_in_collection()
            }
            
            self.collectionView_selectedItems.reloadData()
            self.happyMemoriesCollectionView.reloadData()
        }
    }
    
    
    
}

extension GalleryVC :  UICollectionViewDelegateFlowLayout
{
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if (collectionView == self.collectionView_selectedItems)
        {
            return CGSize(width: 180, height:  180)
        }
        
        
        return CGSize(width: collectionView.frame.size.width/3, height:  collectionView.frame.size.width/3)
        
        
        // collectionView.frame.size.width/3.2 , 100
        
        // self.view.frame.size.width/5
    }
    
    
    
    func play_sliding_video(fileName:String)
    {
                if (fileName.count > 0)
                {
                    let fm = FileManager.default
                    let docsurl = try! fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let path = docsurl.appendingPathComponent(fileName)
                    let videoURL = NSURL(string: path.absoluteString)
        
                    let player = AVPlayer(url: videoURL! as URL)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true)
                    {
                        playerViewController.player!.play()
                    }
                }
                else
                {
                    CommonVc.AllFunctions.showAlert(message: "Sorry this video path is not correct!", view: self, title: Constants.Global.ConstantStrings.KAppname)
                }
    }
    
    
    func play_sliding_audio(fileName:String,sender:UIButton)
    {
        self.fileNAME = fileName
        let outputURL = documentURL().appendingPathComponent(fileName)
        // print("OutURL->\(outputURL)")
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: outputURL)
            audioPlayer!.prepareToPlay()
        }
        catch
        {
            print(error)
            self.fileNAME = ""
            self.playingAudio = false
            self.collectionView_selectedItems.reloadData()
        }
        
        if((audioPlayer) != nil)
        {
            
  
            
            if(audioPlayer!.isPlaying)
            {
                audioPlayer!.pause()
            }
            else
            {
                audioPlayer!.play()
            }
        }
        
    }
    
    func addLOADER()
    {
        DispatchQueue.main.async {
            self.ShowLoaderCommon()
        }
    }
    
    func hideLOADER()
    {
        DispatchQueue.main.async {
            self.HideLoaderCommon()
        }
    }
    
}


extension GalleryVC
{
    
    
    func convert_phasset_into_url(myasset:PHAsset,dic:NSMutableDictionary, callBack: @escaping (_ FINAL_PATH: String?) -> Void)
    {
        
        PHCachingImageManager().requestAVAsset(forVideo: myasset, options: nil)
        { (asset, audioMix, args) in
            
            self.ping_for_asset_conversion = self.ping_for_asset_conversion+1
            
            if let assetnew = asset as? AVURLAsset
            {
                
                let duration = CommonVc.AllFunctions.convert_asset_duration(asset: assetnew)
                
                if (duration > 30)
                {
                    self.showAlert_for_large_videos = true
                    self.display_video_duration_exceed_alert()
                }
                else
                {
                    var fileName = CommonVc.AllFunctions.generateRandomString()
                    fileName = "\(fileName).mp4"
                    self.SAVE_FILE_IN_DIRECTORY(fileURL: assetnew.url, fileNAME: fileName, objDic: dic, success: { (result) in
                        print(result)
                        callBack(result)
                    })
                }
            }
            else
            {
                self.showAlert_for_currptedFile_videos = true
                callBack("error")
            }
            
            if (self.ping_for_asset_conversion >= self.pickedAssets.count)
            {
                if (self.showAlert_for_large_videos == true)
                {
                   self.display_video_duration_exceed_alert()
                }
                
            }
        }
        
        
    }
    
    func SAVE_FILE_IN_DIRECTORY(fileURL:URL,fileNAME:String,objDic:NSMutableDictionary,success: @escaping (String) -> Void)
    {
        
        let videoData = NSData(contentsOf: fileURL)
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let newPath = path.appendingPathComponent(fileNAME)
        do
        {
            try videoData?.write(to: newPath)
            
            //Saving Document directory path in database
            let dic : NSMutableDictionary = objDic
            dic.setValue(fileNAME, forKey: coreDataKeys_HappyMemories.url)
            
            DatabaseModel_Gallery.save_GALLERY_offline_in_coreData(data_for_save: objDic, success: { (result) in
                
                success("success")
                self.arrData.add(dic)
                
                DispatchQueue.main.async {
                    self.happyMemoriesCollectionView.reloadData()
                }
                
            }) { (error) in
                print(error)
                success(error)
            }
        }
        catch
        {
            print(error)
            success("error")
        }
    }
    
    func SAVE_IMAGES_IN_COREDATE_GALLERY(obj:NSMutableDictionary)
    {
        DatabaseModel_Gallery.save_GALLERY_offline_in_coreData(data_for_save: obj, success: { (result) in
            print(result)
            
        }) { (error) in
            print(error)
        }
    }
    
    
    func GET_HAPPY_MEMORY_SLIDE()
    {
        CoreData_Model.get_offline_saved_memories(success: { (arr) in
            
            self.arrSlideMemories = NSMutableArray(array: arr)
            if (self.arrSlideMemories.count > 0)
            {
                
                DispatchQueue.main.async {
                    
                    self.lblDefault.isHidden = true
                    self.show_selected_items_in_collection()
                    self.collectionView_selectedItems.reloadData()
                    self.myPagerView.numberOfPages = self.arrSlideMemories.count
                }
            }
            else
            {
                self.lblDefault.isHidden = false
            }
            
            self.GET_HAPPY_MEMORY_GALLERY()
            
        }, failure: { (error) in
            print(error)
            self.GET_HAPPY_MEMORY_GALLERY()
        })
    }
    
    func GET_HAPPY_MEMORY_GALLERY()
    {
        
        
        self.arrData = NSMutableArray()
        DatabaseModel_Gallery.get_offline_saved_GALLERY(success: { (arr) in
            
            
            DispatchQueue.main.async {
                
                if (arr.count > 0)
                {
                    for obj in arr
                    {
                        self.arrData.add(obj)
                    }
                }
                
                if (self.arrData.count > 0)
                {
                    self.happyMemoriesCollectionView.reloadData()
                }
            }
            
            
        }, failure: { (error) in
            
            print(error)
        })
    }
    
    
    func delete_file_from_document_dirctory(fileName:String)
    {
        if (fileName.count > 0)
        {
            let filemanager = FileManager.default
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as NSString
            let destinationPath = documentsPath.appendingPathComponent(fileName)
            do
            {
                try filemanager.removeItem(atPath: destinationPath)
                print("Local path removed successfully")
            }
            catch let error as NSError
            {
                print("------Error",error.debugDescription)
            }
        }
        
    }
    
    
    func MATCH_FILE_WITH_SLIDE_MEMORY(name:String)
    {
        var val = false
        for obj in self.arrSlideMemories
        {
            let dic = obj as? NSDictionary
            let fileName = dic?.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
            
            if fileName == name
            {
                val = true
            }
        }
        
        if (val == false)//SLIDE MEMORY DONT HAVE THIS  FILE SO I AM REMOVING IT FROM DOCUMENT
        {
            self.delete_file_from_document_dirctory(fileName: name)
        }
    }
}




extension GalleryVC:GalleryVCViewDelegate
{
    func showAlert(alertMessage: String)
    {
        CommonVc.AllFunctions.showAlert(message: alertMessage, view: self, title: Constants.Global.ConstantStrings.KAppname)
    }
    
    func showLoader()
    {
        CommonVc.AllFunctions.addLOADER(controller: self)
    }
    
    func hideLoader()
    {
        CommonVc.AllFunctions.hideLOADER(controller: self)
    }
}

extension GalleryVC:GalleryPresenterDelegate
{
    func api_success_result(results:GetHappyMemoriesMapper)
    {
        
        GalleryVC_Controller_Extension.get_saved_happy_memories()//GETTING DATA FOR MATCHING DOWNLOADED VALUES
        self.GET_HAPPY_MEMORY_GALLERY()
        
        if(results.data?.count ?? 0 > 0)
        {
            for objData in results.data!
            {
                let arr = objData.post_upload_file
                let tableID = CommonVc.AllFunctions.generateRandomString()
                
                if (arr?.count ?? 0 > 0)
                {
                    
                    for obj in arr!
                    {
                        let dic = NSMutableDictionary()
                        let unqid = objData._id ?? ""
                        
                        let already_Downloaded = GalleryVC_Controller_Extension.match_already_downloaded_happy_memories_with_server_files(fileURL:obj)
                        
                        if (already_Downloaded == false)
                        {
                            dic.setValue(unqid, forKey: coreDataKeys_HappyMemories.unique_id)
                            dic.setValue("0", forKey: coreDataKeys_HappyMemories.is_downloaded)
                            dic.setValue("0", forKey: coreDataKeys_HappyMemories.is_offline)
                            dic.setValue(obj, forKey: coreDataKeys_HappyMemories.url)
                            dic.setValue(obj, forKey: coreDataKeys_HappyMemories.file_URI)
                            dic.setValue("", forKey: coreDataKeys_HappyMemories.asset)
                            dic.setValue(tableID, forKey: coreDataKeys_HappyMemories.table_id)
                            dic.setValue(objData.user_id, forKey: coreDataKeys_HappyMemories.user_id)
                            dic.setValue(objData.location, forKey: coreDataKeys_HappyMemories.location)
                            dic.setValue(objData.post_upload_type, forKey: coreDataKeys_HappyMemories.type)
                            dic.setValue(objData.post_upload_type, forKey: coreDataKeys_HappyMemories.name)
                            
                            self.arrData.add(dic)
                        }
                    }
                }
            }
        }
        
        self.happyMemoriesCollectionView.reloadData()
    }
}



//extension GalleryVC:GalleryPresenterDelegate
//{
//    func api_success_result(results:GetHappyMemoriesMapper)
//    {
//        self.GET_HAPPY_MEMORY_GALLERY()
//
//        if(results.data?.count ?? 0 > 0)
//        {
//            for objData in results.data!
//            {
//                let arr = objData.post_upload_file
//                let tableID = CommonVc.AllFunctions.generateRandomString()
//
//                if (arr?.count ?? 0 > 0)
//                {
//
//                    let dic = NSMutableDictionary()
//
//                    dic.setValue("0", forKey: coreDataKeys_HappyMemories.is_downloaded)
//                    dic.setValue("0", forKey: coreDataKeys_HappyMemories.is_offline)
//                    dic.setValue(arr?[0], forKey: coreDataKeys_HappyMemories.url)
//                    dic.setValue("", forKey: coreDataKeys_HappyMemories.asset)
//                    dic.setValue(tableID, forKey: coreDataKeys_HappyMemories.table_id)
//                    dic.setValue(objData.user_id, forKey: coreDataKeys_HappyMemories.user_id)
//                    dic.setValue(objData.location, forKey: coreDataKeys_HappyMemories.location)
//                    dic.setValue(objData.post_upload_type, forKey: coreDataKeys_HappyMemories.type)
//                    dic.setValue(objData.post_upload_type, forKey: coreDataKeys_HappyMemories.name)
//
//                    self.arrData.add(dic)
//
//                }
//            }
//        }
//
//
//
//        self.happyMemoriesCollectionView.reloadData()
//    }
//
//}




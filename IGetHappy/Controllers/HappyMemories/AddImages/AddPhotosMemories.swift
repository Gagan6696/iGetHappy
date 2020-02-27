//
//  AddPhotosMemories.swift
//  IGetHappy
//
//  Created by Gagan on 8/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//


import UIKit
import Photos
import BSImagePicker
import IGRPhotoTweaks


class AddPhotosMemories: BaseUIViewController,UITextFieldDelegate
{
    static var vc = BSImagePickerViewController()
    var SelectedAssets = [PHAsset]()
    var finalImageArr = [UIImage]()
    var selectedIndex =  Int()
    var databaseArr = [UIImage]()
    var databaseDesc_Dic = NSDictionary()
    var old_files = Bool()
    
    @IBOutlet weak var btnLocation: UIButton!
    var presenter: HappyMemoriesCommonPresenter?
    @IBOutlet weak var txtfldAddText: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var colectionView: UICollectionView!
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        // override func viewDidLoad() {
        // super.viewDidLoad()
        self.colectionView.delegate = self
        self.colectionView.dataSource  = self
        let location = UserDefaults.standard.getLocation() ?? ""
        self.btnLocation.setTitle(location, for: .normal)
        
        if(SelectedAssets.isEmpty)
        {
            self.openGallery(self)
        }
        
        
        self.presenter = HappyMemoriesCommonPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
         self.hideLoader()
        self.get_files_for_upload_from_database()//getting saved images and uploading them
       
        
    }
    @IBAction func actionUpload(_ sender: Any)
    {
        self.view.endEditing(true)
        CommonVc.AllFunctions.bowDown_view_for_keyboard(view:self.view)
        if (self.SelectedAssets.count > 5)
        {
            CommonVc.AllFunctions.showAlert(message: "You can not add more than 5 Images at a time!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            if (CommonVc.AllFunctions.have_internet() == false)
            {
                self.showLoader()
                self.delete_group_offline_for_happy_memories_changes()
            }
            else
            {
                //upload them
                self.generate_images()
                self.get_files_for_upload_from_database()
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
    
    @IBAction func actnDismiss(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
        //CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    
    @IBAction func actnLocation(_ sender: Any)
    {
        
    }
    
    @IBAction func actnDelete(_ sender: Any)
    {
        
        //if(selectedIndex > 0){
        print(selectedIndex)
        if(selectedIndex >= 0){
            if(!SelectedAssets.isEmpty){
                self.SelectedAssets.remove(at: selectedIndex)
                self.selectedIndex = selectedIndex - 1
                //let lastImage  = SelectedAssets[selectedIndex - 1].getAssetThumbnail(size: self.imgView.frame.size)
                //self.imgView.image = lastImage
                self.colectionView.reloadData()
                if(selectedIndex == -1){
                    
                    if !SelectedAssets.isEmpty{
                        selectedIndex = SelectedAssets.count - 1
                    }else{
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                        self.imgView.image = nil
                    }
                }
            }
        }else{
            self.imgView.image = nil
        }
        
    }
    
    @IBAction func actnCrop(_ sender: Any)
    {
        self.performSegue(withIdentifier: "showCrop", sender: self.imgView.image)
        
        for i in 0...SelectedAssets.count-1
        {
           // self.showLoader()
            let image = SelectedAssets[i].getImageFromPHAsset()
            finalImageArr.append(image)
        }
       // self.hideLoader()
    }
    
    
    
    @IBOutlet weak var actnUpload: UIImageView!
    
    @IBAction func openGallery(_ sender: Any)
    {
        //self.presenter?.uploadHappyMemoriesData(mediaType: .Image, mediaData: SelectedAssets, imageData: [], location:currentLocation,description:self.txtFldStatus.text)
        
        AddPhotosMemories.vc.maxNumberOfSelections = 5
        bs_presentImagePickerController(AddPhotosMemories.vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
            if(self.SelectedAssets.isEmpty){
                self.navigationController?.popViewController(animated: false)
            }else{
                //self.dismiss(animated: true, completion: nil)
            }
            
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            self.selectedIndex = assets.count - 1
            for i in 0..<assets.count
            {
                self.SelectedAssets.append(assets[i])
                print(self.SelectedAssets)
            }
            self.colectionView.reloadData()
        }, completion: nil)
    }
    
    
    func save_images_offline_for_happy_memories_changes()
    {
        
        let userID = UserDefaults.standard.getUserId() ?? ""
        if (self.SelectedAssets.count > 0)
        {
            for obj in self.SelectedAssets
            {
                let saveDic = NSMutableDictionary()
                
                let image = obj.getImageFromPHAsset()
                let imgData = image.pngData()
                let base64String = imgData?.base64EncodedString()
                
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.audio_path)
                saveDic.setValue("IMAGE", forKey: coreDataKeys_HappyMemories_Changes.group)
                saveDic.setValue("IMAGE", forKey: coreDataKeys_HappyMemories_Changes.type)
                saveDic.setValue(base64String, forKey: coreDataKeys_HappyMemories_Changes.image_data)
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.video_path)
                saveDic.setValue(userID, forKey: coreDataKeys_HappyMemories_Changes.user_id)
                saveDic.setValue(self.btnLocation.titleLabel?.text, forKey: coreDataKeys_HappyMemories_Changes.location)
                saveDic.setValue(self.txtfldAddText.text, forKey: coreDataKeys_HappyMemories_Changes.desc)
                
                DatabaseModel_HappyMemris_Offline_API_DATA.save_HappyMemris_Changes_offline(data_for_save: saveDic)
            }
        }
        
    }
    
    func delete_group_offline_for_happy_memories_changes()//IT WILL DELETE ALL IMAGES AND VIDEOS/AUDIOS -> ALL GROUP AND SAVE NEW VALUE
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY: "IMAGE", success: { (sccss) in
            
            DispatchQueue.main.async {
                self.save_images_offline_for_happy_memories_changes()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        })
        { (err) in
            
            DispatchQueue.main.async {
                self.save_images_offline_for_happy_memories_changes()
                 CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        }
    }
    
    func get_files_for_upload_from_database()
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.get_offline_saved_Happy_memris_for_upload(groupKEY: "IMAGE", success: { (data) in
            var desc = ""
            
            DispatchQueue.main.async {
                
                
                if (data.count > 0)
                {
                    let descDic = data.object(at: 0)as! NSDictionary
                    for obj in data
                    {
                        let dic = obj as! NSDictionary
                        let bas64 = dic.value(forKey: coreDataKeys_HappyMemories_Changes.image_data)as? String ?? ""
                        
                        if (bas64.count > 0)
                        {
                            let img = CommonVc.AllFunctions.decodeImage(base64: bas64)
                            self.databaseArr.append(img)
                        }
                        else
                        {
                            let img = UIImage(named:"currepted")!
                            self.databaseArr.append(img)
                        }
                        self.old_files = true
                    }
                    
                    
                    self.showLoader()
                    
                    let location = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.location)as? String ?? ""
                    desc = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.desc)as? String ?? ""
                    
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Image, mediaData: [], imageData: self.databaseArr, location:location,description:desc)
                    
                }
                
                else
                {
                    self.showLoader()
                    self.old_files = false
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Image, mediaData: [], imageData: self.databaseArr, location:self.btnLocation.titleLabel?.text,description:self.txtfldAddText.text)
                }
                
                
            }
            
        })
        { (err) in
            print(err)
            
            DispatchQueue.main.async {
             
                if (self.databaseArr.count > 0)
                {
                    self.old_files = false
                    self.showLoader()
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Image, mediaData: [], imageData: self.databaseArr, location:self.btnLocation.titleLabel?.text,description:self.txtfldAddText.text)
                }
            }
            
        }
    }
    
    func generate_images()
    {
        if (self.SelectedAssets.count > 0)
        {
            for obj in self.SelectedAssets
            {
                let image = obj.getImageFromPHAsset()
                databaseArr.append(image)
            }
        }
    }
    
    func clear_database_for_uploaded_files()
    {
        CommonVc.AllFunctions.clear_database_for_uploaded_files_happy_memories()
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
}
extension AddPhotosMemories:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return SelectedAssets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        if(indexPath.row == 0){
            cell.imageView.image = UIImage.init(named: "AddMedia")
        }
        else
        {
            let cuurent = SelectedAssets[indexPath.row - 1]
            let image = cuurent.getImageFromPHAsset()
            cell.imageView.image = image
            if(!SelectedAssets.isEmpty)
            {
                let showLastImage  = SelectedAssets.last?.getAssetThumbnail(size: self.imgView.frame.size)
                if(SelectedAssets.isEmpty)
                {
                    self.imgView.image = UIImage(named: "currepted")!
                }
                self.imgView.image = showLastImage
            }
            else
            {
                self.imgView.image = UIImage(named: "currepted")!
            }
        }
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
            let currImage = SelectedAssets[indexPath.row - 1]
            //            let finalImage = currImage.getImageFromPHAsset()
            let finalImage = currImage.getAssetThumbnail(size: imgView.frame.size)
            self.imgView.image = finalImage
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showCrop"
        {
            let yourCropViewController = segue.destination as! CropViewController
            yourCropViewController.image = sender as? UIImage
            yourCropViewController.delegate = self;
        }
    }
}
extension AddPhotosMemories: IGRPhotoTweakViewControllerDelegate
{
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage)
    {
        self.imgView?.image = croppedImage
        self.navigationController?.popViewController(animated: true)
        // _ = controller.navigationController?.popViewController(animated: true)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController)
    {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}


extension AddPhotosMemories:HappyMemoriesCommonDelegate
{
    func HappyMemoriesCommonDidSucceeed(message: String)
    {
       self.hideLoader()
        var mssg = ""
        
        if (self.old_files == true)
        {
            mssg = "Your offline saved Images for Happy Memories has been uploaded successfully!"
            self.handle_success_and_pop_controller(msg: mssg)
        }
        else
        {
            mssg = message
            self.handle_success_and_pop_controller(msg: mssg)
        }
       
       self.clear_database_for_uploaded_files()
    }
    
    func HappyMemoriesCommonDidFailed(message: String)
    {
        self.hideLoader()
        self.showAlert(Message: message )
    }
    
}

extension AddPhotosMemories:HappyMemoriesCommonViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
        self.hideLoader()
    }
    
    func showLoader()
    {
        ShowLoaderCommon()
    }
    
    func hideLoader()
    {
        HideLoaderCommon()
    }
    
    
}


//
//  RecordAudioMemoriesVC.swift
//  IGetHappy
//
//  Created by Gagan on 9/18/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVKit
protocol ReceiveData
{
    func pass(data: URL)  //data: string is an example parameter
}
protocol HappyMemoriesCommonViewDelegate:class
{
    func showAlert(alertMessage: String)
    func showLoader()
    func hideLoader()
    
}

class RecordAudioMemoriesVC: BaseUIViewController,UITextFieldDelegate
{
    var recordAudio = RecordAudioVC()
    var presenter: HappyMemoriesCommonPresenter?
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var txtFldStatus: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var arrAudios = [String]()
    var arrUploads = [String]()
    var currentAudioIndex = Int()
    var audioPlayer : AVAudioPlayer?
    var currentLocation:String?
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        if let location = UserDefaults.standard.getLocation()
//        {
//            currentLocation = location
//
//            self.btnLocation.setTitle(location, for: .normal)
//
//
//        }
        
        
        let location = UserDefaults.standard.getLocation() ?? ""
        self.btnLocation.setTitle(location, for: .normal)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.audioPlayer)
        
        
        self.presenter = HappyMemoriesCommonPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // Do any additional setup after loading the view.
        
        
        self.get_files_for_upload_from_database()//getting saved Audios and uploading them
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        print(arrAudios)
        self.hideLoader()
        
    }
    
    @IBAction func playRecordedAudio(_ sender: Any)
    {
        if(arrAudios.count != 0)
        {
            let url = arrAudios[currentAudioIndex] ?? ""
                
            if (url.count > 0)
            {
                do
                {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(string:arrAudios[currentAudioIndex])!)
                    //8 - Prepare the song to be played
                    audioPlayer?.prepareToPlay()
                    
                }
                catch
                {
                    //handle error
                    print(error)
                }
                
                
                if (btnPlay.tag == 0)
                {
                    btnPlay.tag = 1
                    audioPlayer?.play()
                    self.btnPlay.setBackgroundImage(UIImage.init(named:"pause"), for: UIControl.State.normal)
                }
                else if (btnPlay.tag == 1)
                {
                    btnPlay.tag = 0
                    audioPlayer?.pause()
                    self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
                }
            }
            else
            {
                CommonVc.AllFunctions.show_automatic_hide_alert(controller: self, title: "Sorry! file path is not valid.")
            }
            
            
            
            //            if((audioPlayer) != nil)
            //            {
            //                if(audioPlayer!.isPlaying)
            //                {
            //                    audioPlayer!.pause()
            //                    self.btnPlay.setBackgroundImage(UIImage.init(named:"videoPlay"), for: UIControl.State.normal)
            //                    //btnPlay.setTitle("Play", for: .normal)
            //                }
            //                else
            //                {
            //                    audioPlayer!.play()
            //                    self.btnPlay.setBackgroundImage(UIImage.init(named:"pause"), for: UIControl.State.normal)
            //                    //btnPlay.setTitle("Pause", for: .normal)
            //                }
            //            }
        }
        else
        {
            self.view.makeToast("Please record your voice")
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
    
    @IBAction func close(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func getLocation(_ sender: Any) {
        
    }
    @IBAction func deleteAudio(_ sender: Any)
    {
        btnPlay.tag = 0
        self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
        audioPlayer?.pause()
        if(currentAudioIndex >= 0)
        {
            if(!arrAudios.isEmpty)
            {
                self.arrAudios.remove(at: currentAudioIndex)
                self.currentAudioIndex = currentAudioIndex - 1
                //let lastImage  = SelectedAssets[selectedIndex - 1].getAssetThumbnail(size: self.imgView.frame.size)
                //self.imgView.image = lastImage
                self.collectionView.reloadData()
                if(currentAudioIndex == -1)
                {
                    if !arrAudios.isEmpty
                    {
                        self.currentAudioIndex = arrAudios.count - 1
                    }
                    else
                    {
                        CommonFunctions.sharedInstance.popTocontroller(from:self)
                    }
                    //self.imgView.image = nil
                }
            }
        }
        else
        {
            //self.imgView.image = nil
        }
        
    }
    @IBAction func uploadMemories(_ sender: Any)
    {
        self.view.endEditing(true)
        
        btnPlay.tag = 0
        audioPlayer?.pause()
        self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
        
        CommonVc.AllFunctions.bowDown_view_for_keyboard(view:self.view)
        if (self.arrAudios.count > 5)
        {
            CommonVc.AllFunctions.showAlert(message: "You can not add more than 5 Audios at a time!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        else
        {
            if (CommonVc.AllFunctions.have_internet() == false)
            {
                self.showLoader()
                self.delete_group_offline_for_happy_memories_changes()//delete old save new
            }
            else
            {
                // self.get_files_for_upload_from_database()
                
                self.showLoader()
                self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.arrAudios, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.txtFldStatus.text)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? RecordAudioVC
        {
            destination.delegatePassUrl = self
        }
    }
    
    @objc func playerItemDidPlayToEndTime()
    {
        // load next video or something
        btnPlay.tag = 0
        audioPlayer?.pause()
        self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
    }
    
    func save_audios_offline_for_happy_memories_changes()
    {
        let userID = UserDefaults.standard.getUserId() ?? ""
        if (self.arrAudios.count > 0)
        {
            for obj in self.arrAudios
            {
                let saveDic = NSMutableDictionary()
                var fileName = CommonVc.AllFunctions.generateRandomString()
                fileName = fileName + ".wav"
                CommonVc.AllFunctions.save_file_in_document_directory(pathNew: fileName, fileUrl: URL(string:obj)!)
                saveDic.setValue(fileName, forKey: coreDataKeys_HappyMemories_Changes.audio_path)
                saveDic.setValue("AUDIO", forKey: coreDataKeys_HappyMemories_Changes.group)
                saveDic.setValue("AUDIO", forKey: coreDataKeys_HappyMemories_Changes.type)
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.image_data)
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.video_path)
                saveDic.setValue(userID, forKey: coreDataKeys_HappyMemories_Changes.user_id)
                saveDic.setValue(currentLocation, forKey: coreDataKeys_HappyMemories_Changes.location)
                saveDic.setValue(self.txtFldStatus.text, forKey: coreDataKeys_HappyMemories_Changes.desc)
                
                DatabaseModel_HappyMemris_Offline_API_DATA.save_HappyMemris_Changes_offline(data_for_save: saveDic)
            }
        }
        
    }
    
    func delete_group_offline_for_happy_memories_changes()//IT WILL DELETE ALL IMAGES AND VIDEOS/AUDIOS -> ALL GROUP AND SAVE NEW VALUE
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY: "AUDIO", success: { (sccss) in
            
            DispatchQueue.main.async {
                
                self.save_audios_offline_for_happy_memories_changes()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        })
        { (err) in
            
            DispatchQueue.main.async {
                self.save_audios_offline_for_happy_memories_changes()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        }
    }
    
    
    func get_files_for_upload_from_database()
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.get_offline_saved_Happy_memris_for_upload(groupKEY: "AUDIO", success: { (data) in
            var desc = ""
            
            DispatchQueue.main.async {
                
                
                if (data.count > 0)
                {
                    let descDic = data.object(at: 0)as! NSDictionary
                    for obj in data
                    {
                        let dic = obj as! NSDictionary
                        let path = dic.value(forKey: coreDataKeys_HappyMemories_Changes.audio_path)as? String ?? ""
                        if (path.count > 0)
                        {
                            let fUrl = documentURL().appendingPathComponent(path)
                            self.arrUploads.append(fUrl.absoluteString)
                        }
                    }
                    
                    self.showLoader()
                    
                    let location = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.location)as? String ?? ""
                    desc = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.desc)as? String ?? ""
                    
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.arrUploads, imageData: [], location:location,description:desc)
                }
                    
                else
                {
                    if (self.arrAudios.count > 0)
                    {
                        self.showLoader()
                        self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.arrAudios, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.txtFldStatus.text)
                    }
                }
            }
            
        })
        { (err) in
            print(err)
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
    
}
extension RecordAudioMemoriesVC:UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAudios.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! RecordAudioMemoriesCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        if(indexPath.row == 0){
            cell.imageView.image = UIImage.init(named: "AddMedia")
        }else{
            cell.imageView.image = UIImage.init(named: "audioBG")
            let current = arrAudios[indexPath.row - 1]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            
            Constants.isFromHappyMemories = true
            let navigation = UIStoryboard.init(name: "Auth", bundle: nil)
            // let pickerUserVC = navigation.viewControllers.first as! RecordAudioVC
            //  self.present(navigation, animated: true, completion: nil)
            //Global Variable used for record audio
            
            
            let goNext = navigation.instantiateViewController(withIdentifier: "RecordAudioVC") as! RecordAudioVC
            goNext.delegatePassUrl = self
            self.navigationController?.pushViewController(goNext, animated: true)
            
            //  CommonFunctions.sharedInstance.PresentTocontroller(from: self, ToController: .AudioRecordNav, Data: self)
        }
        else
        {
            currentAudioIndex = indexPath.row - 1
            btnPlay.tag = 0
            audioPlayer?.pause()
            self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
            //Play Audio
            
        }
    }
    
}
extension RecordAudioMemoriesVC:ReceiveData
{
    func pass(data: URL)
    {
        print(arrAudios.count)
        self.arrAudios.append("\(data)")
        self.collectionView.reloadData()
    }
    
}
extension RecordAudioMemoriesVC:HappyMemoriesCommonDelegate
{
    func HappyMemoriesCommonDidSucceeed(message: String)
    {
        self.hideLoader()
        
        if (arrUploads.count > 0)
        {
            self.handle_success_and_pop_controller(msg: "Your offline saved audios for Happy Memories has been uploaded successfully!")
        }
        else
        {
            self.handle_success_and_pop_controller(msg: message)
        }
        
        CommonVc.AllFunctions.clear_database_for_uploaded_files_happy_memories()
    }
    
    func HappyMemoriesCommonDidFailed(message: String)
    {
        self.hideLoader()
        self.showAlert(Message: message)
    }
    
}

extension RecordAudioMemoriesVC:HappyMemoriesCommonViewDelegate{
    func showAlert(alertMessage: String)
    {
        self.hideLoader()
        self.showAlert(Message: alertMessage)
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

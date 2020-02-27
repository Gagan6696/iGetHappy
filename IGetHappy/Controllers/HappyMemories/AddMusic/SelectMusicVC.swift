//
//  SelectMusicVC.swift
//  MultipleImageSelection
//
//  Created by Gagan on 9/12/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.


import UIKit
import MediaPlayer
import AVFoundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    let when = DispatchTime.now() + delay
    DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}

extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}

extension CGVector {
    init (_ dx:CGFloat, _ dy:CGFloat) {
        self.init(dx:dx, dy:dy)
    }
}


class SelectMusicVC: BaseUIViewController,UITextFieldDelegate
{
    var totalCountToStopLoader = Int()
    var countToStopLoader = Int()
    var currentFilename:String?
    var isPaused = false
    var audioPlayer : AVAudioPlayer?
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tfDesc: UITextField!
    var selectedIndex =  Int()
    var presenter: HappyMemoriesCommonPresenter?
    @IBOutlet weak var btnLocation: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    // var arrFetchedMedia = NSMutableArray()
    var filenameArray = NSMutableArray()
    var timer = Timer()
    var savedCount = 0
    var uploadArr = [String]()
    
    var arrFetchedDir = [String]()
    var documentURL = { () -> URL in
        let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentURL
    }
    
    let userID = UserDefaults.standard.getUserId() as? String ?? ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        if let location = UserDefaults.standard.getLocation(){
//            self.btnLocation.setTitle(location, for: .normal)
//        }
        
        let location = UserDefaults.standard.getLocation() ?? "N/A"
        self.btnLocation.setTitle(location, for: .normal)
   
        self.presenter = HappyMemoriesCommonPresenter.init(delegate: self)
        self.presenter?.attachView(view: self)
        // override func viewWillAppear(_ animated: Bool) {
        
        //super.viewWillAppear(animated)
        
        //if(arrFetchedDir.isEmpty){
        //   self.openGallery(self)
        // }else{
        do {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                //10 - Set our session category to playback music
                try audioSession.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
                //11 -
            } catch let sessionError {
                
                print(sessionError)
            }
            //12 -
        } catch let songPlayerError {
            print(songPlayerError)
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource  = self
        self.title = "Music"
        self.collectionView.reloadData()
        // }
        
        
        //        CoreData_Model.get_offline_saved_memories(success: { (arr) in
        //
        //          self.filenameArray = NSMutableArray(array: arr)
        //            DispatchQueue.main.async {
        //                self.collectionView.reloadData()
        //            }
        //
        //        })
        //        { (error) in
        //            print(error)
        //        }
        
        
        self.get_audio_arr_for_upload()
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.audioPlayer?.pause()
        self.audioPlayer = nil
    }
    
    
    @IBAction func play(_ sender: Any)
    {
    
        
       
        

        
        
        self.playmedia(fileName: currentFilename ?? "")
    }
    
    
    @IBAction func actnDelete(_ sender: Any)
    {
        self.audioPlayer?.pause()
        if(selectedIndex >= 0)
        {
            if(!arrFetchedDir.isEmpty){
                print("index no deleted",selectedIndex)
                self.arrFetchedDir.remove(at: selectedIndex)
                self.selectedIndex = selectedIndex - 1
                //let lastImage  = SelectedAssets[selectedIndex - 1].getAssetThumbnail(size: self.imgView.frame.size)
                //self.imgView.image = lastImage
                self.collectionView.reloadData()
                if(selectedIndex == -1){
                    if(!arrFetchedDir.isEmpty)
                    {
                        self.selectedIndex = arrFetchedDir.count - 1
                    }else{
                        CommonFunctions.sharedInstance.popTocontroller(from: self)
                        self.imageView.image = nil
                    }
                }
            }
        }else{
            selectedIndex = self.arrFetchedDir.count - 1
            self.imageView.image = nil
        }
    }
    @IBAction func actionUpload(_ sender: Any)
    {
        self.view.endEditing(true)
        CommonVc.AllFunctions.bowDown_view_for_keyboard(view:self.view)
        if (self.uploadArr.count > 5)
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
               self.get_audio_arr_for_upload()
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
    
    @IBAction func actionDismiss(_ sender: Any)
    {
        CommonFunctions.sharedInstance.popTocontroller(from: self)
    }
    @IBAction func openGallery(_ sender: Any)
    {
        self.presentPicker(sender)
    }
    func presentPicker (_ sender: Any)
    {
        checkForMusicLibraryAccess
            {
                let picker = MPMediaPickerController(mediaTypes:.music)
                
                picker.showsCloudItems = false
                picker.delegate = self
                picker.allowsPickingMultipleItems = true
                
                picker.modalPresentationStyle = .fullScreen
                picker.preferredContentSize = CGSize(500,600)
                self.present(picker, animated: false)
                if let pop = picker.popoverPresentationController {
                    if let b = sender as? UIBarButtonItem {
                        pop.barButtonItem = b
                    }
                }
        }
    }
    
    func playmedia(fileName:String)
    {
        if (fileName.count > 0)
        {
            
            let outputURL = documentURL().appendingPathComponent(fileName)
            print("OutURL->\(outputURL)")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: outputURL)
                //8 - Prepare the song to be played
                audioPlayer!.prepareToPlay()
                
            } catch {
                //handle error
                print(error)
            }
            
            
            if (btnPlay.tag == 0)
            {
               // audioPlayer = AVAudioPlayer()
                btnPlay.tag = 1
                audioPlayer?.play()
                isPaused = false
                self.btnPlay.setBackgroundImage(UIImage.init(named:"pause"), for: UIControl.State.normal)
            }
            else if (btnPlay.tag == 1)
            {
                btnPlay.tag = 0
                audioPlayer!.pause()
                isPaused = true
                self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
            }
        }
        else
        {
           
            CommonVc.AllFunctions.showAlert(message: "Please select a file!", view: self, title: Constants.Global.ConstantStrings.KAppname)
        }
        
        
        
        
        
        
        
        
//        if((audioPlayer) != nil){
//            if(audioPlayer!.isPlaying){
//                audioPlayer!.pause()
//                isPaused = true
//                btnPlay.setImage(UIImage.init(named: "play"), for: .normal)
//                //btnPlay.setTitle("Play", for: .normal)
//            }else{
//                audioPlayer!.play()
//                isPaused = false
//                btnPlay.setImage(UIImage.init(named: "pause"), for: .normal)
//                //btnPlay.setTitle("Pause", for: .normal)
//            }
//        }
    }
    
    
    
    
    
    func save_Music_offline_for_happy_memories_changes()
    {
        if (self.filenameArray.count > 0)
        {
            let dic = self.filenameArray.object(at: 0)as! NSDictionary
            let usrID = dic.value(forKey: coreDataKeys_HappyMemories.user_id)as? String ?? ""
            let location = dic.value(forKey: coreDataKeys_HappyMemories_Changes.location)as? String ?? ""
            let desc = "Here is my new music"
            
            for obj in self.filenameArray
            {
                
                let dic = obj as! NSDictionary
                let path = dic.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                //let outputURL = documentURL().appendingPathComponent(path)
                let saveDic = NSMutableDictionary()
                
                saveDic.setValue(path, forKey: coreDataKeys_HappyMemories_Changes.audio_path)
                saveDic.setValue("AUDIO", forKey: coreDataKeys_HappyMemories_Changes.group)
                saveDic.setValue("AUDIO", forKey: coreDataKeys_HappyMemories_Changes.type)
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.image_data)
                saveDic.setValue("", forKey: coreDataKeys_HappyMemories_Changes.video_path)
                saveDic.setValue(usrID, forKey: coreDataKeys_HappyMemories_Changes.user_id)
                saveDic.setValue(location, forKey: coreDataKeys_HappyMemories_Changes.location)
                saveDic.setValue(desc, forKey: coreDataKeys_HappyMemories_Changes.desc)
                
                DatabaseModel_HappyMemris_Offline_API_DATA.save_HappyMemris_Changes_offline(data_for_save: saveDic)
            }
        }
        
    }
    
    func delete_group_offline_for_happy_memories_changes()//IT WILL DELETE ALL IMAGES AND VIDEOS/AUDIOS -> ALL GROUP AND SAVE NEW VALUE
    {
        DatabaseModel_HappyMemris_Offline_API_DATA.delete_DATA_FROM_coreData_for_HappyMemoris_Changes(groupKEY: "AUDIO", success: { (sccss) in
            
            DispatchQueue.main.async {
                
                self.save_Music_offline_for_happy_memories_changes()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        })
        { (err) in
            
            DispatchQueue.main.async {
                self.save_Music_offline_for_happy_memories_changes()
                CommonVc.AllFunctions.showAlert(message: Constants.Global.ConstantStrings.KImages_saved_offline, view: self, title: Constants.Global.ConstantStrings.KAppname)
                self.hideLoader()
            }
            
        }
    }
    
    
    func get_audio_arr_for_upload()
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
                        let finalPath = CommonVc.AllFunctions.get_file_from_document_dirctory(fileName: path)
                        let furl = URL(fileURLWithPath: finalPath)
                        self.uploadArr.append(furl.absoluteString)
                    }
                    
                    self.showLoader()
                    
                    let location = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.location)as? String ?? ""
                    desc = descDic.value(forKey: coreDataKeys_HappyMemories_Changes.desc)as? String ?? ""
                    
                    self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.uploadArr, imageData: [], location:location,description:desc)
                }
                    
                else
                {
                    if (self.uploadArr.count > 0)
                    {
                        self.showLoader()
                        self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.uploadArr, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.tfDesc.text)
                    }
                    else
                    {
                        self.get_selected_music()
                    }
                }
            }
            
        })
        { (err) in
            print(err)
            self.get_selected_music()
        }
    }
    
    func get_selected_music()
    {
        if (self.filenameArray.count > 0)
        {
            for obj in self.filenameArray
            {
                let dic = obj as! NSDictionary
                let path = dic.value(forKey: coreDataKeys_HappyMemories.url)as? String ?? ""
                let outputURL = documentURL().appendingPathComponent(path)
                self.uploadArr.append(outputURL.absoluteString)
            }
            
            self.showLoader()
            self.presenter?.uploadHappyMemoriesData(mediaType: .Audio, mediaData: self.uploadArr, imageData: [], location:self.btnLocation.titleLabel?.text,description:self.tfDesc.text)
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

extension SelectMusicVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrFetchedDir.count + 1
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectMusicCollectionViewCell", for: indexPath as IndexPath) as! SelectMiusicCollectionViewCell
        self.selectedIndex = arrFetchedDir.count - 1
        // cell.lblMediaName.text = ((arrFetchedMedia[indexPath.row] as! [String:Any])["title"] as! String)
        // cell.lblSizeName.text = ((arrFetchedMedia[indexPath.row] as! [String:Any])["size"] as! String)
        
        if(indexPath.row == 0){
            cell.imageView.image = UIImage.init(named: "AddMedia")
        }else{
            cell.imageView.image = UIImage.init(named: "audioBG")
            //let image  = (arrFetchedMedia[indexPath.row] as! [String:Any])["image"] as!  MPMediaItemArtwork
            
            //cell.imageView.image = image.image(at: CGSize(width: 50, height: 50))
        }
        
       
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if((audioPlayer) != nil)
        {
            if(audioPlayer!.isPlaying)
            {
                audioPlayer!.pause()
                isPaused = true
                self.btnPlay.setBackgroundImage(UIImage.init(named: "play"), for: .normal)
                //btnPlay.setTitle("Play", for: .normal)
            }
        }
        selectedIndex = indexPath.row - 1
        if(indexPath.row == 0)
        {
            openGallery(self)
        }
        else
        {
            let dic = filenameArray.object(at: indexPath.row-1)as? NSDictionary
            currentFilename = dic?.value(forKey: coreDataKeys_HappyMemories.url) as? String ?? ""
        }
        
        
        btnPlay.tag = 0
        isPaused = true
        self.btnPlay.setBackgroundImage(UIImage.init(named:"play"), for: UIControl.State.normal)
    }
}

extension SelectMusicVC : MPMediaPickerControllerDelegate
{
    // must implement these, as there is no automatic dismissal
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection)
    {
        //self.view.showBlurLoader()
        DispatchQueue.main.async {
            self.ShowLoaderCommon()
        }
        
        for tempItem in mediaItemCollection.items
        {
            
            var dict = [String:Any]()
            let item: MPMediaItem = tempItem
            let pathURL: URL? = item.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
            if pathURL == nil {
                print("Picking Error")
                return
            }
            let songAsset = AVURLAsset(url: pathURL!, options: nil)
            let tracks = songAsset.tracks(withMediaType: .audio)
            if(tracks.count > 0){
                let track = tracks[0]
                if(track.formatDescriptions.count > 0){
                    let desc = track.formatDescriptions[0]
                    let audioDesc = CMAudioFormatDescriptionGetStreamBasicDescription(desc as! CMAudioFormatDescription)
                    let formatID = audioDesc?.pointee.mFormatID
                    
                    var fileType:NSString?
                    var ex = ""
                    
                    switch formatID {
                    case kAudioFormatLinearPCM:
                        print("wav or aif")
                        let flags = audioDesc?.pointee.mFormatFlags
                        if( (flags != nil) && flags == kAudioFormatFlagIsBigEndian ){
                            fileType = "public.aiff-audio"
                            ex = "aif"
                        }else{
                            fileType = "com.microsoft.waveform-audio"
                            ex = "wav"
                        }
                        
                    case kAudioFormatMPEGLayer3:
                        print("mp3")
                        fileType = "com.apple.quicktime-movie"
                        ex = "mp3"
                        break;
                        
                    case kAudioFormatMPEG4AAC:
                        print("m4a")
                        fileType = "com.apple.m4a-audio"
                        ex = "m4a"
                        break;
                        
                    case kAudioFormatAppleLossless:
                        print("m4a")
                        fileType = "com.apple.m4a-audio"
                        ex = "m4a"
                        break;
                        
                    default:
                        break;
                    }
                    
                    let exportSession = AVAssetExportSession(asset: AVAsset(url: pathURL!), presetName: AVAssetExportPresetAppleM4A)
                    exportSession?.shouldOptimizeForNetworkUse = true
                    exportSession?.outputFileType = AVFileType.m4a ;
                    var fileName = item.value(forProperty: MPMediaItemPropertyTitle) as! String
                    var fileNameArr = NSArray()
                    fileNameArr = fileName.components(separatedBy: " ") as NSArray
                    fileName = fileNameArr.componentsJoined(by: "")
                    fileName = fileName.replacingOccurrences(of: ".", with: "")
                    fileName = fileName.replacingOccurrences(of: ")", with: "")
                    fileName = fileName.replacingOccurrences(of: "(", with: "")
                    
                    
                    let dic = NSMutableDictionary()
                    let tableID = CommonVc.AllFunctions.generateRandomString()
                    let location = UserDefaults.standard.getLocation()
                    
                    //MAKING OBJ FOR STORE DATA USING SAME APROACH LIKE IMAGES AND VIDEOS
                    dic.setValue("audio", forKey: coreDataKeys_HappyMemories.type)
                    dic.setValue("aud", forKey: coreDataKeys_HappyMemories.name)
                    dic.setValue("", forKey: coreDataKeys_HappyMemories.phasst)
                    dic.setValue(fileName + ".m4a", forKey: coreDataKeys_HappyMemories.url)
                    dic.setValue("", forKey: coreDataKeys_HappyMemories.asset)
                    dic.setValue(tableID, forKey: coreDataKeys_HappyMemories.table_id)
                    dic.setValue(self.userID, forKey: coreDataKeys_HappyMemories.user_id)
                    dic.setValue(location, forKey: coreDataKeys_HappyMemories.location)
                    
                    self.filenameArray.add(dic)
                    //    self.save_audios_in_database(objDic: dic)
                    
                    
                    let outputURL = documentURL().appendingPathComponent("\(fileName).m4a")
                    arrFetchedDir.append("\(outputURL)")
                    do {
                        try FileManager.default.removeItem(at: outputURL)
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    exportSession?.outputURL = outputURL
                    
                    totalCountToStopLoader = self.arrFetchedDir.count
                    
                    
                    exportSession?.exportAsynchronously(completionHandler: { () -> Void in
                        
                        if exportSession!.status == AVAssetExportSession.Status.completed
                        {
                            self.countToStopLoader = self.countToStopLoader + 1
                            
                            if(self.countToStopLoader == self.totalCountToStopLoader){
                                DispatchQueue.main.async {
                                //let dic = self.filenameArray.object(at: 0)as? NSDictionary
                                    
                                    if self.arrFetchedDir.count > 0{
                                        let theFileName =  URL.init(string: self.arrFetchedDir[0])?.lastPathComponent
                                        
                                        // self.arrFetchedDir[0].lastPathComponent
                                        self.currentFilename = "\(theFileName ?? "")"
                                        self.HideLoaderCommon()
                                    }
                                  
                                }
                            }
                            print("Export Successfull")
 
                        }
                        else
                        {
                            
                            print("Export failed")
                            print(exportSession!.error as Any)
                            DispatchQueue.main.async {
                                self.HideLoaderCommon()
                            }
                        }
                    })
                }
            }
            
            self.collectionView.reloadData()
        }
        
        mediaPicker.dismiss(animated:false)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        print("cancel")
        if(arrFetchedDir.isEmpty){
            //self.dismiss(animated:true)
            mediaPicker.dismiss(animated: false) {
                CommonFunctions.sharedInstance.popTocontroller(from: self)
            }
            
        }else{
            self.collectionView.reloadData()
            mediaPicker.dismiss(animated:false)
        }
        
        
    }
    
    
    
    func save_audios_in_database(objDic:NSMutableDictionary)
    {
        
        CoreData_Model.save_memories_offline_in_coreData(data_for_save: objDic, success: { (result) in
            print(result)
            
            self.savedCount = self.savedCount+1
            if (self.savedCount >= self.filenameArray.count)
            {
                self.savedCount = 0
            }
            
            
            
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                //  self.HideLoaderCommon()
                // self.collectionView.reloadData()
            }
        }
    }
    
}
extension MPMediaItem{
    
    // Value is in Bytes
    var fileSize: Int{
        get{
            if let size = self.value(forProperty: "fileSize") as? Int{
                return size
            }
            return 0
        }
    }
    
    var fileSizeString: String{
        let formatter = Foundation.NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        //Byte to MB conversion using 1024*1024 = 1,048,567
        return (formatter.string(from: NSNumber(value: Float(self.fileSize)/1048567.0)) ?? "0") + " MB"
    }
    
}
extension SelectMusicVC:HappyMemoriesCommonDelegate{
    func HappyMemoriesCommonDidSucceeed(message: String)
    {
        hideLoader()
        self.handle_success_and_pop_controller(msg: message)
        CommonVc.AllFunctions.clear_database_for_uploaded_files_happy_memories()
    }
    
    func HappyMemoriesCommonDidFailed(message: String)
    {
        hideLoader()
        self.showAlert(Message: message )
    }
    
}

extension SelectMusicVC:HappyMemoriesCommonViewDelegate
{
    func showAlert(alertMessage: String)
    {
        self.showAlert(Message: alertMessage)
    }
    
    func showLoader()
    {
        ShowLoaderCommon()
    }
    
    func hideLoader() {
        HideLoaderCommon()
    }
    
    
}

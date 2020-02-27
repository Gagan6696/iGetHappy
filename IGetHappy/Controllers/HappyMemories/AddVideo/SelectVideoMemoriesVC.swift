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
class SelectVideoMemoriesVC: BaseUIViewController
{
    let locationmanger = CLLocationManager()
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var arrVideos = [PHAsset]()
    var selectedIndex = Int()
    override func viewDidLoad()
    {
        super.viewDidLoad()
          getCurrentLatLon(vc: self,obj:locationmanger)
        
    }
   
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        
      
    }
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // If status has not yet been determied, ask for authorization
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    @IBAction func openGallery(_ sender: Any) {
        var config = TatsiConfig.default
        config.showCameraOption = true
        config.supportedMediaTypes = [.video]
        config.firstView = .userLibrary
        config.maxNumberOfSelections = 2
        
        let pickerViewController = TatsiPickerViewController(config: config)
        pickerViewController.pickerDelegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    func playVideoViaAssets (asset:PHAsset) {
        
        guard (asset.mediaType == PHAssetMediaType.video)
            
            else {
                print("Not a valid video media type")
                return
        }
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
            DispatchQueue.main.async {
                
                let asset = asset as? AVURLAsset
                let player = AVPlayer(url: asset!.url)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                
                self.addChild(playerViewController)
                
                // Add your view Frame
                playerViewController.view.frame = self.videoView.frame
                
                // Add sub view in your view
                self.view.addSubview(playerViewController.view)
                playerViewController.player?.play()
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player?.play()
//                }
            }
        })
    }
    
}
extension SelectVideoMemoriesVC: TatsiPickerViewControllerDelegate
{
    
    func pickerViewController(_ pickerViewController: TatsiPickerViewController, didPickAssets assets: [PHAsset]) {
        pickerViewController.dismiss(animated: true, completion: nil)
        print("Assets \(assets)")
        arrVideos = assets
    }
    
}
extension SelectVideoMemoriesVC:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrVideos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = self.collectionView.dequeueReusableCell(withReuseIdentifier: SelectVideoMemoriesCell.className, for: indexPath) as! SelectVideoMemoriesCell
        if(indexPath.row == 0){
            cell.imgView.image = UIImage.init(named: "AddMedia")
        }else{
            cell.imgView.image = UIImage.init(named: "videoPlay")
        }
//cell.imgView.image = arrVideos[indexPath.row - 1].getAssetThumbnail(size: cell.imgView!.frame.size)
        //cell.imgView.image = UIImage.init(named: "play")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            openGallery(self)
        }
        else
        {
            selectedIndex = indexPath.row - 1
            let currImageVideo = arrVideos[indexPath.row - 1]
            self.playVideoViaAssets(asset: currImageVideo)
            //            let finalImage = currImage.getImageFromPHAsset()
//            let finalImage = currImage.getAssetThumbnail(size: imgView.frame.size)
//            self.imgView.image = finalImage
            
        }
        
    }
}
extension SelectVideoMemoriesVC:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       // print("locations = \(locValue.latitude) \(locValue.longitude)")
        locationmanger.stopUpdatingLocation()
        fetchCityAndCountry(from: locations[0]) { (city, Country, error) in
            if((error) == nil){
                print(city)
                print(Country)
                
                
            }else{
                print(error?.localizedDescription)
            }
        }
        
    }
}

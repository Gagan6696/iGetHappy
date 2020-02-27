//
//  PHAssets.swift
//  MultipleImageSelection
//
//  Created by Gagan on 8/28/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//


import PhotosUI
import Photos


var documentURL = { () -> URL in
    let documentURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    return documentURL
}


extension PHAsset {
    
    // MARK: - Public methods
    
    func getAssetThumbnail(size: CGSize) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: self, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: {(result, info)->Void in
           // thumbnail = result!
            
            if result == nil
            {
                thumbnail = UIImage(named: "currepted")!
            }
            else
            {
                thumbnail = result!
            }
        })
        return thumbnail
    }
    
    func getOrginalImage(complition:@escaping (UIImage) -> Void) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: option, resultHandler: {(result, info)->Void in
            image = result!
            complition(image)
        })
    }
    
    func getImageFromPHAsset() -> UIImage
    {
        var image = UIImage()
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = PHImageRequestOptionsResizeMode.exact
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestOptions.isSynchronous = true
        if (self.mediaType == PHAssetMediaType.image)
        {
            PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: requestOptions, resultHandler: { (pickedImage, info) in
                if pickedImage != nil
                {
                     image = pickedImage!
                }
                else
                {
                    image = UIImage(named: "currepted")!
                }
            })
        }
        return image
    }
    
    func convertPhassetIntoUrl(myasset:PHAsset, callBack: @escaping (_ url: URL?) -> Void)
    {
        
        PHCachingImageManager().requestAVAsset(forVideo: myasset, options: nil) { (asset, audioMix, args) in
            if let asset = asset as? AVURLAsset
            {
                callBack(asset.url)
            }
            else
            {
                callBack(nil)
            }
        }
    }
    
    
}

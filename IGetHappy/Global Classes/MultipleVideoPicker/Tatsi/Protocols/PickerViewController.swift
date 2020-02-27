//
//  AssetsPickerViewController.swift
//  Tatsi
//
//  Created by Rens Verhoeven on 06/07/2017.
//  Copyright © 2017 Awkward BV. All rights reserved.
//

import Foundation
import Photos

protocol PickerViewController {
    
    var pickerViewController: TatsiPickerViewController? { get }
    
    var config: TatsiConfig? { get }
    
    func finishPicking(with assets: [PHAsset])
    
    func cancelPicking()
    
}

extension PickerViewController where Self: UIViewController {
    
    var pickerViewController: TatsiPickerViewController? {
        return self.navigationController as? TatsiPickerViewController
    }
    
    var config: TatsiConfig? {
        return self.pickerViewController?.config
    }
    
    var delegate: TatsiPickerViewControllerDelegate? {
        return self.pickerViewController?.pickerDelegate
    }
    
    
    func finishPicking(with assets: [PHAsset])
    {
        guard let viewController = self.pickerViewController else
        {
            return
        }
        
        
        self.delegate?.pickerViewController(viewController, didPickAssets: assets)
        
//        var assArr = [PHAsset]()
//        var ping = Int()
//
//        for ass in assets
//        {
//
//
//                PHCachingImageManager().requestAVAsset(forVideo: ass, options: nil)
//                { (asset, audioMix, args) in
//
//                    ping = ping+1
//                    if let assetnew = asset as? AVURLAsset
//                    {
//                        let dura = CommonVc.AllFunctions.convert_asset_duration(asset: assetnew)
//
//                        if (dura <= 30)
//                        {
//                            assArr.append(ass)
//                        }
//                    }
//                    else
//                    {
//                        if (ass.mediaType.rawValue == 1)
//                        {
//                            assArr.append(ass)
//                        }
//                    }
//
//                    if (ping >= assets.count)
//                    {
//                        DispatchQueue.main.async {
//                            self.delegate?.pickerViewController(viewController, didPickAssets: assArr)
//                        }
//
//                    }
//                }
//
//
//        }
        
    }
    
    func cancelPicking() {
        guard let viewController = self.pickerViewController else {
            return
        }
        self.delegate?.pickerViewControllerDidCancel(viewController)
    }
    
}

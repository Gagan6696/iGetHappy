//
//  HappyMemoriesImageCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/24/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HappyMemoriesImageCell: UICollectionViewCell {
    
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var ViewForVideo: UIView!
    
    func downloadImage(from url: URL)
    {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.ImgView.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}



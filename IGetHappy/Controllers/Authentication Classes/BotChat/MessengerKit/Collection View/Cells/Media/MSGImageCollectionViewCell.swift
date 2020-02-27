//
//  MSGImageCollectionViewCell.swift
//  MessengerKit
//
//  Created by Stephen Radford on 11/06/2018.
//  Copyright © 2018 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import Foundation

var imageCache = NSCache<NSString, UIImage>()

class MSGImageCollectionViewCell: MSGMessageCell {
    
   // @IBOutlet var imgViewPlay: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    var isVideo = false
    override public var message: MSGMessage? {
        didSet {
            
            guard let message = message else {
                return
            }
            
            for subview in self.imageView.subviews {
                if subview is UIImageView {
                    subview.removeFromSuperview()
                 }
            }
            
            if case let MSGMessageBody.image(image) = message.body {
               // AppImages.NoPostsImage
                imageView.image = image
            } else if case let MSGMessageBody.imageFromUrl(imageUrl) = message.body {
                activityIndicator.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
                imageView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                imageView.image = UIImage(named: "NoPostsImage")
                self.downloadImage(from: imageUrl)
            }
            else if case let MSGMessageBody.video(thumbUrl, videoUrl) = message.body {
                print(videoUrl)
                isVideo = true
                activityIndicator.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
                imageView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                imageView.image = UIImage(named: "NoPostsImage")
             
                           self.downloadImage(from: thumbUrl)
                       }
            
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
      private func downloadImage(from url: URL) {
        print(url)
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
         //   completion(cachedImage, nil)
          //  self.imageView.image = cachedImage
            DispatchQueue.main.async {
                                let imgView = UIImageView()
                                                            imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                                                            imgView.image = UIImage(named: "Play")//Assign image to ImageView
                                                            imgView.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
                                              imgView.image = UIImage(named: "VideoPlayIcon")
                                if(self.isVideo == true)
                                {
                                    self.isVideo = false
                                   self.imageView.addSubview(imgView)
                                }
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.removeFromSuperview()
                               self.imageView.image = cachedImage
                              }

        } else {
            MTAPIClient.downloadData(url: url) { data, response, error in
                if let error = error {

                print(error)
                } else if let data = data, let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)

                      let imgView = UIImageView()
                                                  imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                                                  imgView.image = UIImage(named: "Play")//Assign image to ImageView
                                                  imgView.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
                                    imgView.image = UIImage(named: "VideoPlayIcon")
                      if(self.isVideo == true)
                      {
                          self.isVideo = false
                         self.imageView.addSubview(imgView)
                      }
                      self.activityIndicator.stopAnimating()
                      self.activityIndicator.removeFromSuperview()
                     self.imageView.image = image
                    }
                  //  completion(image, nil)
                } else {
                   // completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                }
            }
        }
    }
    
//    private func downloadImage(from url: URL) {
//        print("Download Started")
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            DispatchQueue.main.async() {
//                let imgView = UIImageView()
//                                            imgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//                                            imgView.image = UIImage(named: "Play")//Assign image to ImageView
//                                            imgView.center = CGPoint(x: self.imageView.frame.width / 2, y: self.imageView.frame.height / 2)
//                              imgView.image = UIImage(named: "VideoPlayIcon")
//                if(self.isVideo == true)
//                {
//                    self.isVideo = false
//                   self.imageView.addSubview(imgView)
//                }
//                self.activityIndicator.stopAnimating()
//                self.activityIndicator.removeFromSuperview()
//                self.imageView.image = UIImage(data: data)
//            }
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
    }

}

typealias JSON1 = [String : Any]

extension NSError {
    static func generalParsingError(domain: String) -> Error {
        return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
    }
}

class MTAPIClient {
    
    //MARK: - Public
    
    static func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            MTAPIClient.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                }
            }
        }
    }
    
    static func search(for query: String, page: Int, completion: @escaping (_ responseObject: [String : Any]?, _ error: Error?) -> Void) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string:"http://www.omdbapi.com/?s=\(encodedQuery)&page=\(page)") {
            MTAPIClient.downloadData(url: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    if let data = data, let responseObject = self.convertToJSON(with: data) {
                        completion(responseObject, nil)
                    } else {
                        completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                    }
                }
            }
        }
    }
    
    //MARK: - Private
    fileprivate static func downloadData(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    fileprivate static func convertToJSON(with data: Data) -> JSON1? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON1
        } catch {
            return nil
        }
    }
}

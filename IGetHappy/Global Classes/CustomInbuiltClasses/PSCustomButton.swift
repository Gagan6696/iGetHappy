//
//  PSCustomButton.swift
//  IGetHappy
//
//  Created by Prabhjot Singh on 01/11/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class PSCustomButton: UIButton {
    
    @IBInspectable var leftImg: UIImage? = nil {
        didSet {
            /* reset title */
            setAttributedTitle()
        }
    }
    
    @IBInspectable var rightImg: UIImage? = nil {
        didSet {
            /* reset title */
            setAttributedTitle()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var cornerRadiusByHeight: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.height/2
        }
    }
    
    @IBInspectable var roundButton: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.size.width / 2
            self.clipsToBounds = true
            self.layer.masksToBounds = true
        }
    }
    
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        
        didSet {
            
            layer.shadowColor = shadowColor.cgColor
            layer.masksToBounds = false
        }
    }
    
    
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        
        didSet {
            
            layer.shadowOpacity = Float(shadowOpacity.hashValue)
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        
        didSet {
            
            layer.shadowOpacity = Float(shadowRadius.hashValue)
            layer.masksToBounds = false
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setAttributedTitle() {
        var attributedTitle = NSMutableAttributedString()
        
        /* Attaching first image */
        if let leftImg = leftImg {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = leftImg
            
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            if let title = self.currentTitle {
                mutableAttributedString.append(NSAttributedString(string: title))
                
            }
            self.titleLabel?.textAlignment = NSTextAlignment.center
            attributedTitle = mutableAttributedString
//            alignTextBelow()
            
        }
        
        /* Attaching second image */
        if let rightImg = rightImg {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = rightImg
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            attributedTitle.append(mutableAttributedString)
        }
        
        /* Finally, lets have that two-imaged button! */
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    func alignTextBelow(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            //let imageSize: CGSize = image.size
            //self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            //self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
}

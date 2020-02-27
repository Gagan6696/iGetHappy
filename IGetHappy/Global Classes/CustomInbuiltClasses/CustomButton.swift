//
//  CustomButton.swift
//  BidJones
//
//  Created by Rakesh Kumar on 3/22/18.
//  Copyright © 2018 Seasia. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable public class CustomButton: UIButton {
    
    var corRadius = CGFloat()
    let border = CALayer()
    
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
   
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            setup()
        }
    }
    
    func setup() {
        border.borderColor = self.borderColor?.cgColor
        
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAttributedTitle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributedTitle()
    }


    override public func layoutSubviews() {
        super.layoutSubviews()

        updateCornerRadius()
    }
    
   
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }

    func updateCornerRadius() {
        //layer.cornerRadius = rounded ? frame.size.height / 2 : corRadius
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.masksToBounds = true
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
            attributedTitle = mutableAttributedString
             alignTextBelow()
            
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
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
   //gagan
    
    
    
    
    
    
}




//
//  UIImageView.swift
//  IGetHappy
//
//  Created by Gagan on 5/9/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    func setRounded()
    {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
    }
   
    func maskWith(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
    
    
   
}
extension UIImageView {
    @IBInspectable
    var changeColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!);
            return color
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
}
extension UIImage {
    
    func maskWithColor( color:UIColor) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        color.setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let rect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)

        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return coloredImage!
    }
    
    
    
}

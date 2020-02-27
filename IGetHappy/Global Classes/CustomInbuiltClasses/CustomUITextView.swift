//
//  CustomUITextView.swift
//  BidJones
//
//  Created by Rakesh Kumar on 6/28/18.
//  Copyright © 2018 Seasia. All rights reserved.
//


import Foundation
import UIKit


@IBDesignable public class CustomUITextView: UITextView {
    
    //  var pdng = CGFloat()
    // let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
}
}

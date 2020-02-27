//
//  UIButton.swift
//  IGetHappy
//
//  Created by Gagan on 11/29/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
extension UIButton {
    func hasImage(named imageName: String, for state: UIControl.State) -> Bool {
        guard let buttonImage = image(for: state), let namedImage = UIImage(named: imageName) else {
            return false
        }
        return buttonImage.pngData() == namedImage.pngData()
    }
    
    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}




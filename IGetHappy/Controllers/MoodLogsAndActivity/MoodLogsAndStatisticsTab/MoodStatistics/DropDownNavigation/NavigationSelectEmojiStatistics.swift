//
//  NavigationSelectEmojiStatistics.swift
//  IGetHappy
//
//  Created by Gagan on 12/19/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation

import BottomPopup

class NavigationSelectEmojiStatistics: BottomPopupNavigationController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    
    
    override func getPopupHeight() -> CGFloat {
        return height ?? self.view.frame.height/2
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(5)
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 0.5
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 0.5
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
}

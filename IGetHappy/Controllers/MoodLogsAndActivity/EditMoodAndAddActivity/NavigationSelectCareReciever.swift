//
//  NavigationSelectCareReciever.swift
//  IGetHappy
//
//  Created by Gagan on 10/23/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit
import BottomPopup

class NavigationSelectCareReciever: BottomPopupNavigationController {
    
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

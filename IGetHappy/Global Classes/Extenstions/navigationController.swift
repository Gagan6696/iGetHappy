//
//  navigationController.swift
//  IGetHappy
//
//  Created by Gagan on 1/13/20.
//  Copyright © 2020 AditiSeasia Infotech. All rights reserved.
//

import Foundation

extension UINavigationController {
    func getPreviousViewController() -> UIViewController? {
        let count = viewControllers.count
        guard count > 1 else { return nil }
        return viewControllers[count - 2]
    }
}

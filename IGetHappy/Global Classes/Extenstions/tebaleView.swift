//
//  tebaleView.swift
//  IGetHappy
//
//  Created by Gagan on 12/5/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
extension UITableView
{
    
    func setEmptyMessage(_ message: String)
    {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore()
    {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

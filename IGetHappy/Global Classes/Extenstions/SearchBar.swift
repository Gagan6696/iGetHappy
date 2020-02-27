//
//  SearchBar.swift
//  IGetHappy
//
//  Created by Gagan on 12/18/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import Foundation
extension UISearchBar
{
    func setPlaceholderTextColorTo(color: UIColor)
    {
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = color
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = color
    }
}

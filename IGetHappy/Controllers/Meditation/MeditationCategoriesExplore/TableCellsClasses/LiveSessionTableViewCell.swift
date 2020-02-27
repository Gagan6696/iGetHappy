//
//  LiveSessionTableViewCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//

import UIKit

class LiveSessionTableViewCell : UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
}

extension LiveSessionTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveSessionCollectionViewCell.className, for: indexPath) as! LiveSessionCollectionViewCell
        cell.imageView.layer.cornerRadius = 30
        return cell
    }
    
}

extension LiveSessionTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = 128
        let itemHeight = 123
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

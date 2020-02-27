//
//  MeditateCatTableViewCell.swift
//  IGetHappy
//
//  Created by Gagan on 9/30/19.
//  Copyright © 2019 AditiSeasia Infotech. All rights reserved.
//


import UIKit

class MeditateCatTableViewCell : UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
}

extension MeditateCatTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeditateCatCollectionViewCell", for: indexPath) as! MeditateCatCollectionViewCell
        cell.imageView.backgroundColor = UIColor.blue
        cell.imageView.layer.cornerRadius = 40
        return cell
    }
}

extension MeditateCatTableViewCell : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width  - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize + 15)
    }
    
}

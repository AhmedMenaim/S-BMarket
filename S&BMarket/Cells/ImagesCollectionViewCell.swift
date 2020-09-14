//
//  ImagesCollectionViewCell.swift
//  S&BMarket
//
//  Created by Crypto on 8/25/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionViewImageViewOutlet: UIImageView!
    
    func setupCollectionImage (myImaage: UIImage){
        collectionViewImageViewOutlet.image = myImaage
    }
}

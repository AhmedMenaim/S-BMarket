//
//  HomeCell.swift
//  S&BMarket
//
//  Created by Crypto on 8/19/20.
//  Copyright © 2020 Crypto. All rights reserved.
//


import UIKit

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    @IBOutlet weak var categoryImageOutlet: UIImageView!
    
    func generateCell (_ category: Category){
        categoryNameLabel.text = category.CategoryName
        categoryImageOutlet.image = category.CategoryImage
        categoryNameLabel.numberOfLines = 0
    }
    
}

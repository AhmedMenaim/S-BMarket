//
//  ItemsCell.swift
//  S&BMarket
//
//  Created by Crypto on 8/20/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit

class ItemsCell: UITableViewCell {

    @IBOutlet weak var itemImageViewOutlet: UIImageView!
    @IBOutlet weak var itemNameLblOutlet: UILabel!
    @IBOutlet weak var itemDescriptionLblOutlet: UILabel!
    @IBOutlet weak var itemPriceLblOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateItemCell (myItem: Item){
        itemNameLblOutlet.text = myItem.itemName
        itemPriceLblOutlet.text = currencyConverter(myItem.itemPrice)
        itemPriceLblOutlet.adjustsFontSizeToFitWidth = true
        itemDescriptionLblOutlet.text = myItem.itemDescription
        if myItem.imageLinks != nil && myItem.imageLinks.count > 0 {
            downloadImages(imageURLs: [myItem.imageLinks.first!]) { (images) in
                self.itemImageViewOutlet?.image = images.first as? UIImage
            }
        }
    }

}

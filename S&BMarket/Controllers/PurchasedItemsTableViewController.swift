//
//  PurchasedItemsTableViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/3/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class PurchasedItemsTableViewController: UITableViewController {
    
    
    // MARK: - Vars
    var purchasedItemsArray: [Item] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
            loadPurchasedItems()
        
    }
    
    // MARK: - Load Purchased Items
    
    private func loadPurchasedItems() {
        
        downloadSpecificItems(User.returnCurrentUser()!.purchasedItemsIDs) { (allItems) in
            
            
            self.purchasedItemsArray =  allItems
            print("We have \(allItems.count) purchased items")
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Purchased Purchased \(purchasedItemsArray.count)")
        return purchasedItemsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        
        cell.generateItemCell(myItem: purchasedItemsArray[indexPath.row])
        
        return cell
    }
    

    
}


// MARK: - Empty data set

extension PurchasedItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No items to display!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Please check back later")
    }
}

//
//  ItemsTableViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/20/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class ItemsTableViewController: UITableViewController {

// MARK: -   Vars
    
    var category: Category?
    var itemsArray: [Item] = []
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Test collection view cell selection
        print("Category \(String(describing: category?.CategoryName)) is choosen")
        
        tableView.tableFooterView = UIView()
        self.title = category?.CategoryName
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backtoHome))]
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if category != nil {
            loadCategoryItems()
        }
        
    }

    // MARK: - Table view data source



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        cell.generateItemCell(myItem: itemsArray[indexPath.row])


        return cell
    }
    
// MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showItemDetails(itemsArray[indexPath.row])
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "itemToAddItemSegue" {
            
            let vc = segue.destination as! AddItemViewController
            vc.category = category
        }
    }
    
    @objc func backtoHome() {
        self.navigationController?.popViewController(animated: true)

    }
    
    // MARK: - Show Item
    private func showItemDetails (_ myItem: Item){
        let itemDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemDetailsViewController") as ItemDetailsViewController
        itemDetailsVC.myItem = myItem
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)
    }
  
//    MARK: - Load Items
    func loadCategoryItems () {
        downloadItemsFromFirebase(byCategoryID: category!.CategoryID) { (allItems) in
            
            print("We have \(allItems.count) item in our category ")
            self.itemsArray = allItems
            self.tableView.reloadData()
        }
    }
}

// MARK: - Empty data set delegate

extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
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

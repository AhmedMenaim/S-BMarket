//
//  SearchViewController.swift
//  S&BMarket
//
//  Created by Crypto on 9/7/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var searchViewOutlet: UIView!
    
    @IBOutlet weak var searchTextFieldOutlet: UITextField!
    
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    @IBOutlet weak var searchItemsTableView: UITableView!
    
    
    //MARK: - Vars
    
    var searchItems: [Item] = []
    var myActivity: NVActivityIndicatorView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        disableSearchButton()
        searchTextFieldOutlet.addTarget(self, action:#selector(textFieldChanged), for: UIControl.Event.editingChanged)

        searchItemsTableView.tableFooterView = UIView()

        searchItemsTableView.emptyDataSetSource = self
        searchItemsTableView.emptyDataSetDelegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        myActivity = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballRotateChase, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), padding: nil)
    }
    // MARK: - Actions

    @IBAction func showSearchView(_ sender: Any) {
        dismissKeyboard()
        showHideSearchView()
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        if (searchTextFieldOutlet.text != "" && searchTextFieldOutlet.text != " ") {
            
            searchInFirebase(withText: searchTextFieldOutlet.text!)
            emptyTextField()
            animatedSearchView()
            dismissKeyboard()
        }
        
    }
    
    
    
    // MARK: - Search Func
    
    func showHideSearchView() {
        
        emptyTextField()
        disableSearchButton()
        animatedSearchView()
    }
    
    func searchInFirebase (withText: String) {
        
        showActivityIndicator()
        
        searchInAlgolia(searchString: withText) { (itemsIDs) in
            
            downloadSpecificItems(itemsIDs) { (allItems) in
                
                self.searchItems = allItems
                self.searchItemsTableView.reloadData()
                self.hideActivityIndicator()

            }
        }
    }
    
    // MARK: - Animation
    func animatedSearchView() {
        UIView.animate(withDuration: 0.5) {
            self.searchViewOutlet.isHidden = !self.searchViewOutlet.isHidden
        }
        
    }
    
    // MARK: - Support Func
    
    func emptyTextField () {
        searchTextFieldOutlet.text = ""
    }
    
    func dismissKeyboard () {
        self.view.endEditing(false)
    }
    
    @objc func textFieldChanged () {
        updateSearchButtonStatus()
    }
    func updateSearchButtonStatus() {
             
          if (searchTextFieldOutlet.text != "" && searchTextFieldOutlet.text != " " ) == false{
            disableSearchButton()
                
            }
             else {
            searchButtonOutlet.isEnabled = true
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

             }
         }
    func disableSearchButton () {
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    // MARK: - Activity Indicator
    
    func showActivityIndicator () {
        if myActivity != nil {
            self.view!.addSubview(self.myActivity!)
            myActivity!.startAnimating()
        }
    }
    
    func hideActivityIndicator (){
        if myActivity != nil {
            myActivity!.removeFromSuperview()
            myActivity!.stopAnimating()
        }
    }
    // MARK: - Show Item
    private func showItemDetails (_ myItem: Item){
        let itemDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ItemDetailsViewController") as ItemDetailsViewController
        itemDetailsVC.myItem = myItem
        self.navigationController?.pushViewController(itemDetailsVC, animated: true)
    }


}




// MARK: - Table view delegate

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! ItemsCell
        cell.generateItemCell(myItem: searchItems[indexPath.row])


        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchItemsTableView.deselectRow(at: indexPath, animated: true)
        showItemDetails(searchItems[indexPath.row])
    }
    
    
}

// MARK: - Empty data set delegate

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No search results!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Start searching...")
    }
    
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        
        return UIImage(named: "search")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        
        showHideSearchView()
    }
}

//
//  ViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/19/20.
//  Copyright © 2020 Crypto. All rights reserved.
//


import Foundation
import UIKit


class HomeCollectionViewController: UICollectionViewController {

    @IBOutlet var homeCollectionViewOutlet: UICollectionView!
    // My Variables
    var categoryArray: [Category] = []
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0 , bottom: 10.0, right: 5.0)
    private let itemsPerRow = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

        
//        createCategories()
//
//        // Test Function
//        downloadCategory { ( allcategories) in
//            print("downloading is done")
//        }
        

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadCategories()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = homeCollectionViewOutlet.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
    
        // Configure the cell
        cell.generateCell(categoryArray[indexPath.item])
    
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "fromCategoryToItemsSegue", sender: categoryArray[indexPath.item])
    }
    
    // Loading our categories
    private func loadCategories (){
        downloadCategory { (allCategories) in
            self.categoryArray = allCategories
            self.homeCollectionViewOutlet.reloadData()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ItemsTableViewController
        vc.category = sender as? Category
    }
    
   

}

// Changing the number of the cells per row

extension HomeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Int(sectionInsets.left) * (itemsPerRow + 1)
        let availableWidth = Double (view.frame.width) - Double(paddingSpace)
        let WidthForItem = availableWidth / Double(itemsPerRow)
        return CGSize(width: WidthForItem - 5 , height: WidthForItem - 5 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

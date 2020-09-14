//
//  ItemDetailsViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/25/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemDetailsViewController: UIViewController {
// MARK: - Vars & Outlets
    // Outlets
    @IBOutlet weak var imagesCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var itemNameLblOutlet: UILabel!
    @IBOutlet weak var itemPriceLblOutlet: UILabel!
    @IBOutlet weak var descriptiontextViewOutlet: UITextView!
    
    // Vars
    var myItem:Item!
    var itemImages: [UIImage] = []
    let myHud = JGProgressHUD(style: .dark)
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0 , right: 0.0)
    private let itemsPerRow = 1
    private let cellHieght = 220.0
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        downloadItemImagesforCollection()
        print("Item name is \(String(describing: myItem.itemName))") // Testing
        
        //Edit Back Bar button
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(self.backAction))]
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        
        //Add Cart Bar Button
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToCart"), style: .plain, target: self, action: #selector(self.addToCartAction))]
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)


    }
    

//    MARK: - Setup UI

    func setupUI (){
        if myItem != nil {
            self.title = myItem.itemName
            itemNameLblOutlet.text = myItem.itemName
            itemPriceLblOutlet.text = currencyConverter(myItem.itemPrice)
            descriptiontextViewOutlet.text = myItem.itemDescription
        }
    }
    
    
    //    MARK: - Back Action
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: - Add to Basket Action
    
    @objc func addToCartAction() {
        
        if User.returnCurrentUser() != nil {
            
            downloadCartItemsFromFireStore(ownerID: User.returnCurrentUserID()) { (myCart) in
                
                if myCart == nil {
                    self.addNewItemToCart()
                }
                else {
                    myCart!.itemsIDs.append(self.myItem.itemID)
                    self.updateMyCart(myCart: myCart!, WithValues: [ConstantArrayOfItemsIDS : myCart!.itemsIDs!])
                }
            }
            print("Item \(String(describing: myItem.itemName)) added to cart successfully")  // Testing
        }
        else {
                showLoginView()
        }
        
    }
        
    
    func addNewItemToCart () {
        let newCart = Cart()
        newCart.cartID = UUID().uuidString
        newCart.ownerID = User.returnCurrentUserID()
        newCart.itemsIDs = [self.myItem.itemID]
        saveCartItemsToFirebase(newCart)
        
        self.myHud.textLabel.text = "\(myItem.itemName!) is added to cart successfully"
        self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.myHud.show(in: self.view)
        self.myHud.dismiss(afterDelay: 2.5)
    }
    
    
    func updateMyCart(myCart: Cart, WithValues: [String : Any]){
        
        updateCartDataInFireStore(myCart: myCart, withValues: WithValues) { (error) in
            
            if error != nil {
                self.myHud.textLabel.text = "Error is \(error!.localizedDescription)"
                self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
                print("Unfortantely we have an error \(error!.localizedDescription)") // Testing
            }
            else {
                
                self.myHud.textLabel.text = "\(self.myItem.itemName!) is added to cart successfully"
                self.myHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.myHud.show(in: self.view)
                self.myHud.dismiss(afterDelay: 2.5)
            }
        }
    }
    //    MARK: - Download Images

    func downloadItemImagesforCollection(){
        if myItem != nil && myItem.imageLinks != nil {
            downloadImages(imageURLs: myItem.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imagesCollectionViewOutlet.reloadData()
                }
            }
        }
    }
    
    private func showLoginView() {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        self.present(vc, animated: true, completion: nil)
    }
}

//    MARK: - Collection Delegate

extension ItemDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath) as! ImagesCollectionViewCell
        
        if itemImages.count > 0 {
            
        cell.setupCollectionImage(myImaage: itemImages[indexPath.row])
            
        }
        
        return cell
    }
    
    
}
extension ItemDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = Double (collectionView.frame.width) - Double(sectionInsets.left)
        
        return CGSize(width: availableWidth, height: cellHieght)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

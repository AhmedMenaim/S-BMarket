//
//  AddItemViewController.swift
//  S&BMarket
//
//  Created by Crypto on 8/21/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    
    //Outlets

    @IBOutlet weak var titleTextFieldOutlet: UITextField!
    
    @IBOutlet weak var priceTextFieldOutlet: UITextField!
    
    @IBOutlet weak var descriptionTextViewOutlet: UITextView!
    
    
    // Vars
    var category: Category!
    var itemImages: [UIImage?] = []
    var myGallery: GalleryController!
    let myHud = JGProgressHUD(style: .dark)
    var myActivityIndicator: NVActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        myActivityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballRotateChase, color: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), padding: nil)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveItemButtonAction(_ sender: Any) {
        dismissKeboard()
        if textEmptyCheck() {
            saveItemsToFirebase()
            

        }
        else {
            self.myHud.textLabel.text = "All Fields are required!!"
            self.myHud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.myHud.show(in: self.view)
            self.myHud.dismiss(afterDelay: 2.5, animated: true)
        }
    }
    
    @IBAction func addImageButtonAction(_ sender: Any) {
        showGalleryImages()
    }
    
    
        // MARK: - Dissmis Keyboard
    @IBAction func tapGestureAction(_ sender: Any) {
        
        dismissKeboard()
    }
    
    private func dismissKeboard () {
        self.view.endEditing(false)
    }
    
    
    //MARK: - POP the view
    private func popTheView () {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Empty check

    private func textEmptyCheck () -> Bool {
        
        return Bool(titleTextFieldOutlet.text != "" && titleTextFieldOutlet.text != " " && priceTextFieldOutlet.text != "" && priceTextFieldOutlet.text != " " && descriptionTextViewOutlet.text != "" && descriptionTextViewOutlet.text != " ")
    }
    
    
    // MARK: - Save item to firebase

      func saveItemsToFirebase () {
          
        showLoadingIndicator()
        let myItem = Item()
        myItem.itemID = UUID().uuidString
        myItem.categoryID = category.CategoryID
        myItem.itemName = titleTextFieldOutlet.text!
        myItem.itemPrice = Double(priceTextFieldOutlet.text!)
        myItem.itemDescription = descriptionTextViewOutlet.text!
        
        if itemImages.count > 0 {
            uploadImages(images: itemImages, itemID: myItem.itemID) { (imageLinkArray) in
                myItem.imageLinks = imageLinkArray
                saveMyItemsToFirebase(myItem: myItem )
                saveItemToAlgolia(myItem: myItem)
                self.popTheView()
            }
            
        }
        else {
            
            saveMyItemsToFirebase(myItem: myItem)
            saveItemToAlgolia(myItem: myItem)
            self.hideLoadingIndicator()
            popTheView()
        }
      }
    
    
    // MARK: - Activity Indicator
    func showLoadingIndicator () {
        
        if myActivityIndicator != nil {
            self.view.addSubview(myActivityIndicator!)
            myActivityIndicator!.startAnimating()
        }
    }
    
    func hideLoadingIndicator () {
        if myActivityIndicator != nil {
            myActivityIndicator!.removeFromSuperview()
            myActivityIndicator!.stopAnimating()
        }
    }
    
    
    
    
    
    // MARK: - Show Gallery
    func showGalleryImages () {
        
        self.myGallery = GalleryController()
        self.myGallery.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 100
        
        self.present(self.myGallery, animated: true, completion: nil)
        
    }
    
}

extension AddItemViewController:GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            Image.resolve(images: images) { (resolvedImages) in
                self.itemImages = resolvedImages
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
}

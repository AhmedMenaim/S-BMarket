//
//  Category.swift
//  S&BMarket
//
//  Created by Crypto on 8/19/20.
//  Copyright © 2020 Crypto. All rights reserved.
//



import Foundation
import UIKit

 class Category {

    var CategoryID: String
    var CategoryName: String
    var CategoryImage: UIImage?
    var CategoryImageName: String?
    
  
    init(name: String, imageName: String) {
        self.CategoryID = " "
        CategoryName = name
        CategoryImageName = imageName
        CategoryImage = UIImage(named: CategoryImageName!)
        
    }
    
    init(mydictionary: NSDictionary) {
        CategoryID = mydictionary[ConstantItemID] as! String
        CategoryName = mydictionary[ConstantItemName] as! String
        CategoryImage = UIImage(named: mydictionary[ConstantCategoryImageName] as? String ?? "")
    }
    

    
}


func downloadCategory (completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    FirebaseReference(collectionReference: .Category).getDocuments { (snapshot, error) in
//        we have to make sure that our snapshot is already existed to avoid crashing
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        if !snapshot.isEmpty {
            for categoryDictionary in snapshot.documents {
                // Test by printing
//                print("Category is created Successfully")
                categoryArray.append(Category(mydictionary: categoryDictionary.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
    
}

func saveCategoryToFirebase(myCategory: Category) {
    
    let id = UUID().uuidString
    myCategory.CategoryID = id
    FirebaseReference(collectionReference: .Category).document(id).setData(fromCategoryToDictionary(myCategory: myCategory) as! [String: Any ])
    
}


func fromCategoryToDictionary (myCategory: Category) -> NSDictionary {
    return NSDictionary(objects: [myCategory.CategoryID, myCategory.CategoryName, myCategory.CategoryImageName!], forKeys: [ConstantItemID as NSCopying, ConstantItemName as NSCopying, ConstantCategoryImageName as NSCopying ])
}

 func createCategories () {
    let womenClothes = Category(name: "Women's Clothes & Accessories", imageName: "womencloth")
    let Electronics = Category(name: "Electronics", imageName: "Electronics")
    let menClothes = Category(name: "Men's Clothes", imageName: "mencloth")
    let health = Category(name: "Health & Beauty", imageName: "health")
    let Home = Category(name: "Home & Kitchen", imageName: "home")
    let baby = Category(name: "Baby Stuff", imageName: "baby")
    let Cars = Category(name: "Cars", imageName: "cars")
    let bikes = Category(name: "Bikes", imageName: "bikes")
    let motorBikes = Category(name: "Motorbikes", imageName: "Motorbikes")
    let luggage = Category(name: "Luggage & Bags", imageName: "luggage")
    let Jewelery = Category(name: "Jewelery", imageName: "Jewelery")
    let Pet = Category(name: "Pet Products", imageName: "Pet")
    let Sports = Category(name: "Sports Products", imageName: "Sports")
    let Garden = Category(name: "Garden Supplies", imageName: "Garden")
    let Camera = Category(name: "Cameras & Oprics", imageName: "Camera")
    
    let arrayOfCategories = [menClothes, womenClothes, baby, Home, Electronics, health, luggage, Garden, Cars, motorBikes , bikes ,  Jewelery, Pet, Sports, Camera]

    for category in arrayOfCategories {
        saveCategoryToFirebase(myCategory: category)
    }

}


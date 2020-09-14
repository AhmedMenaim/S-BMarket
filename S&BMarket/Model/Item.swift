//
//  Item.swift
//  S&BMarket
//
//  Created by Crypto on 8/21/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation
import InstantSearchClient

class Item {
    var itemID: String!
    var categoryID: String!
    var itemName: String!
    var itemDescription: String!
    var itemPrice: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    
    init(myDictionary: NSDictionary) {
        itemID = myDictionary[ConstantItemsID] as? String
        categoryID = myDictionary[ConstantItemID] as? String
        itemName = myDictionary[ConstantItemsName] as? String
        itemDescription = myDictionary[ConstantItemDescription] as? String
        itemPrice = myDictionary[ConstantItemPrice] as? Double
        imageLinks = myDictionary[ConstantImageLinks] as? [String]

    }
}

func fromItemToDictionary (myItem: Item) -> NSDictionary {
    return NSDictionary(objects: [myItem.categoryID as Any,myItem.itemID!, myItem.itemName!, myItem.itemDescription!,myItem.itemPrice as Any, myItem.imageLinks as Any], forKeys: [ConstantItemID as NSCopying, ConstantItemsID as NSCopying, ConstantItemsName as NSCopying, ConstantItemDescription as NSCopying, ConstantItemPrice as NSCopying, ConstantImageLinks as NSCopying])
}

func saveMyItemsToFirebase (myItem: Item){
    FirebaseReference(collectionReference: .Items).document(myItem.itemID).setData(fromItemToDictionary(myItem: myItem) as! [String: Any])
}

func downloadItemsFromFirebase(byCategoryID: String, completion: @escaping(_ itemsArray: [Item]) -> Void) {
    
    var itemsArray: [Item] = []
    FirebaseReference(collectionReference: .Items).whereField(ConstantItemID, isEqualTo: byCategoryID).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemsArray)
            return
        }
        if !snapshot.isEmpty {
            for item in snapshot.documents {
                itemsArray.append(Item(myDictionary: item.data() as NSDictionary))
            }
        }
        completion(itemsArray) // we put it out if statement as we will do the completion at any case
    }
}

func downloadSpecificItems(_ withIDs: [String], completion: @escaping(_ specificItemsArray :[Item]) -> Void){
    
    var count = 0
    var specificItemsArray : [Item] = []
    
    if withIDs.count > 0 {
        for itemID in withIDs {
            FirebaseReference(collectionReference: .Items).document(itemID).getDocument { (snapshot, error) in
                guard let snapshot = snapshot else {
                    completion(specificItemsArray)
                    return
                }
                if snapshot.exists {
                    specificItemsArray.append(Item(myDictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                else {
                    completion(specificItemsArray)
                }
                
                if count == withIDs.count {
                    completion(specificItemsArray)
                }
            }
        }
    }
    else {
        completion (specificItemsArray)
    }
}

// MARK: - Algolia Funcs

func saveItemToAlgolia (myItem: Item) {
    
    let myIndex = AlgoliaService.shared.clientIndex
    let savedItem = fromItemToDictionary(myItem: myItem) as! [String : Any]
    myIndex.addObject(savedItem, withID: myItem.itemID , requestOptions: nil) { (content, error) in
        
        if error != nil {
            print("Error Saving is: \(error!.localizedDescription)")
        }
        else {
            print("Item saved ....")
        }
        
    }
}

func searchInAlgolia (searchString: String, completion: @escaping(_ itemsArray: [String]) -> Void) {
    
    let myIndex = AlgoliaService.shared.clientIndex
    var itemsIDsResult: [String] = []
    
    let myQuery = Query(query: searchString)
    myQuery.attributesToRetrieve = ["ItemName","ItemDescription","ItemPrice"]
    
    myIndex.search(myQuery) { (content, error) in
        
        if error == nil {
            
            let cont = content!["hits"] as! [[String : Any]]
            
            itemsIDsResult = []
            
            for result in cont {
                itemsIDsResult.append(result["objectID"] as! String)
                completion(itemsIDsResult)
            }
        }
        else {
            print("Error while searching \(error!.localizedDescription)")
            completion(itemsIDsResult)

        }
    }
}

//
//  Cart.swift
//  S&BMarket
//
//  Created by Crypto on 8/26/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation

class Cart {
    
    var cartID: String!
    var ownerID: String!
    var itemsIDs: [String]!
    
    init() {
    }
    
    init(myDictionary: NSDictionary) {
        cartID = myDictionary[ConstantItemID] as? String
        ownerID = myDictionary[ConstantOwnerID] as? String
        itemsIDs = myDictionary[ConstantArrayOfItemsIDS] as? [String]
    }
    
}


// MARK: - Save Cart items to firebase
func saveCartItemsToFirebase (_ cart: Cart ) {
    FirebaseReference(collectionReference: .Cart).document(cart.cartID).setData(fromCartToDictionary(myCart: cart) as! [String : Any])
}

// MARK: - From Cart To Dict
func fromCartToDictionary (myCart: Cart) -> NSDictionary {
    return NSDictionary(objects: [myCart.cartID!, myCart.ownerID!, myCart.itemsIDs!], forKeys: [ ConstantItemID as NSCopying, ConstantOwnerID as NSCopying, ConstantArrayOfItemsIDS as NSCopying])
}

// MARK: - Download Cart Items from firestore
func downloadCartItemsFromFireStore(ownerID: String, completion: @escaping(_ myCart: Cart?) -> Void) {
    FirebaseReference(collectionReference: .Cart).whereField(ConstantOwnerID, isEqualTo: ownerID).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion (nil)
            return
        }
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let myCart = Cart(myDictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(myCart)
        }
        else {
            completion(nil)
        }
    }
}

// MARK: - Update Cart

func updateCartDataInFireStore (myCart: Cart, withValues: [String : Any], completion: @escaping(_ error: Error?) -> Void) {
    
    FirebaseReference(collectionReference: .Cart).document(myCart.cartID).updateData(withValues) { (error) in
        completion(error)
    }
}

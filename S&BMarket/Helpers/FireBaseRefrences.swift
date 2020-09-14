//
//  FireBaseRefrences.swift
//  S&BMarket
//
//  Created by Crypto on 8/19/20.
//  Copyright © 2020 Crypto. All rights reserved.
//


import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Cart
}

func FirebaseReference (collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

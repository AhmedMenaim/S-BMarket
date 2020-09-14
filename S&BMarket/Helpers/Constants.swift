//
//  Constants.swift
//  S&BMarket
//
//  Created by Crypto on 8/19/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation

enum Constants {
    
    static let publishedKey = "pk_test_51HPBDBIZlFm7245nLBVqgezpDAjHyAbvRDMuNkj3tRVk9WljN9jcBLYT1EmXHCInE8JArAIaUlIndaRvGFrKH3qc00n5Jzp0ha"
    static let baseURLString = "https://s-b-market.herokuapp.com/"
//    "http://localhost:3000"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase from S&B Market"
}
public let storageRefrenceLink = "gs://sbmarket-43485.appspot.com"
public let AlgoliaAppIDKey = "5KX9YGWDCL"
public let AlgoliaSearchKey = "9ff96f52afb8d7d1e5a8bb9f8ce31d1a"
public let AlgoliaAdminKey = "661b5f00f58ba9a2c45cf0bbfbfde78b"
// Headers

public let UserPath = "User"
public let CategoryPath = "Category"
public let ItemPath = "Items"
public let CartPath = "Cart"

// Category

public let ConstantItemName = "ItemName"
public let ConstantCategoryImageName = "CategoryImageName"
public let ConstantItemID = "ItemID"

// Item

public let ConstantItemsID = "CategoryID"
public let ConstantItemsName = "ItemName"
public let ConstantItemDescription = "ItemDescription"
public let ConstantItemPrice = "ItemPrice"
public let ConstantImageLinks = "ImageLinks"

// Cart

public let ConstantOwnerID = "OwnerID"
public let ConstantArrayOfItemsIDS = "ItemsIDs"

// User

public let ConstantUserEmail = "Email"
public let ConstantUserFirstName = "FirstName"
public let ConstantUserLastName = "LastName"
public let ConstantUserFullName = "FullName"
public let ConstantCurrentUser = "CurrentUser"
public let ConstantFullAdress = "FullAdress"
public let ConstantPurshacedItemsIDs = "PurshacedItemsIDs"
public let ConstantLoggedIn = "LoggedIn"

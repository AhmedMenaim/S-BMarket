//
//  AlgoliaService.swift
//  S&BMarket
//
//  Created by Crypto on 9/8/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    private init(){}
    
    static let shared = AlgoliaService()
    let myClient = Client(appID: AlgoliaAppIDKey, apiKey: AlgoliaAdminKey)
    let clientIndex = Client(appID: AlgoliaAppIDKey, apiKey: AlgoliaAdminKey).index(withName: "ItemName")
}

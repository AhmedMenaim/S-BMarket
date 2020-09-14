//
//  SupportFunctions.swift
//  S&BMarket
//
//  Created by Crypto on 8/25/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation

func currencyConverter (_ price: Double) -> String{
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.init(identifier: "en_US") // for egy arabic "ar_EG"
    return currencyFormatter.string(from: NSNumber(value: price))!
}

//
//  StripeClient.swift
//  S&BMarket
//
//  Created by Crypto on 9/8/20.
//  Copyright © 2020 Crypto. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

class StripeClient {
    
    static let sharedClient = StripeClient()
    
    var baseURLString : String? = nil
    
    var baseURL: URL {
        
        if let URLString = self.baseURLString, let url = URL(string: URLString){
            return url
        }
        else {
            fatalError()
        }
    }
    
    func createAndConfirmPayment(_ token: STPToken, amount: Int, completion: @escaping(_ error: Error?) -> Void) {
        
        let url = self.baseURL.appendingPathComponent("charge")
        
        let params: [String : Any] = ["stripeToken" : token.tokenId, "amount" : amount, "description" : Constants.defaultDescription, "currency" : Constants.defaultCurrency]
        
        AF.request(url, method: .post, parameters: params).validate(statusCode: 200..<300).responseData {
            (response) in
            
            switch response.result {
            case .success( _):
                print("Payment is successful")
                completion(nil)
            case .failure(let error):
                print("Error existed \(error.localizedDescription)")
                completion(error)
            }
        }
//        lamofire.
    }
}

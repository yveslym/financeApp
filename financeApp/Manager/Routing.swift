//
//  Routing.swift
//  Core-Project
//
//  Created by Yveslym on 11/8/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
enum Route{
    case transactions
    case auth
    case identity
    case income
    case balance
    case exchangeToken
    case accounts

    /// function to return the path of data we want to fetch
    func accessPoint() -> String{
        switch (self){
        case .transactions:
            return ("/transactions/get")
        case .auth:
            return ("/auth/get")
        case .identity:
            return ("/identity/get")
        case .income:
            return ("/income/get")
        case .balance:
            return ("/balance/get")
        case .exchangeToken:
            return ("/item/public_token/exchange")
        case .accounts:
            return("/accounts/get")
        }
    }
    
/**  function to set the query parameter. It's important
     to notice that plaid use post request to get data.
     - Parameter bank: return the a list of account number of a single (either credit or debit...)
     - Parameter client_id: a specific id provided by plaid for this project
     - Parameter secret: a secret id provided by Plaid for this project
     - Parameter acces_token: atoken retrieved after user link his account to the app
     - parameter start date and end date: both use to unclose the retrieve of transaction in certain period of time
     
     The method return a json serialise data
 */
    func jsonBody(bank: Bank? = nil ,client_id: String?, secret: String? = nil,access_token: String? = nil, startDate: Date? = nil, endDate: Date? = nil, public_token: String? = nil)-> Data?{
        
        switch (self) {
        
        case .transactions:
            
            // formated the date to the requiered format
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let start = formatter.string(from: startDate!)
            let end = formatter.string(from: endDate!)
            
            let option: [String: Int]? = ["count":250]
            let body : [String: Any?] = [   "client_id":client_id,
                                            "secret":secret,
                                            "access_token":access_token,
                                            "start_date": start,
                                            "end_date":end,
                                            "options":option]
            
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        case .auth:
            let body : [String: String?] = ["client_id":client_id,
                                           "secret":secret,
                                           "access_token":access_token]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        case .identity:
            let body : [String: String?] = ["client_id":client_id,
                                            "secret":secret,
                                            "access_token":access_token]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .income:
            let body : [String: String?] = ["client_id":client_id,
                                            "secret":secret,
                                            "access_token":access_token]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .balance:
            var accountNumber: [String]? = nil
    
            let accounts = bank?.accounts
            for account in accounts!{
                accountNumber?.append(account.id!)
            }
            let accountId:[String:[String]?] = ["account_ids":accountNumber]
            let body : [String: Any?] = ["client_id":client_id,
                                            "secret":secret,
                                            "access_token":access_token,
                                            "option":accountId]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            
        case .exchangeToken:
            let body : [String: String] = ["client_id":client_id!,
                                           "secret":secret!,
                                           "public_token":public_token!]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        case .accounts:
            let body : [String: String] = ["client_id":client_id!,
                                           "secret":secret!,
                                           "access_token":access_token!]
            return try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
    }
    
}
enum ApiHost{
    case sandbox
    case development
    case production
    
    ///function to return the base url
    func baseLink()->String{
        switch (self) {

        case .sandbox:
            return ("https://sandbox.plaid.com")
        case .development:
            return ("https://development.plaid.com")
        case .production:
            return ("https://production.plaid.com")
        }
    }
}














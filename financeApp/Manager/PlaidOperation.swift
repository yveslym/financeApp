//
//  PlaidOperation.swift
//  Core-Project
//
//  Created by Yveslym on 12/7/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

class plaidOperation{
    
    // - MARK: Methods
    
    
    // function to get the transaction of a given account
    static func transactionFromPlaid(with bank: Bank, startDate: Date, endDate: Date, completion: @escaping ([Transaction]?) -> Void) {
      
        let days = [startDate,endDate]
        Networking.network(bank: bank, route: .transactions, apiHost: .development, date: days,completion: { (data) in
            var myTransaction = try! JSONDecoder().decode(transactionOperation.self, from: data!)
            
            return completion(myTransaction.transactions)
        })
    }
    
    static func itemAccess(publicToken: String, completion: @escaping (ItemAccess?) -> Void){
        Networking.network(route: .exchangeToken, apiHost: .development,public_token: publicToken,completion: { (data) in
            let itemAccess = try! JSONDecoder().decode(ItemAccess.self, from: data!)
            return completion(itemAccess)
        })
    }
    
//    static func identity(with accessToken: String, completion: ()){
//    }

    static func account(with bank: Bank, account: Account, completion: @escaping (Balance?)-> Void){
    
        Networking.network(bank: bank, route: .balance, apiHost: .development) { (data) in
            let balance = try! JSONDecoder().decode(Balance.self, from: data!)
            return completion(balance)
        }
    
    }
    
    static func accounts(bank: Bank, completion: @escaping ([Account]?)-> Void){
        Networking.network(bank: bank, route:.accounts , apiHost: .development) { (data) in
            
            guard let data = data else {return}
            
            
            let accounts = try! JSONDecoder().decode(ListOfAccount.self, from: data)
            return completion(accounts.accounts)
        }
    }
}

struct ListOfAccount: Decodable{
    let accounts:[Account]
}















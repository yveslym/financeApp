//
//  PlaidServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/27/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
struct plaidServices{
    static func showBanks(completion:@escaping([Bank]?)->()){
     let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var banks = [Bank]()
            if snapshot.exists(){
            snapshot.children.forEach({ (snapshot) in
                let snapshot = snapshot as! DataSnapshot
                 let bank = try! JSONDecoder().decode(Bank.self, withJSONObject: snapshot.value!)
                banks.append(bank)
            })
            completion(banks)
        }
            else{
                completion(nil)
            }
    }
}
    
    static func createBank(_ bank: Bank, completion: @escaping()->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!).child(bank.id!)
        ref.setValue(bank.toDictionary()) { (error, _) in
            if error == nil{
                
                // save last transaction
                completion()
            }
        }
    }
    static func uploadAccount(_ account: Account, completion: @escaping()->()){
        let ref = Database.database().reference().child("Account").child((Auth.auth().currentUser?.uid)!).child(account.id!)
        ref.setValue(account.toDictionary()) { (error, _) in
            if error == nil{
                
                // save last transaction
                completion()
            }
        }
    }
    static func retrieveAccount(completion:@escaping([Account]?)->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var accounts = [Account]()
            if snapshot.exists(){
                snapshot.children.forEach({ (snap) in
                    let snap = snap as! DataSnapshot
                    let bankJson = JSON(snap.value!)
                    let accountJson = bankJson["account"].arrayValue
                    accountJson.forEach({
                        let account = try! JSONDecoder().decode(Account.self, withJSONObject: $0.object)
                        accounts.append(account)
                    })
                })
                return completion(accounts)
            }
            else{
                return completion(nil)
            }
        }
    }
    /// method to get last transaction
    static func retrieveLastTransaction(completion:@escaping(Transaction?)->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                var transactions = [Transaction]()
                snapshot.children.forEach({ (snapshot) in
                    
                    let snapshot = snapshot as! DataSnapshot
                    let json = JSON(snapshot.value!)
                    
                    let accountJson = json["account"].arrayValue
                    accountJson.forEach({
                        let transJson = $0["transactions"].arrayValue
                        transJson.forEach({
                            
                            let transaction = try! JSONDecoder().decode(Transaction.self, withJSONObject: $0.object)
                            transactions.append(transaction)
                        })
                    })
                })
                let lastTrans = Transaction.lastTransaction(trans: transactions)
                
                completion(lastTrans)
                
            }
            else{
                completion(nil)
            }
        }
    }
    /// method to get last transaction
    static func retrieveTransactions(completion:@escaping([Transaction]?)->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                var transactions = [Transaction]()
                snapshot.children.forEach({ (snapshot) in
                    
                    let snapshot = snapshot as! DataSnapshot
                    let json = JSON(snapshot.value!)
                    
                    let accountJson = json["account"].arrayValue
                    accountJson.forEach({
                        let transJson = $0["transactions"].arrayValue
                        transJson.forEach({
                            
                            let transaction = try! JSONDecoder().decode(Transaction.self, withJSONObject: $0.object)
                            transactions.append(transaction)
                        })
                    })
                })
               
                
                completion(transactions)
                
            }
            else{
                completion(nil)
            }
        }
    }
}

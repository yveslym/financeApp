//
//  PlaidServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/27/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase

struct plaidServices{
    static func showBanks(completion:@escaping([Bank])->()){
     let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            var banks = [Bank]()
            snapshot.children.forEach({ (snapshot) in
                let snapshot = snapshot as! DataSnapshot
                 let bank = try! JSONDecoder().decode(Bank.self, withJSONObject: snapshot.value!)
                banks.append(bank)
            })
            completion(banks)
        }
    }
    
    static func createBank(_ bank: Bank, completion: @escaping()->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!).child(bank.id!)
        ref.setValue(bank.toDictionary()) { (error, _) in
            if error == nil{
                completion()
            }
        }
    }
    
    
}

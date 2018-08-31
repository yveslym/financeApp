//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation



class Account: Codable {
    
    var id: String? = ""
    var currentBalance: Double
    var availableBalance: Double
    var name: String? = ""
    var accNumber: String? = ""
    var transactions = [Transaction]()
    //var balance: Balance?
    var subtype: String? = ""
    var officialName: String? = ""
    var limit: String? = ""
    init(){
        currentBalance = 0.0
        availableBalance = 0.0
        
    }
    func toDic(){
       
    }
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
//        let data = try! JSONEncoder().encode(self)
//        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
//        return json
        let trans = self.transactions.compactMap({$0.toDictionary()})
        let balances = [ "current":currentBalance,
                         "available":availableBalance,
                         "limit":limit!] as [String : Any]
        let json = ["account_id":id,
                    "balances":balances,
                    "name":name,
                    "mask":accNumber,
                    "transactions":trans,
                    "subtype":subtype,
                    "official_name":officialName
                   ] as [String : Any]
        return json
    }
    
    
    
    required init(from decoder: Decoder)throws {
        
        enum AccountKey: String, CodingKey{
            case name,account_id, balances, mask, subtype, official_name
            
            enum BalanceKey: String, CodingKey {
                case current, available, limit
            }
        }
        
        let contenaire = try! decoder.container(keyedBy: AccountKey.self)
        let balanceContenaire = try! contenaire.nestedContainer(keyedBy: AccountKey.BalanceKey.self, forKey: .balances)
        
        self.name = try contenaire.decode(String.self, forKey: .name)
        self.id = try contenaire.decode(String.self, forKey: .account_id)
        self.accNumber = try contenaire.decode(String.self, forKey: .mask)
        self.subtype = try contenaire.decodeIfPresent(String.self, forKey: .subtype) ?? ""
        
        self.officialName = try contenaire.decodeIfPresent(String.self, forKey: .official_name) ?? ""
        
        self.currentBalance = try balanceContenaire.decodeIfPresent(Double.self, forKey: .current) ?? 00
        self.availableBalance = try! balanceContenaire.decodeIfPresent(Double.self, forKey: .available) ?? 0.0
        
    }
    
}



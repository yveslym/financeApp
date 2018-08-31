//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation



class Account: Decodable {
    
    var id: String?
    var currentBalance: Double
    var availableBalance: Double
    var name: String?
    var accNumber: String
    var transactions = [Transaction]()
    var balance: Balance?
    var subtype: String?
    var officialName: String?
    var limit: String?
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
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
        self.subtype = try contenaire.decodeIfPresent(String.self, forKey: .subtype)
        
        self.officialName = try contenaire.decodeIfPresent(String.self, forKey: .official_name)
        
        self.currentBalance = try balanceContenaire.decodeIfPresent(Double.self, forKey: .current)!
        self.availableBalance = try! balanceContenaire.decodeIfPresent(Double.self, forKey: .available) ?? 0.0
        
    }
    
}



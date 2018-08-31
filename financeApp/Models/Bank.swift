//
//  Bank+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation


class Bank:  Codable {
    
    
    var id: String? = ""
    var name: String? = ""
    var linkSessionId: String? = ""
    var requestId: String? = ""
    var accounts: [Account]?
    var itemAccess: ItemAccess?
    //var balanaces: [Balance]?

    init (){
        
    }
    enum BankAccountKey: String, CodingKey{
        case institution, accounts, status, request_id, link_session_id, itemAccess,transactions
        enum instutionKey: String, CodingKey{
            case institution_id
            case name
            
        }
        enum AccountKey: String, CodingKey{
            case id
            case name
        }
    }
    
    required init( from decoder: Decoder)throws{
        
       
        
        let BankContenair = try decoder.container(keyedBy: BankAccountKey.self)
        
        self.requestId = try BankContenair.decodeIfPresent(String.self, forKey: .request_id)
        self.linkSessionId = try BankContenair.decodeIfPresent(String.self, forKey: .link_session_id)
        
        
        let instutitionContenair = try BankContenair.nestedContainer(keyedBy: BankAccountKey.instutionKey.self, forKey: .institution)
        
        self.id = try instutitionContenair.decodeIfPresent(String.self, forKey: .institution_id)
        self.name = try instutitionContenair.decodeIfPresent(String.self, forKey: .name)
    }
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        let account = self.accounts?.compactMap({$0.toDictionary()})
        
        let json = ["id":id,
                "name":name,
                "linkSessionId":linkSessionId,
                "requestId":requestId,
                "itemAccess":itemAccess?.toDictionary(),
            "account":account] as! [String:Any]
        //let data = try! JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)//JSONEncoder().encode(self)
        //let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
}


















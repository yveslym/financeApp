//
//  Identity+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation


class Identity: Decodable {

   var name: String?
    var email: [Email]?
   var phoneNumber = [PhoneNumber]()
   var addresses = [Addresses]()
   var account: Account?
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
    
    enum IdentityKey: String, CodingKey{
        case addresses,names,emails,phone_numbers
    }
    
     required  init(from decoder: Decoder)throws{
        
       
        
        let contenaire = try! decoder.container(keyedBy: IdentityKey.self)
        self.name = try contenaire.decodeIfPresent(String.self, forKey: .names)
        
       let address = try contenaire.decodeIfPresent([Addresses].self, forKey: .addresses)
        let phone = try contenaire.decodeIfPresent([PhoneNumber].self, forKey: .phone_numbers)
        
        let email = try contenaire.decodeIfPresent([Email].self, forKey: .emails)
        
        address?.forEach({self.addresses.append($0)})
        phone?.forEach({self.phoneNumber.append($0)})
        email?.forEach({self.email?.append($0)})
    }
}

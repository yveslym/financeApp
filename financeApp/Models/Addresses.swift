//
//  Addresses+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation
import CoreData


 class Addresses: Decodable {

  var city: String?
 var state: String?
 var street: String?
 var zipCode: String?
var identity: Identity?

    enum AddressesKey: String, CodingKey{
        case data
        
        enum DataKey: String, CodingKey {
            case city,state,street,zip
        }
    }
    required init(from decoder: Decoder)throws{
        
       
        
        let contenaire = try! decoder.container(keyedBy: AddressesKey.self)
        let dataContenaire = try! contenaire.nestedContainer(keyedBy: AddressesKey.DataKey.self, forKey: .data)
        
        self.street = try dataContenaire.decodeIfPresent(String.self, forKey: .street)
        self.city = try dataContenaire.decodeIfPresent(String.self, forKey: .city)
        self.street = try dataContenaire.decodeIfPresent(String.self, forKey: .state)
        self.zipCode = try dataContenaire.decodeIfPresent(String.self, forKey: .zip)
    }
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
}
































//
//  Email+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation



class Email:  Decodable {
   var email: String?
   var primary: Bool
     var type: String?
   var identity: Identity?
    enum EmailKey: String, CodingKey {
        case data, primary, type
    }
    
     required init(from decoder: Decoder)throws{
        
        
        
        let contenaire = try! decoder.container(keyedBy: EmailKey.self)
        let primary = try contenaire.decodeIfPresent(String.self, forKey: .primary)
        self.primary = primary!.toBool()!
        
        self.type = try contenaire.decodeIfPresent(String.self, forKey: .type)
        self.email = try contenaire.decodeIfPresent(String.self, forKey: .data)
    }
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
}

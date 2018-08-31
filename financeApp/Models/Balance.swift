//
//  Balance+CoreDataClass.swift
//  Core-Project
//
//  Created by Yveslym on 12/11/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation



 class Balance: Codable {
 
    var current: Double
    var available: Double
    var accountId: String? = ""
    
    init(){
        current = 0.0
        available = 0.0
    }
    enum BalanceKey: String, CodingKey{
        case current, available
    }
     required  init(from decoder: Decoder)throws{
        
        let contenaire = try! decoder.container(keyedBy: BalanceKey.self)
        self.current = try contenaire.decode(Double.self, forKey: .current)
        self.available = try contenaire.decode(Double.self, forKey: .available)
    }
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
}

//
//  ItemAccess+CoreDataClass.swift
//  
//
//  Created by Yveslym on 12/7/17.
//
//

import Foundation
import CoreData


class ItemAccess:  Codable {
    
    var accessToken: String?
    var itemId: String?
    
    init(){}
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
    
      required init(from decoder: Decoder)throws{
        
        enum ItemKey: String, CodingKey{
            case item_id, access_token
        }
        
       
        let container = try! decoder.container(keyedBy: ItemKey.self)
        self.accessToken = try container.decode(String.self, forKey: .access_token)
        self.itemId = try container.decodeIfPresent(String.self, forKey: .item_id)
   
    }
}




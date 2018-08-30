//
//  Boot.swift
//  financeApp
//
//  Created by Yves Songolo on 8/30/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
class Bot: Decodable{
    
    var id: String
    var ownerID: String
    var name: String
 
    init(){
       id = ""
        ownerID = ""
        name = ""
    }
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
    
}


//  Created by Yveslym on 12/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//
//

import Foundation

class PhoneNumber:  Decodable {
    
    var primary: Bool
    var type: String?
    var number: Int16
    var identity: Identity?
    
    enum PhoneNumberKey: String, CodingKey{
        case primary, type, data
    }
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
    
    required init(from decoder: Decoder)throws{
        
        let contenaire = try! decoder.container(keyedBy: PhoneNumberKey.self)
        let primary = try contenaire.decodeIfPresent(String.self, forKey: .primary)
        self.primary = primary!.toBool()!
        
        self.type = try contenaire.decodeIfPresent(String.self, forKey: .type)
        self.number = try! contenaire.decodeIfPresent(Int16.self, forKey: .data)!
    }
}


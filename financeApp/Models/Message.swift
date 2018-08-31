//
//  Message.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation

class Message: Decodable{
    
    var time: String
    var content: String
    var msgID: String
    var type: String
    var sentBy: String
    
    init(time: String, content: String,msgId: String, type: String, sentBy: String){
        self.time = time
        self.content = content
        self.msgID = msgId
        self.type = type
        self.sentBy = sentBy
    }
    
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        let data = try! JSONSerialization.data(withJSONObject: self, options: opt)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
   
}


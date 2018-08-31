//
//  Message.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation

class Message: Codable{
    
    var time: String
    var content: String
    var msgID: String
    var type: String
    var sentBy: String
    var isAnswered: Bool
    
    init(time: String, content: String,msgId: String, type: String, sentBy: String){
        self.time = time
        self.content = content
        self.msgID = msgId
        self.type = type
        self.sentBy = sentBy
        self.isAnswered = false
        
    }
    
    
    func toDictionary(options opt: JSONSerialization.WritingOptions = []) -> [String: Any]{
        let data = try! JSONEncoder().encode(self)
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        return json
    }
   
}


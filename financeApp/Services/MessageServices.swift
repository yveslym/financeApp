//
//  MessageServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase
struct MassageServices{
    static func shows(){
        
    }
    
    static func create(message: Message, completion: @escaping()->()){
        let msgRef = Database.database().reference().child("Message").childByAutoId()
        let grpRef = msgRef.child("group").childByAutoId()
        let ref = grpRef.child("conversation").childByAutoId()
        message.groupID = grpRef.key
        message.msgID = ref.key
        ref.setValue(message) { (_, _) in
           
        }
        
        
    }
   static func observeIncomeMessage(groupKey: String, convoKey: String, completion: @escaping(Message)->()){
        let ref = Database.database().reference().child("Message").child(convoKey).child("group").child(groupKey).child("conversation")
        ref.observe(.childAdded) { (snapshot) in
            guard let value = snapshot.value else {return}
            let msg = try! JSONDecoder().decode(Message.self, withJSONObject: value)
            completion(msg)
        }
    }
    
    static func fetchMessages(groupKey: String, convoKey: String, completion: @escaping([Message]?)->()){
        let ref = Database.database().reference().child("Message").child(convoKey).child("group").child(groupKey).child("conversation")
        ref.observeSingleEvent(of: .value) { (snapshot) in
           
            if snapshot.exists(){
                var message = [Message]()
                snapshot.children.forEach({ (snap) in
                     let snap = snap as! DataSnapshot
                    let msg = try! JSONDecoder().decode(Message.self, withJSONObject: snap.value!)
                    message.append(msg)
                })
                completion(message)
            }
            else{
                completion(nil)
            }
        }
    }
    
}







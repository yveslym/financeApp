//
//  MessageServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase

struct MessageServices{
    
    
    static func create(message: Message, completion: @escaping(Message)->()){
        let user = Auth.auth().currentUser
        let msgRef = Database.database().reference().child("Message").child((user?.uid)!).childByAutoId()
        
        message.msgID = msgRef.key
        
        msgRef.setValue(message.toDictionary()) { (_, _) in
           completion(message)
        }
        
    }
    
    /// method to observe incoming messages
   static func observeIncomeMessage(completion: @escaping(Message)->()){
     let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("Message").child((user?.uid)!)
        ref.observe(.childAdded) { (snapshot) in
            guard let value = snapshot.value else {return}
            let msg = try! JSONDecoder().decode(Message.self, withJSONObject: value)
            completion(msg)
        }
    }
    
    /// method to update message
    static func updateMessage (message: Message, completion: @escaping(Message)->()){
        let user = Auth.auth().currentUser
        message.isAnswered = true
        let msgRef = Database.database().reference().child("Message").child((user?.uid)!).child(message.msgID)
        
        msgRef.updateChildValues(message.toDictionary()) { (_, _) in
            completion(message)
        }
    }
    
    /// method to fetch all messages
    static func fetchMessages(completion: @escaping([Message]?)->()){
         let user = Auth.auth().currentUser
        let ref = Database.database().reference().child("Message").child((user?.uid)!)
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

enum MessageType: String{
    case recievedTextMessage
    case sendTextMessage
    case transaction
    case balance
}







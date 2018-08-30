//
//  BotServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/30/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase
struct BotServices{
    
    /// method to create new bot
   static func createBot(completion: @escaping(Bot)->()){
        
        let ref = Database.database().reference().child("Bot").childByAutoId()
        
        let bot = Bot()
        bot.ownerID = (Auth.auth().currentUser?.uid)!
        bot.name = "Jervice"
        bot.id = ref.key
        ref.setValue(bot.toDictionary()) { (_, _) in
            completion(bot)
        }
    }
    
    static func show(completion:@escaping(Bot)->()){
        let user = User.current
        let ref = Database.database().reference().child("Bot").child(user.botID!)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let bot = try! JSONDecoder().decode(Bot.self, withJSONObject: snapshot.value!)
            completion(bot)
        }
    }
    
    func botObserver (completion: @escaping(Message)->()){
        let ref = 
    }
}

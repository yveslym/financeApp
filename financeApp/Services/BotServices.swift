//
//  BotServices.swift
//  financeApp
//
//  Created by Yves Songolo on 8/30/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import Firebase
import ApiAI

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
    
    static func botObserver (completion: @escaping(Message)->()){
    
    }
    /// method to send quesrtion to the ApiAI
    static func apiAIRequest(question: String, completion: @escaping(String?)->()){
        let request = ApiAI.shared().textRequest()
        request?.query = question
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
              print("heyyyy")
                completion(textResponse)
            }
            else{
                completion(nil)
            }
        },
                                                 failure: { (request, error) in
            print(error!)
            print("boomer")
            completion(nil)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    /// method to quesry data from database based on AI answer
    static func queryToUserNeedFromDatabase(word: String, completion: @escaping(Transaction?)->()){
        switch word{
        case "last transaction":
            getLastTransaction { (trans) in
                if trans != nil {
                    completion(trans)
                }else{
                    completion(nil)
                }
            }
        case "current balance": break
        default:break
        }
    }
    
    /// method to get last transaction
    static func getLastTransaction(completion:@escaping(Transaction?)->()){
        let ref = Database.database().reference().child("Bank").child((Auth.auth().currentUser?.uid)!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
             let banks = decodeBank(snapshot: snapshot)
                var accounts = [Account]()
                banks.forEach({accounts += $0.accounts!})
                let trans = Transaction.getAllTransactionOfAllAcount(accounts: accounts)
                let lastTrans = Transaction.lastTransaction(trans: trans)
                completion(lastTrans)
            }
            else{
                completion(nil)
            }
            
        }
      
        
        
        
    }
    /// method to get current balance
    static func getCurrentBalance(completion:@escaping(Transaction)->()){
        
    }

    private static func decodeBank(snapshot: DataSnapshot) -> [Bank]{
        var banks = [Bank]()
        snapshot.children.forEach { (snap) in
            let snap = snap as! DataSnapshot
            let bank = try! JSONDecoder().decode(Bank.self, withJSONObject: snap.value!)
            banks.append(bank)
        }
        return banks
    }
}






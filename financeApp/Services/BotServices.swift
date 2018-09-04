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
import SwiftyJSON

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
    
    static func botObserverMessage (completion: @escaping(Message?)->()){
        MessageServices.observeIncomeMessage {(message) in
            
            
            if message.sentBy != "bot" && message.isAnswered == false{
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    // Put your code which should be executed with a delay here
               
                MessageServices.updateMessage(message: message, completion: { (message) in
                    
                
                apiAIRequest(question: message.content, completion: { (word) in
                    guard let word = word else {return completion(nil)}
                NLPQueryFromUserEntry(word: word, completion: { (trans, account,word) in
                    
                    if trans != nil{
                    botSentMessage(messageType: .transaction, transaction: trans!, completion: { (message) in
                        //print (sent)
                        return completion(message)
                        })
                       
                    }
                    else if word != nil {
                        botSentMessage(messageType: .sendTextMessage, message: word! ,completion: { (message) in
                            return completion(message)
                        })
                    }
                    else if account != nil{
                        botSentMessage(messageType: .balance, account: account!, completion: { (message) in
                            //print (sent)
                            return completion(message)
                        })
                    }
                })
            })
        })
    })
                
            }else{
                return completion(nil)
            }
        }
        
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
    
    /// method to query data from database based on AI answer
     static func NLPQueryFromUserEntry(word: String, completion: @escaping(Transaction?,[Account]?, String?)->()){
        switch word{
        case "last transaction":
            plaidServices.retrieveLastTransaction { (trans) in
                if trans != nil {
                    return completion(trans,nil, nil)
                }else{
                    return completion(nil,nil, nil)
                }
            }
        case "current balance":
            plaidServices.retrieveAccount { (account) in
                completion(nil,account,nil)
            }
        default: return completion(nil,nil, word)
        }
    }
    /// method to respond from user question
    private static func botSentMessage(messageType: MessageType, message: String? = nil,transaction: Transaction? = nil, account: [Account]? = nil, completion: @escaping (Message?)->()){
        
        switch messageType{
            
        case .recievedTextMessage: break
            
        case .sendTextMessage:
            let message = Message(time: Date().toString(), content: message!, msgId: "", type: "text", sentBy: "bot")
            MessageServices.create(message: message) { (message) in
                return completion(message)
            }
        case .transaction:
          
            let name = transaction?.name
            let content = "  \(name ?? "") was your last transaction of \(transaction?.amount ?? 00)"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "bot")
            MessageServices.create(message: message) { (message) in
                return completion(message)
            }
            
            
        
        case .balance:
            let dg = DispatchGroup()
            var message = [Message]()
        if let account = account{
            account.forEach { (account) in
               // dg.enter()
                let name = account.name
                let number = account.accNumber
                let balance = account.availableBalance
                let content = ("Your account \(name ?? "no name") ending with \(number ?? "0"), the banace is \(balance) ")
                let msg = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "bot")
            message.append(msg)
            }
            message.forEach { (msg) in
                dg.enter()
                MessageServices.create(message: msg) { (message) in
                   dg.leave()
                }
                dg.notify(queue: .global(), execute: {
                    completion(message.first)
                })
                }
            }
        }
    }
    
  
    /// method to get current balance
    
   
    

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






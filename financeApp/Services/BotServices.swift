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
    
    static func botObserverMessage (completion: @escaping(Bool?)->()){
        MessageServices.observeIncomeMessage { (message) in
            if message.sentBy != "bot"{
                apiAIRequest(question: message.content, completion: { (word) in
                    
                    guard let word = word else {return completion(nil)}
                NLPQueryFromUserEntry(word: word, completion: { (trans, word) in
                    
                    if trans != nil{
                    botSentMessage(messageType: .transaction, transaction: trans!, completion: { (sent) in
                        print (sent)
                        return completion(true)
                        })
                       
                    }
                    else if word != nil {
                        botSentMessage(messageType: .sendTextMessage, completion: { (sent) in
                            completion(true)
                        })
                    }
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
    private static func NLPQueryFromUserEntry(word: String, completion: @escaping(Transaction?, String?)->()){
        switch word{
        case "last transaction":
            getLastTransaction { (trans) in
                if trans != nil {
                    return completion(trans,nil)
                }else{
                    return completion(nil,nil)
                }
            }
        case "current balance": return completion(nil,nil)
        default: return completion(nil,word)
        }
    }
    /// method to respond from user question
    private static func botSentMessage(messageType: MessageType, message: String? = nil,transaction: Transaction? = nil, balance: Balance? = nil, completion: @escaping (Bool)->()){
        
        switch messageType{
            
        case .recievedTextMessage: break
            
        case .sendTextMessage:
            let msg = Message(time: Date().toString(), content: message!, msgId: "", type: "text", sentBy: "bot")
            MessageServices.create(message: msg) {
                return completion(true)
            }
        case .transaction:
            let place = transaction?.address
            let name = transaction?.name
            let content = " \(name ?? "") was your last transaction of \(transaction?.amount ?? 00), at \(place ?? "none place provided")"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "bot")
            MessageServices.create(message: message) {
                return completion(true)
            }
            
            
        
        case .balance: break
            
        }
    }
    
    /// method to get last transaction
    private static func getLastTransaction(completion:@escaping(Transaction?)->()){
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






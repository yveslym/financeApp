//
//  MessageViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 8/30/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Floaty

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet weak var shortcutButton: Floaty!
   
    
    @IBOutlet var cardView: UIView!
    weak var delegate : plaidDelegate!
    
    var cards = [Account](){
        didSet{
            DispatchQueue.main.async {
                self.cardCollectionView.reloadData()
            }
        }
    }
    
    var messages = [Message](){
        didSet{
            
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        }
    }
    
    @IBAction func  forgotPasswordButtonTapped(_ sender: UIButton){
    
    }
    
    /// method to send a welcome message to user
    func welcomeMessage(){
        let content = "Hey \(User.current.name), welcome to Finance app, I'm Yveslym your companion, you can ask me any question about you account, like what's my last purchase? for example, and don't forget to add your debit cared so i can help you 😎"
        let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "bot")
        
        MessageServices.create(message: message) { (message) in
            self.messages.insert(message, at: 0)
           
        }
    }
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var galerieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupShortcutButton()
        // rotate the view the view table view
        messageTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, messageTableView.frame.size.width - 0.8)
        
        self.delegate = self
        self.botObserveMessage()
        self.userObserveMessage()
        self.getMyBankCard()
        
        
        MessageServices.fetchMessages { (msg) in
            if let msg = msg{
                
                let message = msg.sorted(by: {$0.time > $1.time})
                self.messages = message
            }
            else{
                if UserDefaults.standard.value(forKey: "firstMessage") == nil{
                UserDefaults.standard.set(true, forKey: "firstMessage")
                self.welcomeMessage()
            }
        }
    }
}
    
    
    @IBAction func sendButtonPress(_ sender: Any) {
        
        if !(self.messageTextField.text?.isEmpty)!{
            guard let content = self.messageTextField.text else {return}
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "textMessage", sentBy: "user")
            self.messageTextField.text = ""
            MessageServices.create(message: message) { (message) in
                
                self.messages.insert(message, at: 0)
                
            }
        }
    }
    
  
    
    /// method to set up the short cut button
    private func setupShortcutButton(){
        let floaty = Floaty()
        floaty.frame.origin.x = 0
        floaty.addItem("Last Transaction", icon: UIImage(named: "transaction")) { (float) in
            let content = "get last transaction"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "user")
           
            MessageServices.create(message: message) { (message) in
                self.messages.insert(message, at: 0)
                floaty.close()
            }
        }
        floaty.addItem("Balance", icon:  UIImage(named: "wallet")) { (float) in
            let content = "what is my balance?"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "user")
           
            MessageServices.create(message: message) { (message) in
                self.messages.insert(message, at: 0)
                floaty.close()
            }
        }
        floaty.addItem("Add debit Card", icon:  UIImage(named: "debit")) { (float) in
            self.delegate.presentPlaidLink(sender: self)
            floaty.close()
        }
        floaty.addItem("See Chart", icon:  UIImage(named: "chart")) { (float) in
             self.performSegue(withIdentifier: "chart", sender: nil)
                floaty.close()
            }
        floaty.size = 40
         self.view.addSubview(floaty)
    }
    
    
    
    /// method to observe bot incoming message
   private func botObserveMessage(){
        BotServices.botObserverMessage { (sent) in
            print(sent ?? "")
        }
    }
     /// method to observe user incoming message
   private func userObserveMessage(){
        UserServices.observeNewMessage { (message) in
            if let msg = message{
                self.messages.insert(msg, at: 0)
            }
        }
    }
    /// method to retieve all bank Account
   private func getMyBankCard(){
        plaidServices.retrieveAccount { (accounts) in
            if let accounts = accounts{
                //self.view.addSubview(self.cardView)
                self.cards = accounts
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if cards.count != 0{
            //view.addSubview(cardView)
        }
        
        
    }
}

// - Mark: TableView lyfe cicle

extension MessageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        
        switch message.sentBy{
        case "bot":
            
            print("bot: ", message.time)
            let cell = tableView.dequeueReusableCell(withIdentifier: "recievedMessage", for: indexPath) as! TextMessageRecievedTableViewCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cell.messageLabel.text = message.content
            return cell
            
        case "user":
            print("user: ", message.time)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextMessageSentTableViewCell
            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cell.messageLabel.text = message.content
            //cell.constraintLine.constant  = cell.contentView.frame.width - cell.messageLabel.text
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextMessageSentTableViewCell
            cell.messageLabel.text = message.content
            return cell
        }
    }
}

extension MessageViewController: plaidDelegate{
    func presentPlaidLink() {
        
    }
    
    
}


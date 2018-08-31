//
//  MessageViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 8/30/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    var messages = [Message](){
        didSet{
            
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var galerieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, messageTableView.frame.size.width - 0.8)


        self.botObserveMessage()
        self.userObserveMessage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPress(_ sender: Any) {
        //DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            // Put your code which should be executed with a delay here
      
            if !(self.messageTextField.text?.isEmpty)!{
                guard let content = self.messageTextField.text else {return}
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "textMessage", sentBy: "user")
            MessageServices.create(message: message) { (message) in
                
            
                self.messages.insert(message, at: 0)
                
            }
        }
              //})
    }
    
    
    func observeIncomingMessage(completion: @escaping(Message)->()){}
    
    func botObserveMessage(){
        BotServices.botObserverMessage { (sent) in
            
            print(sent ?? "")
        }
    }
    func userObserveMessage(){
        UserServices.observeNewMessage { (message) in
            if let msg = message{
                self.messages.insert(msg, at: 0)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        MessageServices.fetchMessages { (msg) in
            if let msg = msg{
                
                let message = msg.sorted(by: {$0.time > $1.time})
                self.messages = message
            }
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
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextMessageSentTableViewCell
            cell.messageLabel.text = message.content
            return cell
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        let message = messages[indexPath.row]
    //        let content = message.content
    //        return 0
    //    }
    
    
    
    
}

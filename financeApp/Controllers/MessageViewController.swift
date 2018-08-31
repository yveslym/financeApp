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

      self.botObserveMessage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func sendButtonPress(_ sender: Any) {
    
        if !(messageTextField.text?.isEmpty)!{
            guard let content = messageTextField.text else {return}
             let message = Message(time: Date().toString(), content: content, msgId: "", type: "textMessage", sentBy: "user")
            MessageServices.create(message: message) {
                self.messages.append(message)
                self.messageTableView.reloadData()
            }
        }
    }
    
    func botObserveMessage(){
        BotServices.botObserverMessage { (sent) in
            print(sent ?? "")
        }
    }
    func userObserveMessage(){
        UserServices.observeNewMessage { (message) in
            if let msg = message{
                self.messages.append(msg)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        MessageServices.fetchMessages { (msg) in
            if let msg = msg{
                self.messages = msg
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
        
        switch message.type{
        case "recievedTextMessage":
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "recievedMessage", for: indexPath) as! TextMessageRecievedTableViewCell
            cell.messageLabel.text = message.content
            return cell
            
        case "sentTextMessage":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TextMessageSentTableViewCell
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

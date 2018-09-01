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
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
   
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
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var galerieButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messageTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, messageTableView.frame.size.width - 0.8)

        self.delegate = self
        self.botObserveMessage()
        self.userObserveMessage()
        self.getMyBankCard()
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
                 self.messageTextField.text = ""
            MessageServices.create(message: message) { (message) in
                
            
                self.messages.insert(message, at: 0)
                
            }
        }
              //})
    }
    
//    func setUpSwipGesture(){
//        let swipeDown  = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestureDown(gesture:)))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        let swipeUp =  UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGestureUp(gesture:)))
//        swipeDown.direction = UISwipeGestureRecognizerDirection.up
//
//
//        cardView.addGestureRecognizer(swipeUp)
//        cardView.addGestureRecognizer(swipeDown)
//    }
//
//    @objc func respondToSwipeGestureDown(gesture: UIGestureRecognizer){
//        UIView.animate(withDuration: 1) {
//
//        }
//    }
//
//    @objc func respondToSwipeGestureUp(gesture: UIGestureRecognizer){
//
//    }
    
    
    @IBAction func addCardButtonTapped(_ sender: Any) {
       
         self.delegate.presentPlaidLink()
        
    }
    
    
    
    
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
    /// method to retieve all bank Account
    func getMyBankCard(){
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

// - Mark Collection View life cycle

extension MessageViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "card", for: indexPath) as! CardCollectionViewCell
        let user = User.current
        cell.cardHolder.text = user.name
        
        return cell
    }
    
//    func setUpCardView(){
//        let h = view.frame.height / 6
//        let w = view.frame.width + 20
//        let y = view.frame.height / 10
//        cardView.frame = CGRect(x: 0, y: y, width: w, height: h)
//    }
    
}

extension MessageViewController: plaidDelegate{
    
}


//
//  TestViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 9/11/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions
import Floaty

class TestViewController: BaseChatViewController, plaidDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Chat"
        self.messagesSelector.delegate = self
        self.chatItemsDecorator = DemoChatItemsDecorator(messagesSelector: self.messagesSelector)
        self.loadMessages()
        self.listenToBotMessage()
        self.setupShortcutButton()
        delegate = self
    }
     weak var delegate : plaidDelegate!
    var messages = [Message]()
    
    var messageSender: DemoChatMessageSender!
    let messagesSelector = BaseMessagesSelector()
    
    // add data source
    var dataSource: DemoChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
            self.messageSender = self.dataSource.messageSender
        }
    }
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender, messagesSelector: self.messagesSelector)
    }()
    
    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        textMessagePresenter.baseMessageStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        let photoMessagePresenter = PhotoMessagePresenterBuilder(
            viewModelBuilder: DemoPhotoMessageViewModelBuilder(),
            interactionHandler: DemoPhotoMessageHandler(baseHandler: self.baseMessageHandler)
        )
        photoMessagePresenter.baseCellStyle = BaseMessageCollectionViewCellAvatarStyle()
        
        return [
            DemoTextMessageModel.chatItemType: [textMessagePresenter],
            DemoPhotoMessageModel.chatItemType: [photoMessagePresenter],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }
    
    // - Mark: Create chat input item
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        items.append(self.createPhotoInputItem())
        return items
    }
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
            let message = Message(time: Date().toString(), content: text, msgId: "", type: "text", sentBy: "user")
            
            // send message to server
            
            MessageServices.create(message: message, completion: { (msg) in
            })
        }
        return item
    }
    
    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
}

extension TestViewController: MessagesSelectorDelegate {
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didSelectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
    
    func messagesSelector(_ messagesSelector: MessagesSelectorProtocol, didDeselectMessage: MessageModelProtocol) {
        self.enqueueModelUpdate(updateType: .normal)
    }
}

// -Mark: Message from server handler
extension TestViewController{
    func listenToBotMessage(){
        BotServices.botObserverMessage { (msg) in
            guard let message = msg else {return }
            if message.sentBy == "bot"{
                self.dataSource.addIncomingMessage(message: message)
            }
           
        }
    }
    func loadMessages(){
        MessageServices.fetchMessages { (messages) in
            guard let messages = messages  else { return self.welcomeMessage()}
            messages.forEach({ (message) in
                if message.sentBy == "user"{
                    self.dataSource.addTextMessage(message.content)
                    
                }
                else{
                    self.dataSource.addIncomingMessage(message: message)
                }
            })
        }
    }
    func welcomeMessage(){
        let message = Message(time: Date().toString(), content: "Welcome to finance app", msgId: "0000", type: "text", sentBy: "bot")
        self.dataSource.addIncomingMessage(message: message)
    }
    /// method to set up the short cut button
    private func setupShortcutButton(){
        let floaty = Floaty()
        floaty.frame.origin.x = 0
        floaty.addItem("Last Transaction", icon: UIImage(named: "transaction")) { (float) in
            let content = "get last transaction"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "user")
            
             self.dataSource.addTextMessage(content)
            MessageServices.create(message: message) { (message) in
                self.messages.insert(message, at: 0)
                floaty.close()
            }
        }
        floaty.addItem("Balance", icon:  UIImage(named: "wallet")) { (float) in
            let content = "what is my balance?"
            let message = Message(time: Date().toString(), content: content, msgId: "", type: "text", sentBy: "user")
            
            self.dataSource.addTextMessage(content)
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
           let chartView = UIStoryboard(name: "Chart", bundle: nil).instantiateInitialViewController()
            self.present(chartView!, animated: true)
            floaty.close()
        }
        floaty.size = 40
        floaty.paddingY = 100
        floaty.paddingX = 1
   
        self.view.addSubview(floaty)
    }
}













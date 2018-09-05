//
//  Plaid+Extensions.swift
//  financeApp
//
//  Created by Yves Songolo on 8/27/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation
import UIKit
import LinkKit
import SwiftOverlays

protocol plaidDelegate: class {
    func presentPlaidLink(sender: UIViewController)
    
}

extension plaidDelegate where Self: UIViewController {
    
    
    /// function to set-up and present Plaid UI
    func presentPlaidLink(sender: UIViewController){
        // KeyChainData.publicKey()
        let linkConfiguration = PLKConfiguration(key: KeyChainData.publicKey()!,
                                                 env: .sandbox,
                                                 product:.connect,
                                                 selectAccount: true,
                                                 longtailAuth: false,
                                                 apiVersion: .PLKAPILatest)
        
        linkConfiguration.clientName = "Finance App"
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(configuration: linkConfiguration, delegate: linkViewDelegate )
        
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            linkViewController.modalPresentationStyle = .formSheet;
        }
        sender.showWaitOverlayWithText("Authenticating...")
        self.present(linkViewController, animated: true, completion: nil)
        
    }
}


extension UIViewController: PLKPlaidLinkViewDelegate{
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: metadata!, options: .sortedKeys)
            let bank = try JSONDecoder().decode(Bank.self, from: jsonData)
            
            plaidOperation.itemAccess(publicToken: publicToken, completion: { (itemAccess) in
                self.updateOverlayText("retrieving bank data..")
                bank.itemAccess = itemAccess
                plaidOperation.accounts(bank: bank, completion: { (accounts) in
                    
                        bank.accounts = accounts
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy"
                    let endDate = Date()
                    let startDate = Calendar.current.date(byAdding: .day, value: -360, to: endDate)
                    self.updateOverlayText("retrieving transaction..")
                    plaidOperation.transactionFromPlaid(with: bank, startDate: startDate!, endDate: endDate, completion: { (allTransaction) in
                        
                        if allTransaction != nil{
                            
                           
                            
                            // insert each transaction in the respective account
                            allTransaction?.forEach({ (transaction) in
                                bank.accounts?.forEach({ (account) in
                                    if transaction.accountID == account.id{
                                        //transaction.account = account
                                        account.transactions.append(transaction)
                                    }
                                })
                            })
                            plaidOperation.getBalance(with: bank, completion: { (balance) in
                                //bank.balanaces = balance
                                 self.updateOverlayText("operation completed...")
                                plaidServices.createBank(bank, completion: {
                                    print("bank uploaded")
                                    self.removeAllOverlays()
                                })
                            })
                           
                           
                            
                        }
                    })
                })
            })
            
            self.dismiss(animated: true, completion: nil)
            self.reloadInputViews()
        }
        catch{
            print("Failure in Extension LinkBankAccountController", error)
        }
    }
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        let alert = UIAlertController(title: "Failure",
                                      message:  "error: \(error?.localizedDescription ?? "nothing")\nmetadata: \(metadata!)",
            preferredStyle: UIAlertControllerStyle.alert)
        print("Alerts view can be ported us")
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didHandleEvent event: String, metadata: [String : Any]?) {
        if event == "EXIT"{
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}



//
//  ViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 8/27/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import ApiAI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        BotServices.apiAIRequest(question: "transaction") { (response) in
            print(response ?? "bummer there's error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


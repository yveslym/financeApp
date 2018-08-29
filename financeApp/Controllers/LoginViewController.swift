//
//  LoginViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import SnapKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet var registerView: UIView!
    @IBOutlet var loginView: UIView!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backToRegisterButton: UIButton!
    @IBOutlet weak var registerFullName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var backToLoginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookSignUpButton: FBSDKButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        setUpLoginView()
        setUpRegisterView()
         self.view.addSubview(loginView)
         self.view.addSubview(registerView)
        registerView.frame.origin.y = loginView.frame.maxY
        
        
    }
    func setUpLoginView(){
        let height = view.frame.height - (view.frame.height / 6)
        let widght = view.frame.width - (view.frame.width / 8)
        let y = view.frame.midY / 2
        let x = view.frame.midX / 4
        loginView.frame = CGRect(x:  x , y: y, width: widght, height: height)
        let center = view.center
         loginView.center = center
       loginView.frame.origin.y = 0
       
        
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 20
    }

    func setUpRegisterView(){
        let height = view.frame.height - (view.frame.height / 6)
        let widght = view.frame.width - (view.frame.width / 8)
        let y = view.frame.midY / 2
        let x = view.frame.midX / 4
        let center = view.center
        registerView.frame = CGRect(x:  x , y: y, width: widght, height: height)
        registerView.center = center
        registerView.frame.origin.y = 120//view.frame.maxY
       
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 20
    }

    @IBAction func backToLoginButtonTapped(_ sender: Any) {
        let animation = {
            
            let leftOver = self.view.frame.height - self.loginView.frame.height
            let loginY = self.loginView.frame.height - leftOver
            self.loginView.frame.origin.y = -loginY
            self.registerView.frame.origin.y = self.loginView.frame.maxY
        }
          UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut,.curveEaseIn], animations: animation, completion: nil)
        backToLoginButton.isEnabled = false
        backToRegisterButton.isEnabled = true
    }
    @IBAction func backToRegisterButtonTapped(_ sender: Any) {
        let animation = {
           
            self.loginView.frame.origin.y = 0
            self.registerView.frame.origin.y = self.loginView.frame.maxY
        }
      UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: animation, completion: nil)
        backToLoginButton.isEnabled = true
        backToRegisterButton.isEnabled = false
    }
    
    
   

}

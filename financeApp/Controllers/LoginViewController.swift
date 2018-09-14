//
//  LoginViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 8/28/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftOverlays

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
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookSignUpButton: UIButton!
    
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoImageView.alpha = 0
        setUpLoginView()
        setUpRegisterView()
         self.view.addSubview(loginView)
         self.view.addSubview(registerView)
        registerView.frame.origin.y = loginView.frame.maxY - 50
        
        GIDSignIn.sharedInstance().uiDelegate = self
       
    }
    func setUpLoginView(){
        let height = view.frame.height - (view.frame.height / 6)
        let widght = view.frame.width - (view.frame.width / 8)
       
        let x = view.frame.midX / 4
        loginView.frame = CGRect(x:  view.frame.maxX , y: 20, width: widght, height: height)
        let center = view.center
         loginView.center = center
        loginView.frame.origin.x = view.frame.maxX
       //loginView.frame.origin.y = 20
       
        
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
        registerView.frame.origin.x = -view.frame.width
        registerView.frame.origin.y = self.view.frame.height - loginView.frame.height//view.frame.maxY
        
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
         let x = view.frame.midX / 4
        let animateX = {
            self.loginView.center = self.view.center
        }
        let animateRx = {
            self.registerView.center.x = self.view.center.x
        }
        
        let showLogo = {
            self.logoImageView.alpha = 1
        }
        
        let rotateLogo = {
            self.logoImageView.transform = self.logoImageView.transform.rotated(by: CGFloat(Double.pi ))
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn], animations: animateX, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: animateX) { (finish) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: animateRx) { (finish) in
                UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: showLogo) { (finish) in
                    
//                    UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat], animations: rotateLogo) { (finish) in
//                        UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: rotateLogo) { (finish) in
//                            
//                        }
//                    }
                }

            }
        }
        
       
        
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
       
        let alert = UIAlertController(title: "forgot Password?", message: "please enter your new password and don't forget this time 😎", preferredStyle: .alert)
        var email = UITextField()
        alert.addTextField { textField -> Void in
            email = textField
        }

        let cancel = UIAlertAction(title: "Return", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.showWaitOverlayWithText("sending...")
            UserServices.sendEmailForgetPassword(email: email.text!, completion: { (error) in
                if let error = error{
                    self.presentAlert(title: "Oppss", message: error)
                    self.removeAllOverlays()
                }
                self.updateOverlayText("sent")
                self.removeAllOverlays()
            })
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert,animated: true)
    }
    

    

    @IBAction func backToLoginButtonTapped(_ sender: Any) {
        let animation = {
            
            let leftOver = self.view.frame.height - self.loginView.frame.height
            let loginY = self.loginView.frame.height - leftOver
            self.loginView.frame.origin.y = -loginY
            self.registerView.frame.origin.y = self.loginView.frame.maxY
        }
          UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionCrossDissolve], animations: animation, completion: nil)
        backToLoginButton.isEnabled = false
        backToRegisterButton.isEnabled = true
    }
    @IBAction func backToRegisterButtonTapped(_ sender: Any) {
        let animation = {
           
            self.loginView.frame.origin.y = 0
            self.registerView.frame.origin.y = self.loginView.frame.maxY
        }
      UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn, .curveEaseOut], animations: animation, completion: nil)
        backToLoginButton.isEnabled = true
        backToRegisterButton.isEnabled = false
    }

    @IBAction func googleButtonTapped(_ sender: Any) {
        
         GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let login = FBSDKLoginManager()
        
        login.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("Process error")
            } else if result?.isCancelled != nil {
                print("Cancelled")
            } else {
                
                print("Logged in")
                
                guard (FBSDKAccessToken.current()) != nil else {return}
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if error != nil {
                        // ...
                        return
                    }
                    // User is signed in
                    UserServices.loginWithFacebook(sender: self, completion: { (user) in
                        if user != nil{
                            User.setCurrent(user!, writeToUserDefaults: true)
                            //self.performSegue(withIdentifier: "message", sender: nil)
                            let viewC = TestViewController()
                            self.present(viewC,animated: true)
                        }
                    })
                }
            }
        }
    }
    @IBAction func loginButtonTapped(_ sender: Any){
        self.showWaitOverlayWithText("Checking Authentification...")
        let email = loginEmail.text
        let password = loginPassword.text
        if (email?.count)! > 4 && (password?.count)! > 4 {
            
            UserServices.loginWithEmail(password!, email: email!, signUpType: .login) { (usr) in
                if let usr = usr{
                    self.updateOverlayText("Login Success")
                User.setCurrent(usr,writeToUserDefaults: true)
               
                    self.removeAllOverlays()
                    // open next page
                    let vc = TestViewController()
                    MessageServices.fetchMessages(completion: { (messages) in
                        if messages != nil{
                            let dataSource = DemoChatDataSource(messages: DemoChatMessageFactory.initServerMessage(messages: messages!), pageSize: 50)
                            vc.dataSource = dataSource
                        }
                        else{
                            let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
                            vc.dataSource = dataSource
                        }
                       self.present(vc,animated: true)
                    })
                    
                }
                else{
                     self.removeAllOverlays()
                    self.presentAlert(title: "Authentication error", message: "check your username or password")
                    self.removeAllOverlays()
                    print("no user")
                }
            }
        }
    }
    @IBAction func registerButtonTapped(_ sender: Any){
        let email = registerEmail.text
        let password = registerPassword.text
        let name = registerFullName.text
        let user = User(name: name!, email: email!)
        self.showWaitOverlayWithText("Register User")
        UserServices.loginWithEmail(password, email: email!, user: user, signUpType: .register) { (user) in
            if let user = user{
                self.updateOverlayText("login success")
                User.setCurrent(user, writeToUserDefaults: true)
                self.removeAllOverlays()
                let vc = TestViewController()
                let dataSource = DemoChatDataSource(count: 0, pageSize: 50)
                vc.dataSource = dataSource
                self.present(vc,animated: true)
            }
            else{
               self.presentAlert(title: "Error", message: "Please fill the form correctly")
            }
        }
        
    }
}



/// authenticate with google
extension LoginViewController: GIDSignInUIDelegate{
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        
        
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // ...
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error == nil {
                self.presentAlert(title: "Login Error", message: "coun't register please try again!!!")
                return
            }
            // User is signed in
            // register user
            UserServices.loginWithGoogle(googleUser: user, completion: { (user) in
                if user != nil{
                    User.setCurrent(user!, writeToUserDefaults: true)
                    self.performSegue(withIdentifier: "message", sender: nil)
                }
                else{
                    self.presentAlert(title: "Login Error", message: "coun't register please try again!!!")
                }
            })
        }
    }
    
    
    
}

// - Mark: Auth with Facebook

extension LoginViewController: FBSDKLoginButtonDelegate{
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard (FBSDKAccessToken.current()) != nil else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                // ...
                return
            }
            // User is signed in
            UserServices.loginWithFacebook(sender: self, completion: { (user) in
                if user != nil{
                    User.setCurrent(user!, writeToUserDefaults: true)
                    self.performSegue(withIdentifier: "client", sender: nil)
                }
            })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}

























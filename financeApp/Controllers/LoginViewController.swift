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
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        setUpLoginView()
        setUpRegisterView()
         self.view.addSubview(loginView)
         self.view.addSubview(registerView)
        registerView.frame.origin.y = loginView.frame.maxY
        
        GIDSignIn.sharedInstance().uiDelegate = self
       
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
                            self.performSegue(withIdentifier: "client", sender: nil)
                        }
                    })
                }
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
                    self.performSegue(withIdentifier: "client", sender: nil)
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
























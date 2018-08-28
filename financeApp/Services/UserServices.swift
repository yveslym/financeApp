//
//  UserServices.swift
//  Linner
//
//  Created by Yves Songolo on 8/21/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import GoogleSignIn
import FBSDKLoginKit


struct UserServices{
    // method to create new user
    static func create(user: User, completion: @escaping(User?)->()){
        
        InstanceID.instanceID().instanceID { (result, _) in
        user.deviceToken = result?.token
        
        let authUser = Auth.auth().currentUser
      
        let ref = Database.database().reference().child("Users").child((authUser?.uid)!)
        ref.setValue(user.toDictionary()) { (error, _) in
            if error != nil{
                return completion(nil)
            }
            return completion(user)
        }
    }
}
    // method to retrieve user from firebase
    static func show(completion: @escaping(User?)-> ()){
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child("Users").child(uid!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists(){
                let user = try! JSONDecoder().decode(User.self, withJSONObject: snapshot.value!)
                return completion(user)
            }
            else{
                return completion(nil)
            }
        }
    }
    /// method to add google user to firrebase
    static func loginWithGoogle(googleUser: GIDGoogleUser, completion: @escaping(User?) -> ()){
        let profile = googleUser.profile
        let user = User(fn: (profile?.givenName)!, ln: (profile?.familyName)!, un: (profile?.name)!, deviceToken: "", accountType: "client", email: (profile?.email)!)
        if (profile?.hasImage)!{
        user.profileUrl = profile?.imageURL(withDimension: 300).absoluteString
        }
        
        show { (existingUser) in
            if existingUser == nil{
                create( user: user) { (created) in
                    if (created != nil){
                       return completion(created!)
                    }
                    else{
                        print("couldn't create user")
                        completion(nil)
                    }
                }
            }
            else{
                return completion(existingUser)
            }
        }
    }
    
    static func loginWithEmail(_ password: String, user: User, completion: @escaping(User) -> ()){
        
        Auth.auth().signIn(withEmail: user.email, password: password) { (result, error) in
            if error == nil{
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                create(user: user, completion: { (usr) in
                    completion(usr!)
                })
            }
        }
    }
    static func updatePassWord(_ password: String, email: String, completion: @escaping() ->()){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            // ...
        }
    }
    
    static func sendEmailForgetPassword(_ password: String, email: String, completion: @escaping() ->()){
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
       
        actionCodeSettings.url =
            URL(string: "financeapp-d1c74.firebaseapp.com/?email=%@\(email)")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { (error) in
            
            if error == nil{
                
            }
        }
    }
    
    static func emailVerification(email: String, completion: @escaping(Bool) ->()){
        
        Auth.auth().useAppLanguage()
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if error == nil{
                completion(true)
            }
        }
       
    }
    
    static func loginWithFacebook(sender: UIViewController,completion: @escaping(User?)->()){
        FBSDKProfile.loadCurrentProfile(completion: { profile, error in
            if let profile = profile {
                guard let authUser = Auth.auth().currentUser else {
                    print("user is not auth")
                    return completion(nil)
                    
                }
             
                let user = User(fn: profile.firstName, ln: profile.lastName, un: profile.name, deviceToken: "", accountType: "client", email: authUser.email!, profileUrl: profile.imageURL(for: .square, size: CGSize(width: 100, height: 100)).absoluteString)
                
                /// fetch user from database
                show(completion: { (databaseUser) in
                    if let databaseUser = databaseUser{
                        completion(databaseUser)
                    }
                    else{
                        /// create user if first time login
                        create(user: user, completion: { (createdUser) in
                            if let user = createdUser{
                                completion(user)
                            }
                            else{
                                print("user wasn't create in the database")
                                completion(nil)
                            }
                        })
                    }
                })
                
            }
        })
    }
    
}

extension JSONEncoder {
    func encodeJSONObject<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try encode(value)
        return try JSONSerialization.jsonObject(with: data, options: opt)
    }
}

extension JSONDecoder {
    func decode<T: Decodable>(_ type: T.Type, withJSONObject object: Any, options opt: JSONSerialization.WritingOptions = []) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: object, options: opt)
        return try decode(T.self, from: data)
    }
}



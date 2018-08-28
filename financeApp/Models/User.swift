//
//  User.swift
//  Linner
//
//  Created by Yves Songolo on 8/21/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import Foundation

class User: Codable{
    let firstName: String
    let lastName: String
    let userName: String
    var deviceToken: String?
    let accountType: String
    let email: String
    var profileUrl : String?
    
    private static var _current: User?
    
    static var current: User {
        if let currentUser = _current  {
            return currentUser
        }
        else{
            let data =   UserDefaults.standard.value(forKey: "current") as? Data
            let user = try! JSONDecoder().decode(User.self, from: data!)
            return user
        }
       
    }
    
    // MARK: - Class Methods
    
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        if writeToUserDefaults {
            if let data = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(data, forKey: "current")
            }
        }
        
        _current = user
    }
    

    
    init(fn: String, ln: String, un: String, deviceToken: String, accountType: String, email: String, profileUrl: String? = nil){
        self.firstName = fn
        self.lastName = ln
        self.deviceToken = deviceToken
        self.accountType = accountType
        self.userName = un
        self.email = email
        if let url = profileUrl{
            self.profileUrl = url
        }
    }
    func toDictionary() -> [String: Any]{
        return["firstName": firstName,
               "lastName": lastName,
               "deviceToken": deviceToken ?? "",
            "accountType":accountType,
            "userName":userName,
            "profileUrl":profileUrl ?? "",
            "email":email]
    }
}



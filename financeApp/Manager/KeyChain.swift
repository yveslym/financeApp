//
//  KeyChain.swift
//  Core-Project
//
//  Created by Yveslym on 11/13/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation
import KeychainSwift

struct KeyChainData{
    static func setUpKeyChain(){
       let keychain = KeychainSwift()
        keychain.set("7a252d1d8479d0e9021455c134d8f8", forKey: "publicKey")
        keychain.set("5a317eb9bdc6a45a22c6afc3", forKey: "clientId")
        keychain.set("bc7625e412eb3fd57739fa6d181146", forKey: "secret")
    }
    
    static func publicKey()->String?{
        return KeychainSwift().get("publicKey")!
    }
    
    static func clientId()-> String?{
        return KeychainSwift().get("clientId")!
    }
    static func secret()-> String?{
        return KeychainSwift().get("secret")!
    }
}

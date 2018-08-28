  //
//  Networking.swift
//  Core-Project
//
//  Created by Yveslym on 11/9/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

  
class Networking{
    
    static func network(bank: Bank? = nil, route: Route, apiHost: ApiHost, date:[Date]? = nil, public_token: String? = nil,completion:@escaping(Data?)->Void){
        
        // - MARK: Properties
        
        guard let clientId = KeyChainData.clientId(), let secret = KeyChainData.secret() else {return}
        
        
    // get the url by combing the base url and access point
        let baseURL = apiHost.baseLink()
        let path = route.accessPoint()

        guard let url = URL(string: baseURL+path) else {return}
    
        var request = URLRequest(url: url)
        
    // get the http body
        switch (route) {
        
            
            
        case .transactions:
            request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.itemAccess?.accessToken, startDate: date?[0], endDate: date?[1])
        case .auth:
            request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .identity:
             request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .income:
             request.httpBody = route.jsonBody(client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .balance:
            request.httpBody = route.jsonBody(bank: bank, client_id: clientId, secret: secret, access_token: bank?.access_token)
        case .exchangeToken:
            request.httpBody = route.jsonBody(client_id: clientId, secret: secret, public_token: public_token)
        case .accounts:
            request.httpBody = route.jsonBody(bank: bank, client_id: clientId, secret: secret, access_token: bank?.itemAccess?.accessToken)
        }
    
    request.httpMethod = "POST"
    //request.addValue("content-Type", forHTTPHeaderField: "application/json")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
    
    let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            
            do{
                let resp = response as? HTTPURLResponse
                print(resp!)
                guard let data = data else{return}
                return completion(data)
            }
    }
 task.resume()
}
}






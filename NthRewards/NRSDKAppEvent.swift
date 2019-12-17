//
//  NRSDKAppEvent.swift
//  NthRewards
//
//  Created by akshay on 12/13/19.
//  Copyright © 2019 akshay. All rights reserved.
//

import Foundation

protocol NRSDKApplicationDelegate {
    func sessionStared()
    func sessionfailed()
}

public class NRSDKAppEvent {
    
    private init(){}
    
    public static func activateApp(){
        
        if !isSessionValid(){
            
            let parameter = ["client_id": "\(Base.CLIENT_ID)", "client_secret": "\(Base.CLIENT_SECRET)", "grant_type": "client_credentials"]
            self.callAPI(service: .token, parameters: parameter)
            
        }
        
    }
    
    
    private static func callAPI(service : Services , parameters : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: parameters, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                break
                
                
            case .sucess:
                if service == .token {
                    self.handleTokenResponse(responseDict: dictData as! [String : Any])
                    
                }
                break
                
            }
            
        })
    }
    
    public static func isSessionValid() -> Bool {
        if let expiryTime = Utility.userDefault(key: keyUD.k_expiryTime) as? String {
            let currentTimeStamp = Date().toMillis()
            if currentTimeStamp! > Int64(expiryTime)!{
                
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    static func token() -> String?{
        return Utility.userDefault(key: keyUD.k_token) as? String
    }
    
    private static func handleTokenResponse(responseDict : [String : Any]){
        
        guard let access_token = responseDict["access_token"] as? String else {return}
        guard let token_type = responseDict["token_type"] as? String else {return}
        
        if let expiresIn = responseDict["expires_in"] as? Int64 {
            let currentTimeStamp = Date().toMillis()
            let addValue = currentTimeStamp! + expiresIn
            Utility.saveUserDefault(value: String(addValue), key: keyUD.k_expiryTime)
        }
        
        Utility.saveUserDefault(value: token_type + " \(access_token)", key: keyUD.k_token)
        
    }
}

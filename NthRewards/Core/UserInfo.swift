//
//  LoginModel.swift
//  Sparehub
//
//  Created by gaurav on 06/03/19.
//  Copyright © 2019 clavax. All rights reserved.
//

import Foundation

struct UserInfo : Codable {
    
    var data : UserData?
    var message : String?
    var totalCount : Int?
    var errors : [Errors]?
    
}

struct  UserData : Codable {
    var customercode : String?
    var defaultcard : String?
    var discriminator : String?
    var ismobileverified : Bool?
    var mobile : String?
    
}

struct Errors : Codable {
    var detail:String?
    var status:Int?
    var title:String?
}

extension UserInfo {
    
    static func getUserInformation() -> UserInfo? {
        
        if let data : Data = (UserDefaults.standard.value(forKey: keyUD.k_UserInfo) as? Data) {
            guard let objModel = try? PropertyListDecoder().decode(UserInfo.self, from: data) else {
                return nil
            }
            return objModel
        }
        return nil
    }
    
}


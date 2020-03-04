//
//  UserProfileInfo.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 14/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct UserProfileInfo  : Codable{
    var totalCount :Int?
    var message : String?
    var data : UserProfileInfoData?
    
}

struct UserProfileInfoData : Codable {
    var mobile : String?
    var defaultcard : String?
    var ismobileverified : Bool?
    var discriminator : String?
    
    var customercode : String?
    var name : String?
    var dob : String?
    var email : String?
    var gender : String?
    var lastName : String?
    var createdAt : String?
    
    var wallet : Wallet?
    //var participantWallet : [ParticipantWallet]?
    var isPasswordSet : Bool?
    
    
}

struct Wallet :Codable{
    var point : Double?
    var currency : Int?
    var discount : Int?
}


struct ParticipantWallet : Codable{
    
}


extension UserProfileInfo {
    
    static func getUserProfile() -> UserProfileInfo? {
        
        if let data : Data = (UserDefaults.standard.value(forKey: keyUD.k_UserProfileInfo) as? Data) {
            guard let objModel = try? PropertyListDecoder().decode(UserProfileInfo.self, from: data) else {
                return nil
            }
            return objModel
        }
        return nil
    }
    
}

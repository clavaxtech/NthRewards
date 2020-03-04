//
//  BannerModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 27/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct BannerModal : Codable {
    var data : [Banner]?
    var message : String?
    var success : Bool?
    
}

struct Banner : Codable {
    var category : String?
    var client_code : String?
    var code : String?
    var end_date : String?
    var image : String?
    var offer_code : String?
    var start_date : String?
    var title : String?
}

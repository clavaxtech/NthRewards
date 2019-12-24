//
//  OfferDetailModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 31/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct OfferDetailModal : Codable {
    var data : OfferDetail?
    var message : String?
    var totalCount : Int?
}


struct OfferDetail : Codable {
    
    var offerDetailResponse : offerDetailResponseData?
    //var offerActivationResponse : Dictionary<String, Any>?
    
}



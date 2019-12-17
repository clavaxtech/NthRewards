//
//  LatestOfferModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 27/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation
import UIKit


struct LatestOfferModal : Codable {
    var data : [OfferModal]?
    var totalCount : Int?
    var message : String?
}


struct OfferModal : Codable {
    
    var offerDetailResponse : offerDetailResponseData?
    
}

struct offerDetailResponseData : Codable {
    
    var code : String?
    var data : [[OfferDetailResponse]]?
    var description : String?
    var endDateTime : String?
    var escalationMatrix : String?
    var externalLink : String?
    var imageLink : String?
    var internalLink : String?
    var logoImageLink : String?
    var longDescription : String?
    var mobileImageLink : String?
    var offerCode : String?
    var programCode : Int?
    var purchaseable : offerDetailResponseArrayPurchaseable?
    var redemptionProcess : String?
    var startDateTime : String?
    var status : Bool?
    var tags : [offerDetailResponseArrayTag]?
    var termAndCondition : String?
    var title : String?
    var visibilityDateTime : String?
    
    
}

struct OfferDetailResponse : Codable {
    
    var CapLimit : Int?
    var RedeemType : String?
    var RewardRatio : Int?
    var Sponsors : [Sponsor]?
    var TransactionField : String?
    var Value : Int?
    var expirationRule : ExpirationRule?
    var redeemRule : RedeemRule
    
}

struct ExpirationRule : Codable{
    var onAfter : Bool?
}

struct RedeemRule : Codable{
    var afterSpecificTransaction : Bool?
    var redeemRuleBy : Bool?
}



struct Sponsor : Codable {
    
    var Percent : Int?
    var SponsorType : String?
    
}


//Tag
struct offerDetailResponseArrayTag : Codable {
    var TagKey : String?
    var values : [offerDetailResponseArrayTagValues]?
}

struct offerDetailResponseArrayTagValues : Codable{
    var Name : String?
    var color : String?
}

//Purchasable
struct offerDetailResponseArrayPurchaseable : Codable{
    var isActivated : Bool?
    var isPurchaseable : Bool?
    var price : Int?
    var validityPeriod : Int?
    var validityPeriodType : Int?
    
}

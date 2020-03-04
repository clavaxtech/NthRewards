//
//  GiftCardModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 29/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation



struct GiftCardModal : Codable {
    var data : [GiftCard]?
    
}

struct GiftCard : Codable {
    
    var brand_code : String?
    var campaign_code : String?
    var category_code : String?
    var code : String?
    var default_vendor_code : String?
    var description : String?
    var image : String?
    var is_featured : Bool?
    var status : Int?
    var title : String?
    //var validity : Validity?
    var vendors : [Vendors]?
    
    
  

}

struct Validity : Codable {
    var end_date : String?
    var start_date : String?
    var unit : String?
    var value : String?
    
}

struct Vendors : Codable {
    
    var denominations : [Denominations]?
    var max_quantity : String?
    var tnc : String?
    var vendor_code : String?
    var vendor_name : String?
    
}


struct Denominations : Codable {
    var fix_value : Int?
    var max_value : String?
    var min_value : String?
    var value_type : String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Int.self, forKey: .fix_value) {
            fix_value = value
        } else if let value = try? container.decode(String.self, forKey: .fix_value) {
            fix_value = Int(value)
        }
    }
}

//
//  PlaceOrderModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 18/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation



struct PlaceOrderModal : Codable{
    var data : PlaceOrderModalData?
    var message :String?
    var success : Bool?
}

struct PlaceOrderModalData : Codable{
    var billing_address : BillingAddress?
    var cart_code : String?
    var code : String?
    var item_list : [ItemListProduct]?
    var novus_transaction_id : String?
    var order_date : String?
    var order_status : Int?
    var payment_status : Int?
    var razorpay_payment_id : String?
    var shipping_address : BillingAddress?
    var tax : Int?
    var total_payment : Int?
    var total_points_redeemed : Int?
    var user_code : String?
    
}

struct BillingAddress : Codable {
    var address_line1 : String?
    var address_line2 : String?
    var city : String?
    var email : String?
    var firstname : String?
    var lastname : String?
    var mobile : String?
    var state : String?
    var zip : String?
}

struct ItemListProduct : Codable {
    var amount : Int?
    var denomination : Int?
    var discount_price : Int?
    var image : String?
    var item_type : String?
    var name : String?
    var payment_status : Int?
    var product_code : String?
    var quantity : String?
    var redeem_points : Int?
    var refno : String?
    var status : Int?
    var title : String?
    var vendor_code : String?
    var vendor_item_id : String?
    var vendor_order_id : String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? container.decode(Int.self, forKey: .amount) {
            amount = value
        }
        
        if let value = try? container.decode(Int.self, forKey: .denomination) {
            denomination = value
        }
        if let value = try? container.decode(Int.self, forKey: .discount_price) {
            discount_price = value
        }
        if let value = try? container.decode(String.self, forKey: .image) {
            image = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey: .name) {
            name = String(value)
        }
        
        if let value = try? container.decode(String.self, forKey: .quantity) {
            quantity = String(value)
        }
        if let value = try? container.decode(Int.self, forKey: .redeem_points) {
            redeem_points = value
        }
        if let value = try? container.decode(String.self, forKey: .title) {
            title = String(value)
        }
        
        if let value = try? container.decode(Int.self, forKey: .vendor_item_id) {
            vendor_item_id = String(value)
        }else if let value = try? container.decode(String.self, forKey: .vendor_item_id) {
            vendor_item_id = value
        }
        
    }
}





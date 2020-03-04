//
//  MyOrderModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 25/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct MyOrderModal : Codable{
    var data : [MyOrderModalData]?
    var message : String?
    var success : Bool?
    var total_count : Int?
}

struct MyOrderModalData : Codable{
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
    var tax : String?
    var total_payment : Int?
    var total_points_redeemed : Int?
    var user_code : String?
}

//
//  AddToCardModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 11/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation

struct AddToCardModal : Codable{
    var data : AddToCard?
    var message : String?
    var success : Bool?
}

struct AddToCard : Codable {
    var code : String?
    var delivery_charge : Int?
    var total : Int?
    var user_code : String?
    var products_list : [ProductList]?
}

struct ProductList : Codable{
    
    var denomination : String?
    var discount_price : String?
    var item_type : String?
    var message : String?
    var image : String?
    var name : String?
    var product_code : String?
    var quantity : String?
    var receiver_email : String?
    var receiver_mobile : String?
    var receiver_name : String?
    var sender_name : String?
    
    var discounted_price : String?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let denominationValue = try? container.decode(String.self, forKey: .denomination) {
            denomination = denominationValue
        }else if let denominationValue =  try? container.decode(Int.self, forKey: .denomination) {
            denomination = String(denominationValue)
        }
        
        if let discountValue = try? container.decode(String.self, forKey: .discount_price) {
            discount_price = discountValue
        }else if let discountValue =  try? container.decode(Int.self, forKey: .discount_price) {
            discount_price = String(discountValue)
        }
        
        if let value = try? container.decode(String.self, forKey: .item_type) {
            self.item_type = value
        }
        
        if let value = try? container.decode(String.self, forKey: .message) {
            message = value
        }
        
        if let value = try? container.decode(String.self, forKey: .image) {
            image = value
        }
        
        if let nameT = try? container.decode(String.self, forKey: .name) {
            name = nameT
        }
        
        if let productcode = try? container.decode(String.self, forKey: .product_code) {
            product_code = productcode
        }
        
        if let value = try? container.decode(Int.self, forKey: .quantity) {
            quantity = String(value)
        }else if let value = try? container.decode(String.self, forKey: .quantity) {
            quantity = value
        }
        
        if let value = try? container.decode(String.self, forKey: .receiver_email) {
            receiver_email = value
        }
        
        if let value = try? container.decode(String.self, forKey: .receiver_mobile) {
            receiver_mobile = value
        }
        if let value = try? container.decode(String.self, forKey: .receiver_name) {
            receiver_name = value
        }
        
        if let value = try? container.decode(String.self, forKey: .sender_name) {
            sender_name = value
        }
        if let value = try? container.decode(String.self, forKey: .discounted_price) {
            discounted_price = value
        }
        
    }
    
}

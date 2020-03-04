//
//  ProductModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 29/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct ProductModal : Codable {
    var data : [Product]?
}

struct Product : Codable {
    
    //var attributes : [Attributes]?
    var brand_code : String?
    var category_code : String?
    var code : String?
    var description : String?
    var image : String?
    var price : Int?
    var quantity : String?
    var status : Int?
    var title : String?
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(String.self, forKey: .brand_code) {
            brand_code = value
        }
        
        if let value = try? container.decode(String.self, forKey: .category_code) {
            category_code = value
        }
        
        if let value = try? container.decode(String.self, forKey: .code) {
            code = value
        }
        
        if let value = try? container.decode(String.self, forKey: .description) {
            description = value
        }
        if let value = try? container.decode(String.self, forKey: .image) {
            image = value
        }
        
        
        if let value = try? container.decode(Int.self, forKey: .price) {
            price = value
        } else if let value = try? container.decode(String.self, forKey: .price) {
            price = Int(value)
        }
        
        if let value = try? container.decode(String.self, forKey: .quantity) {
            quantity = value
        }
        
        if let value = try? container.decode(Int.self, forKey: .status) {
            status = value
        }else if let value = try? container.decode(String.self, forKey: .status) {
            status = Int(value)
        }
        
        if let value = try? container.decode(String.self, forKey: .title) {
            title = value
        }
    }
    
}
//
//struct Attributes : Codable {
//
//}


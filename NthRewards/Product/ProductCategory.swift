//
//  ProductCategory.swift
//  nth Rewards
//
//  Created by akshay on 11/19/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation


struct ProductCategory : Codable {
    var data : [Category]?
    var message : String?
    var success : Bool?
    var total_count : Int?
    
    
}
struct Category : Codable{
    var category_type : String?
    var code : String?
    var description : String?
    var name : String?
    var value : String?
}

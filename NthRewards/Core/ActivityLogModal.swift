//
//  ActivityLogModal.swift
//  nth Rewards
//
//  Created by akshay on 11/6/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation

struct ActivityLogModal : Codable {
    
    //Testing
    //Testing
    
    
    
    
    
    var data : [Logs]?
    var message : String?
    var totalCount : Int?
}

struct Logs : Codable {
    var action : String?
    var activityDateTime : String?
    var customercode : String?
    var description : String?
    var discriminator : String?
    var id : String?
    var module : String?
    
    var sectionDate : String {
         return Utility.UTCToLocal(date:activityDateTime ?? "" , fromFormat: DateFormat.utc2.rawValue, toFormat: DateFormat.shortStyle.rawValue)
    }
    
    
}




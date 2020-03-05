//
//  RegisterModel.swift
//  MVVMExample
//
//  Created by Gaurav Bajaj on 03/01/19.
//  Copyright © 2019 clavax. All rights reserved.
//

import Foundation

struct textFieldStruct {
    
    var name : String = ""
    var firstname : String = ""
    var lastName : String = ""
    var email : String = ""
    var phone: String = ""
    var password : String = ""
    var confirm: String = ""
    var firstField: String = ""
    var secondField: String = ""
    var thirdField: String = ""
    var fourthField: String = ""
    var oldPasswd: String = ""
    var newPasswd: String = ""
    var retype: String = ""
    
    // MARK: - OTP SCREEN
    init(firstField : String, secondField: String, thirdField: String, fourthField: String) {
        self.firstField = firstField
        self.secondField = secondField
        self.thirdField = thirdField
        self.fourthField = fourthField
    }
    
    // MARK: - CHANGE PASSWORD
    init(oldPasswd : String, newPasswd: String, retype: String) {
        self.oldPasswd = oldPasswd
        self.newPasswd = newPasswd
        self.retype = retype
        
    }
    
    // For Registration
    init(firstname : String, lastName: String, email: String, phone: String, password: String, confirm: String) {
        self.firstname = firstname
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.password = password
        self.confirm = confirm
        
    }
    
    init(phone: String, password: String) {
        
        self.phone = phone
        self.password = password
        
        
    }
    
    init(name : String , email : String , phone:String , password : String , confirm : String) {
        self.name = name
        self.email = email
        self.phone = phone
        self.password = password
        self.confirm = confirm
    }
    
    // For Forgot Password
    init(email : String) {
        self.email = email
    }
    
    // For Login
    init(email : String, password : String) {
        self.email = email
        self.password = password
    }
    
    // For Reset Password.
    init(password : String) {
        self.password = password
    }
    
}



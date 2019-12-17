//
//  File.swift
//  MVVMExample
//
//  Created by gaurav on 15/01/19.
//  Copyright © 2019 clavax. All rights reserved.
//

enum ATType {
    case sucess
    case fail
}

typealias callBack = (_ data:Any?,_ type:ATType)-> Void

struct ATCallBack {
    
    let name : String?
    let type : ATType
    let completion : callBack
    
    init(namee:String,typee:ATType,comletionn: @escaping callBack) {
        
        name = namee
        type = typee
        completion = comletionn
        
    }
    
}

//
//  EditProfileViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/8/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class EditProfileViewModal: NSObject {
    
    public var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingEditProfileViewModal : ((_ data : Any , _ serviceType : Services) ->())?
    
    public func getCustomerInfo(){
        
        if let mobileNumber = UserInfo.getUserInformation()?.data?.mobile   {
            let parameters = [ "mobile": "\(mobileNumber)"]
            self.populateData(service: .getCustomer, params: parameters)
        }
    }
    
    public func callEditCustomerApi(params : [String:Any]){
        
        self.populateData(service: .customer, params: params)
        
    }
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in MyAccountViewModal")
                
                self.showAlert?(dictData as? String , service)
                break
                
            case .sucess:
                
                switch service {
                    
                case .customer:
                    self.handleEditCustomerResponse(responseDict: dictData as! [String : Any])
                    
                case .getCustomer:
                    self.handleGetCustomerResponse(responseDict: dictData as! [String : Any])
                default:
                    break
                }
                break
            }
            
        })
        
    }
    
    func handleEditCustomerResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objectInfo  = try objDecoder.decode(UserProfileInfo.self, from: jsonData)
            
            self.bindingEditProfileViewModal?(objectInfo,.customer)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
    func handleGetCustomerResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objectInfo  = try objDecoder.decode(UserProfileInfo.self, from: jsonData)
            
            self.bindingEditProfileViewModal?(objectInfo,.getCustomer)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
}

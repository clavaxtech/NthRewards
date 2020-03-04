//
//  OfferDetailVM.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 31/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation



class OfferDetailVM {
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingOfferDetailViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    private (set) var offerDetailModal = OfferDetail()
    
    public var offerObject : OfferModal?
    
    public var offerCode : String?
    
    
    
    public func callAPIService(offerCode:String?){
        
        self.offerCode = offerCode
        
        guard let code = offerCode else{ return}
        
        var parameters = [String:Any]()
        parameters["code"] = code
        self.populateOfferDetail(service: .offers_detail, params: parameters)
        
    }
    
    
    
    private func populateOfferDetail(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! IN OfferDetailVM")
                Utility.printLog(messge: "\(dictData as Any)")
                
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                
                if service == .token {
                    
                }else if service == .offers_detail{
                    self.handleOfferDetailResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    
    func handleOfferDetailResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(OfferDetailModal.self, from: jsonData)
            
            if let data  = objUserInfo.data {
                self.offerDetailModal = data
            }
            
            self.bindingOfferDetailViewModel?(objUserInfo, .offers_detail)
            
        }catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
}

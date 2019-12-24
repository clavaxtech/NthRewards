//
//  OfferViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 29/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

enum OffersTagKey : String {
    case DealOfTheDay = "DealOfTheDay"
    case Discount = "Discount"
    case allOffers = "allOffers"
}

class OfferViewModal: NSObject {
    
    private var token : NSKeyValueObservation?
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingOfferViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    
    private (set) var DealOfTheDayOffersModalArray = [OfferModal]()
    private (set) var DiscountOffersModalArray = [OfferModal]()
    private (set) var allOffersModalArray = [OfferModal]()
    
    private (set) var filterCategories = [Category]()
    private (set) var filterArea = [Category]()
    private (set) var filterSections = [String]()
    
    public var offSet = 0
    public var limit = 0
    
    
    enum OfferFilterKey : String , CaseIterable{
        case area = "Area"
        case category = "Category"
    }
    
    public func callOfferCategoryAPIService(){
        
        self.populateHomeAchieved(service: .offer_categories, params: [String : Any]())
        
    }
    
    public func clearAllData(){
        if self.allOffersModalArray.count > 0 {self.allOffersModalArray = []}
        if self.DiscountOffersModalArray.count > 0 {self.DiscountOffersModalArray = []}
        if self.DealOfTheDayOffersModalArray.count > 0 {self.DealOfTheDayOffersModalArray = []}
    }
    
    
    public func callAPIService(withOffset offSet : Int , withLimit  limit: Int, withFilter filter: String){
        
        
        self.offSet = offSet
        self.limit = limit
        
        var params = [String:Any]()
        params["offSet"] = offSet
        params["limit"] = limit
        params["filter"] = filter
        
        self.populateHomeAchieved(service: .offers_byOfset, params: params)
        
        
    }
    
    private func populateHomeAchieved(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! IN OfferViewModal")
                Utility.printLog(messge: "\(dictData as Any)")
                
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                
                if service == .token{
                    
                }else if service == . offers_byOfset{
                    self.handleOfferResponse(responseDict: dictData as! [String : Any])
                }else if service == .offer_categories{
                    self.handleOfferCategoryResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    func handleOfferCategoryResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let obj  = try objDecoder.decode(ProductCategory.self, from: jsonData)
            
            if let categories = obj.data{
                self.filterCategories = categories.filter({ $0.category_type == OfferFilterKey.category.rawValue.lowercased()})
                self.filterArea = categories.filter({ $0.category_type == OfferFilterKey.area.rawValue.lowercased()})
            }
            
            
            self.filterSections.append(OfferFilterKey.category.rawValue)
            self.filterSections.append(OfferFilterKey.area.rawValue)
            
            
            self.bindingOfferViewModel?(obj, .offer_categories)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func handleOfferResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(LatestOfferModal.self, from: jsonData)
            
            if let data = objUserInfo.data {
                
                self.allOffersModalArray = data
                
                for i in 0..<self.allOffersModalArray.count {
                    
                    if  let tags : [offerDetailResponseArrayTag] = self.allOffersModalArray[i].offerDetailResponse?.tags {
                        
                        for x in 0..<tags.count {
                            
                            if let name = tags[x].values?[0].Name  {
                                
                                if name == OffersTagKey.Discount.rawValue{
                                    print("\(name)")
                                    self.DiscountOffersModalArray.append(self.allOffersModalArray[i])
                                    
                                }else if name == OffersTagKey.DealOfTheDay.rawValue{
                                    print("\(name)")
                                    self.DealOfTheDayOffersModalArray.append(self.allOffersModalArray[i])
                                    
                                }
                            }
                        }
                    }
                }
                
            }
            self.bindingOfferViewModel?(objUserInfo, .offers_byOfset)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
}

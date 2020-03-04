    //
    //  HomeVM.swift
    //  nth Rewards
    //
    //  Created by Deepak Tomar on 27/08/19.
    //  Copyright © 2019 Deepak Tomar. All rights reserved.
    //

    import Foundation
    import UIKit


    enum HomeListKey : Int {
        case banner =  0
        case latestOffers = 1
        case giftCards = 2
    }



    class HomeVM : NSObject {
        
        //MARK:- PROPERTIES
        private var token : NSKeyValueObservation?
        
        var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
        
        var bindingHomeViewModel : ((_ data : Any , _ serviceType : Services) ->())?
        var updateCart : ((_ data : Any , _ serviceType : Services) ->())?
        
        private var alertMessage : String? {
            didSet {
                //self.showAlert?(alertMessage ?? "")
            }
        }
        
        
        public var bannersModals = [Banner]()
        public var latestOffersModals = [OfferModal]()
        public var giftCardsModals = [GiftCard]()
        public var productModals = [Product]()
        
        
        public func clearAllData(){
            if self.bannersModals.count > 0 {self.bannersModals = []}
            if self.latestOffersModals.count > 0 {self.latestOffersModals = []}
            if self.giftCardsModals.count > 0 {self.giftCardsModals = []}
            if self.productModals.count > 0 {self.productModals = []}
        }
        
        
        public func callApi(){
            
            self.populateHomeAchieved(service: .banners, parameters: [String : Any]())
            self.populateHomeAchieved(service: .offers, parameters: [String : Any]())
            self.populateHomeAchieved(service: .giftcards, parameters: [String : Any]())
            
            let productParams = ["categories" : "CATMAPO7VCDK"]
            self.populateHomeAchieved(service: .products, parameters: productParams)
        }
        
        public func callCartDetailService(){
            
            self.populateHomeAchieved(service: .cartDetail, parameters: [String : Any]())
            
        }
        
        private func populateHomeAchieved(service:Services , parameters :[String:Any]){
            
            NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: parameters, successClosure: {(dictData, ResponseStatus) in
                
                switch ResponseStatus {
                    
                case .fail:
                    
                    Utility.printLog(messge: "API FAIL!! IN HomeVM")
                    Utility.printLog(messge: "\(dictData as Any)")
                    
                    self.showAlert?(dictData as? String , service)
                    
                    break
                    
                case .sucess:
                    
                    if service == .token{
                        self.callApi()
                    }else if service == .banners {
                        
                        self.handleBannerResponse(responseDict: dictData as! [String : Any])
                        
                    }else if service == .offers {
                        self.handleLatestOfferResponse(responseDict: dictData as! [String : Any])
                    }else if service == .giftcards {
                        self.handleGiftCardsResponse(responseDict: dictData as! [String : Any])
                        
                    }else if service == .products {
                        self.handleProductResponse(responseDict: dictData as! [String : Any])
                    }else if service == .cartDetail{
                        self.handleCartDetailResponse(responseDict: dictData as! [String:Any])
                    }
                    
                    break
                }
                
            })
            
            
        }
        
        func handleCartDetailResponse(responseDict : [String : Any]){
            do {
                //Get JSON object from retrieved data string
                //            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
                //            let objDecoder = JSONDecoder()
                //            let cartModalObj  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
                //
                //            self.updateCart?(cartModalObj,.cartDetail)
            }
            catch(let error){
                print("JSON Parsing Error >> \(error)")
            }
        }
        
        
        func handleBannerResponse(responseDict : [String : Any]){
            do {
                //Get JSON object from retrieved data string
                let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
                let objDecoder = JSONDecoder()
                let objUserInfo  = try objDecoder.decode(BannerModal.self, from: jsonData)
                
                
                if let data = objUserInfo.data {
                    self.bannersModals = data
                }else{
                    
                }
                
                self.bindingHomeViewModel?(objUserInfo, .banners)
            }
            catch(let error){
                print("JSON Parsing Error >> \(error)")
            }
        }
        
        func handleLatestOfferResponse(responseDict : [String : Any]){
            do {
                //Get JSON object from retrieved data string
                let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
                let objDecoder = JSONDecoder()
                let objUserInfo  = try objDecoder.decode(LatestOfferModal.self, from: jsonData)
                
                if let data = objUserInfo.data {
                    
                    print("Latest offers not nil")
                    self.latestOffersModals = data
                    
                    print(" =========== FINAL ARRAY >> \(self.latestOffersModals.count)")
                }else{
                    
                }
                
                self.bindingHomeViewModel?(objUserInfo, .offers)
            }
            catch(let error){
                print("JSON Parsing Error >> \(error)")
            }
        }
        
        func handleGiftCardsResponse(responseDict : [String : Any]){
            do {
                //Get JSON object from retrieved data string
                let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
                let objDecoder = JSONDecoder()
                let objUserInfo  = try objDecoder.decode(GiftCardModal.self, from: jsonData)
                if let data = objUserInfo.data {
                    
                    self.giftCardsModals = data
                    
                }
                
                self.bindingHomeViewModel?(objUserInfo, .giftcards)
            }
            catch(let error){
                print("JSON Parsing Error >> \(error)")
            }
        }
        
        func handleProductResponse(responseDict : [String : Any]){
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
                let objDecoder = JSONDecoder()
                let objUserInfo  = try objDecoder.decode(ProductModal.self, from: jsonData)
                
                if let data = objUserInfo.data {
                    self.productModals = data
                }
                
                self.bindingHomeViewModel?(objUserInfo, .products)
            }
            catch(let error){
                print("JSON Parsing Error >> \(error)")
            }
        }
        
        
    }




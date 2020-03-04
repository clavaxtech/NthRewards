//
//  GiftViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 02/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class GiftViewModal: NSObject {
    
    private var token : NSKeyValueObservation?
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingGiftViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    private (set) var giftBannerModalArray = [Banner]()
    private (set) var giftPointsModalArray = [OfferModal]()
    private (set) var giftTrendingModalArray = [GiftCard]()
    
    private (set) var tempTrendingModalArray = [GiftCard]()
    
    
    public func callAPIService(withOffset offSet : Int , withLimit  limit: Int){
        
        
//        if !delegate.isTokenAuthentic(){
//
//            Utility.printLog(messge: "-------- TOKEN  EXPIRED!!! ------ ")
//            self.populateHomeAchieved(service: .token, params: [String : Any]())
//
//        }else{
            Utility.printLog(messge: " ------- TOKEN  AUTHENTIC!!! -------- ")
        
        self.populateHomeAchieved(service: .gift_banner, params: [String:Any]())
        
        self.populateHomeAchieved(service: .gift_cards, params: [String:Any]())
            
            
       // }
        
    }
    
    private func populateHomeAchieved(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in GiftViewModal")
                Utility.printLog(messge: "\(dictData as Any)")
                
                self.showAlert?(dictData as? String , service)
                
                
                
                break
                
            case .sucess:
                
                if service == .token {
                    self.callAPIService(withOffset: 0, withLimit: 0)
                }else if service == .gift_banner {
                    Utility.printLog(messge: "------ offers_byOfset SUCCESS!! in GiftViewModal ---------")
                    self.handleGiftBannerResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .gift_points {
                    Utility.printLog(messge: "------ giftcards SUCCESS!! in GiftViewModal ---------")
                    self.handleGiftPointsResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .gift_cards {
                    Utility.printLog(messge: "------ giftcards SUCCESS!! in GiftViewModal ---------")
                    self.handleGiftCardsResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    func handleGiftBannerResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(BannerModal.self, from: jsonData)
            
            if let dataArray = objUserInfo.data {
                self.giftBannerModalArray  = dataArray
            }
            print("Array complete")
            self.bindingGiftViewModel?(objUserInfo, .gift_banner)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    
    func handleGiftPointsResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(LatestOfferModal.self, from: jsonData)
            
            if let dataArray : [OfferModal] = objUserInfo.data {
                
                for (_,var i) in dataArray.enumerated() {
                    
                    for (_, y) in self.tempTrendingModalArray.enumerated(){
                        
                        if i.offerDetailResponse?.code == y.campaign_code{
                            i.offerDetailResponse?.code = y.code
                               i.offerDetailResponse?.imageLink = y.image
                            self.giftPointsModalArray.append(i)
                            
                        }
                    }
                }
                
            }
            Utility.printLog(messge: "EARNED POINTS Array  \(giftPointsModalArray.count)")
            
            self.bindingGiftViewModel?(objUserInfo, .gift_points)
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
            if let dataArray = objUserInfo.data {
                
                for i in 0..<dataArray.count{
                    
                    if (dataArray[i].campaign_code !=  nil &&  dataArray[i].campaign_code != "None"  && dataArray[i].is_featured == true ){
                        tempTrendingModalArray.append(dataArray[i])
                    }else{
                        self.giftTrendingModalArray.append(dataArray[i])
                    }
                }
                
                self.populateHomeAchieved(service: .gift_points, params: [String:Any]())
            }
            
            Utility.printLog(messge: "Global Trending Array  \(giftTrendingModalArray.count)")
            Utility.printLog(messge: "TEMP Trending Array  \(tempTrendingModalArray.count)")
            
            self.bindingGiftViewModel?(objUserInfo, .gift_cards)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
}

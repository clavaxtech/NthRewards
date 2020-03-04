//
//  GiftDetailViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 03/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation
import UIKit


class GiftDetailViewModal : NSObject{
    private var token : NSKeyValueObservation?
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    //Calbacks
    public var bindingGiftDetailViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    public var updatePoints : (()->())?
    public var updateCart : ((_ data : Any , _ serviceType : Services) ->())?
    
    private (set)  var giftDetailObject : GiftCard?
    private (set)  var denominationsModalArray = [Denominations]()
    
    var giftCode : String = ""
    
    var termsAndCondition : String?
    var descriptionValue : String?
    var discountInfo : String?
    
    var maxQuantityValue = 1
    var denominationSelectedValue = 0
    private var denominationSelectedValueIndexRow = 0
    
    var DiscountResponse : (value : Int?,type: String)?
    
    public func callAPIService(giftCode : String){
        
        self.giftCode = giftCode
        
        //        if !delegate.isTokenAuthentic(){
        //
        //            Utility.printLog(messge: "-------- TOKEN  EXPIRED!!! ------ ")
        //            let param = ["client_id": "\(Base.CLIENT_ID)", "client_secret": "\(Base.CLIENT_SECRET)", "grant_type": "client_credentials"]
        //            self.populateHomeAchieved(service: .token, params: param)
        //
        //        }else{
        Utility.printLog(messge: " ------- TOKEN  AUTHENTIC!!! -------- ")
        
        self.populateHomeAchieved(service: .gift_detail, params: ["id":giftCode])
        
        // }
        
    }
    public func callCartDetailService(){
        
        self.populateHomeAchieved(service: .cartDetail, params: [String : Any]())
        
    }
    
    public func callAddToCartService(withDic : [String:Any]){
        
        self.populateHomeAchieved(service: .addtocart, params: withDic)
    }
    
    private func populateHomeAchieved(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in GiftDetailViewModal")
                Utility.printLog(messge: "\(dictData as Any)")
                
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                Utility.printLog(messge: "------  SUCCESS!! in GiftDetailViewModal ---------")
                
                if service == .token{
                    
                    self.callAPIService(giftCode: self.giftCode)
                    
                }else if service == .gift_detail{
                    self.handleGiftDetailResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .offers_detail{
                    self.handleOfferDetailResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .addtocart {
                    self.handleAddToCartResponse(responseDict: dictData as!  [String : Any])
                    
                }else if service == .cartDetail{
                    self.handleCartDetailResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    func handleCartDetailResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let cartModalObj  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
            
            self.updateCart?(cartModalObj,.cartDetail)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func handleAddToCartResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
            
            self.bindingGiftDetailViewModel?(objUserInfo,.addtocart)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func handleGiftDetailResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(GiftDetailModal.self, from: jsonData)
            
            if let giftCard = objUserInfo.data{
                self.giftDetailObject = giftCard
                self.parseToZero()
            }
            
            
            if (self.giftDetailObject?.campaign_code !=  nil &&  self.giftDetailObject?.campaign_code != "None"  && self.giftDetailObject?.is_featured == true){
                
                let parameters = ["code": (self.giftDetailObject?.campaign_code)!]
                
                self.populateHomeAchieved(service: .offers_detail, params: parameters)
                
            }else{
                self.bindingGiftDetailViewModel?(objUserInfo,.gift_detail)
            }
            
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    
    func handleOfferDetailResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(OfferDetailModal.self, from: jsonData)
            
            
            if let data = objUserInfo.data {
                
                //                for (itemData in response.body()!!.data!!.offerDetailResponse.data!!)
                //                for (item in itemData)
                //                if (item.redeemType!!.equals("Discount-Percentage-Currency")) {
                //                    giftValues = item.value.toString()
                //                    giftDiscount = "percentage"
                //                    setGiftData(data, giftValues)
                //                } else if (item.redeemType!!.equals("Discount-Fix-Currency")) {
                //                    giftValues = item.value.toString()
                //                    giftDiscount = "fixed"
                //                    setGiftData(data, giftValues)
                //                }
                
                if let dataInner : [[OfferDetailResponse]] = data.offerDetailResponse?.data {
                    
                    self.descriptionValue = data.offerDetailResponse?.description
                    
                    for (_,element) : (Int,[OfferDetailResponse]) in dataInner.enumerated(){
                        
                        for (_,innerElement) : (Int,OfferDetailResponse) in element.enumerated(){
                            
                            if innerElement.RedeemType == "Discount-Percentage-Currency"{
                                
                                if let value = innerElement.Value {
                                    DiscountResponse = (value :value ,type : "percentage")
                                    discountInfo = "Discount \(value)%"
                                    
                                }
                                
                            }else if innerElement.RedeemType == "Discount-Fix-Currency"{
                                
                                if let value = innerElement.Value {
                                    DiscountResponse = (value :value ,type : "fixed")
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            self.bindingGiftDetailViewModel?(objUserInfo,.gift_detail)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func parseToZero(){
        
        if let vendors = self.giftDetailObject?.vendors {
            
            let denominations = vendors.map { (vendor : Vendors) -> [Denominations]? in
                if  vendor.vendor_code == self.giftDetailObject?.default_vendor_code{
                    if let maxValue = Int(vendor.max_quantity ?? "1"){
                        self.maxQuantityValue = maxValue
                    }
                    
                    if let tnc = vendor.tnc {
                        self.termsAndCondition = tnc
                    }
                    return vendor.denominations }
                return nil
            }
            
            if let denominationArray = denominations[0] {
                self.denominationsModalArray = denominationArray
                if let value =  self.denominationsModalArray[0].fix_value {
                    self.denominationSelectedValue = value
                }
            }
            
            Utility.printLog(messge: "FINAL DENOMINATIONS ARRAY ----- %@", denominationsModalArray)
            
        }
        
    }
    
}


extension GiftDetailViewModal : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.denominationsModalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftDetailNominationCell", for: indexPath as IndexPath) as! GiftDetailNominationCell
        if let fixValue = self.denominationsModalArray[indexPath.row].fix_value {
            cell.priceLabel.text = String(fixValue)
        }
        
        
        if indexPath.row == self.denominationSelectedValueIndexRow{
            cell.containerView.backgroundColor = UIColor.pageControl_fill
            cell.containerView.borderColor = UIColor.clear
            cell.priceLabel.textColor = UIColor.white
        }else{
            cell.containerView.backgroundColor = UIColor.white
            cell.containerView.layer.borderColor = UIColor.pageControl_border.cgColor
            cell.containerView.layer.borderWidth = 1.0
            cell.priceLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 55, height: collectionView.frame.size.height)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let value =  self.denominationsModalArray[indexPath.row].fix_value {
            self.denominationSelectedValue = value
        }
        self.denominationSelectedValueIndexRow = indexPath.row
        self.updatePoints?()
        
        collectionView.reloadData()
    }
    
}



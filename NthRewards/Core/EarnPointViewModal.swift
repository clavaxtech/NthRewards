//
//  EarnPointViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/11/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit



protocol EarnPointViewModalDelegate {
    func onOfferDidClick(atRow : Int)
}

class EarnPointViewModal: NSObject {
    private var token : NSKeyValueObservation?
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingEarnPointViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    private (set) var earnBannersModalArray : [String] = ["earnPoints_1" , "earnPoints_2" ,"earnPoints_3"]
    
    private (set) var offerByPointsModalArray = [OfferModal]()
    
    
    var delegate : EarnPointViewModalDelegate?
    
    public func callAPIService(withOffset offSet : Int , withLimit  limit: Int){
        
        self.populateHomeAchieved(service: .offer_byPoints, params: [String:Any]())
        
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
                }else if service == .offer_byPoints {
                    self.handleLatestOfferResponse(responseDict: dictData as! [String : Any])
                    
                }
                
                
                break
            }
            
        })
        
        
    }
    
    func handleLatestOfferResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(LatestOfferModal.self, from: jsonData)
            
            if let data = objUserInfo.data {
                
                self.offerByPointsModalArray = data
                Utility.printLog(messge: "Total Array ------\(self.offerByPointsModalArray.count)")
            }
            self.bindingEarnPointViewModel?(objUserInfo, .offer_byPoints)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    
    
}


extension EarnPointViewModal : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionView.tag == 1 ? self.earnBannersModalArray.count : self.offerByPointsModalArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftBannerCollectionViewCell", for: indexPath as IndexPath) as! GiftBannerCollectionViewCell
            let banner = self.earnBannersModalArray[indexPath.row]
            cell.bannerImageView.image = UIImage(named: banner)
            return cell
            
        }else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EarnPointCollectionViewCell", for: indexPath as IndexPath) as! EarnPointCollectionViewCell
            
            let giftCard : OfferModal = self.offerByPointsModalArray[indexPath.row]
            
            cell.bannerImageView.sd_setImage(with: URL(string: giftCard.offerDetailResponse?.logoImageLink ?? ""), placeholderImage: UIImage(named: "default"))
            
            cell.descriptionLabel.text = giftCard.offerDetailResponse?.description ?? ""
            
            cell.containerView.addShadow()
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            
        }else if collectionView.tag == 2 {
            
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
            
        }
        return CGSize.zero
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onOfferDidClick(atRow: indexPath.row)
    }
    
    
}


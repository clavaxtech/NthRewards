//
//  MyAccountViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation
import UIKit


class MyAccountViewModal: NSObject{
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingMyAccountViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    private let arrayIcons = ["availablePoint","cashback","discount"]
    private let arrayInfo0 = ["Available Points:","Cashback","Discount"]
    private let arrayInfo2 = ["Redeem To Earn More" , "Check Offers for more cashback" , "Avail Exclusive Discounts"]
    
    private var arrayInfo1 = Array(repeating: 0, count: 3)
    
    public func getCustomerInfo(){
        
        if let mobileNumber = UserInfo.getUserInformation()?.data?.mobile    {
            let parameters = [ "mobile": "\(mobileNumber)"]
            self.populateData(service: .getCustomer, params: parameters)
        }else {
            let parameters = [ "mobile": "7503023014"]
            self.populateData(service: .getCustomer, params: parameters)
        }
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
                case .getCustomer:
                    self.handleGetCustomerResponse(responseDict: dictData as! [String : Any])
                    break
                default:
                    break
                }
                
                
                break
            }
            
        })
        
        
    }
    
    func handleGetCustomerResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objectInfo  = try objDecoder.decode(UserProfileInfo.self, from: jsonData)
            
            if let points = objectInfo.data?.wallet?.point , let currency =  objectInfo.data?.wallet?.currency , let discount =  objectInfo.data?.wallet?.discount{
                self.arrayInfo1[0] = Int(points)
                self.arrayInfo1[1] = currency
                self.arrayInfo1[2] = discount
            }
            
            self.bindingMyAccountViewModel?(objectInfo,.getCustomer)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
}

extension MyAccountViewModal : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyAccountCollectionViewCell.identifier, for: indexPath as IndexPath) as! MyAccountCollectionViewCell
        cell.baseView.addShadow()
        
        cell.info0Label.text = self.arrayInfo0[indexPath.row]
        cell.info1Label.text = String(self.arrayInfo1[indexPath.row])
        cell.info2Label.text = self.arrayInfo2[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/3, height: collectionView.frame.size.height)
        
        
    }
    
}





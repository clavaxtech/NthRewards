//
//  ProductDetailViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/12/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

protocol ProductDetailViewModalDelegate {
    func onDidClick(atIndex : Int)
}

class ProductDetailViewModal: NSObject {
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingProductDetailViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    public var updateCart : ((_ data : Any , _ serviceType : Services) ->())?
    
    let productDetailArray = ["Description"]
    let productDetailImageArray = ["offer_detail"]
    
    
    var delegate : ProductDetailViewModalDelegate?
    
  
    public func callCartDetailService(){
        
        self.populateData(service: .cartDetail, params: [String : Any]())
        
    }
    
    public func callAddToCartService(withDic : [String:Any]){
        
        self.populateData(service: .addtocart, params: withDic)
    }
    
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                if service == .products{
                    self.handleProductDetailResponse(responseDict: dictData as! [String : Any])
                }else if service == .addtocart {
                    self.handleAddToCartResponse(responseDict: dictData as!  [String : Any])
                    
                }else if service == .cartDetail{
                    self.handleCartDetailResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    
    func handleProductDetailResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(OfferDetailModal.self, from: jsonData)
          
            
            self.bindingProductDetailViewModel?(objUserInfo, .offers_detail)
            
        }catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
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
            
            self.bindingProductDetailViewModel?(objUserInfo,.addtocart)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
}


extension ProductDetailViewModal : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailTableViewCell", for: indexPath as IndexPath) as! OfferDetailTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.nameLabel.text = self.productDetailArray[indexPath.row]
        cell.imgView.image = UIImage(named: productDetailImageArray[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Utility.printLog(messge: "\(indexPath.row)")
        delegate?.onDidClick(atIndex: indexPath.row)
    }
    
    
    
    
}

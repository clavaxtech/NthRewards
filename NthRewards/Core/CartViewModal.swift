//
//  CartViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 11/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SDWebImage

protocol CartViewModalDelegate  {
    func deleteCartItem(indexPath : IndexPath)
    func updateCartItem(indexPath : IndexPath, quantity:String)
}

class CartViewModal: NSObject {
    
    public let ItemHeight = 120
    
    var delegate : CartViewModalDelegate?
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    
    public var bindingCartViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    public var updateItemTableView : (()->())?
    
    private(set) var cartModalObj : AddToCardModal?
    
    private(set) var productList = [ProductList]()
    
    public func callCartDetailService(){
        
        self.populateData(service: .cartDetail, params: [String : Any]())
        
    }
    
    public func callCustomerWalletInfolService(){
        
        if let mobileNumber = UserInfo.getUserInformation()?.data?.mobile   {
            let parameters = [ "mobile": "\(mobileNumber)"]
            self.populateData(service: .getCustomer, params: parameters)
        }
        
    }
    
    
    public func deleteCartItem(dic : [String:Any]){
        
        self.populateData(service: .deletefromcart, params: dic)
    }
    
    public func updateCart(dic : [String:Any]){
        self.populateData(service: .updatecart, params: dic)
    }
    
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in GiftDetailViewModal")
                Utility.printLog(messge: "\(dictData as Any)")
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                Utility.printLog(messge: "------  SUCCESS!! in CartDetail View Modal ---------")
                
                if service == .token{
                    
                }else if service == .cartDetail {
                    self.handleCartDetailResponse(responseDict: dictData as! [String : Any])
                }else if service == .deletefromcart {
                    self.handleDeleteCartResponse(responseDict: dictData as! [String : Any])
                }else if service == .updatecart{
                    self.handleUpdateCartResponse(responseDict: dictData as! [String:Any])
                }else if service == .getCustomer{
                    self.handleGetCustomerResponse(responseDict: dictData as! [String:Any])
                    
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
            let objUserInfo  = try objDecoder.decode(UserProfileInfo.self, from: jsonData)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(objUserInfo), forKey:keyUD.k_UserProfileInfo)
            userDefaults.synchronize()
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
    
    func handleCartDetailResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let cartModalObj  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
            
            self.cartModalObj = cartModalObj
            
            if let productList = cartModalObj.data?.products_list {
                self.productList = productList
            }
            
            self.bindingCartViewModel?(cartModalObj,.cartDetail)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func handleDeleteCartResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let cartModalObj  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
            
            self.cartModalObj = cartModalObj
            if let productList = cartModalObj.data?.products_list {
                self.productList = productList
            }
            
            self.bindingCartViewModel?(jsonData,.deletefromcart)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    func handleUpdateCartResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let cartModalObj  = try objDecoder.decode(AddToCardModal.self, from: jsonData)
            
            self.cartModalObj = cartModalObj
            if let productList = cartModalObj.data?.products_list {
                self.productList = productList
            }
            
            self.bindingCartViewModel?(jsonData,.updatecart)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    
    
    
}




extension CartViewModal  : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ItemHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : CartItemTableViewCell   = tableView.dequeueReusableCell(withIdentifier: CartItemTableViewCell.identifier, for: indexPath) as? CartItemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.productObj = self.productList[indexPath.row]
        cell.delegate = self
        
        cell.indexPath = indexPath
        cell.containerView.addShadow()
        
        return cell
    }
    
    
}

extension CartViewModal : CartItemTableViewCellDelegate{
    
    
    func updateQuantityAt(indexPath: IndexPath, quantity: String) {
        
        delegate?.updateCartItem(indexPath: indexPath, quantity: quantity)
    }
    
    
    
    func deleteItemAt(indexPath : IndexPath) {
        print("The deleted row \(indexPath)")
        
        delegate?.deleteCartItem(indexPath: indexPath)
    }
    
    
    
    
    
}

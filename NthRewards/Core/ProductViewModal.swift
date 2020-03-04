//
//  ProductViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/12/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SDWebImage

protocol  ProductViewModalDelegate {
    func onDidClick(product:Product)
}

class ProductViewModal: NSObject {
    
    private var token : NSKeyValueObservation?
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingProductViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    private (set) var banners : [String] = ["product_banner1" , "product_banner2", "product_banner3"]
    private (set) var productModals = [Product]()
    
    private (set) var productCategories = [Category]()
    
    var delegate : ProductViewModalDelegate?
    
    public func callProductCategoryAPIService(){
        
        self.populateHomeAchieved(service: .categoriesMapping, params: [String : Any]())
        
    }
    
    
    public func callProductAPIService(parameters : [String:Any]){
        
        self.populateHomeAchieved(service: .products, params: parameters)
        
    }
    
    
    public func clearAllData(){
        if self.productModals.count > 0 {self.productModals = []}
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
                
                if service == .products {
                    
                    self.handleProductResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .categoriesMapping{
                    self.handleCategoryMappingResponse(responseDict: dictData as! [String : Any])
                }
                
                break
            }
            
        })
        
        
    }
    
    func handleProductResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(ProductModal.self, from: jsonData)
            
            if let data = objUserInfo.data {
                self.productModals = []
                self.productModals = data
            }
            
            self.bindingProductViewModel?(objUserInfo, .products)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    func handleCategoryMappingResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let obj  = try objDecoder.decode(ProductCategory.self, from: jsonData)
            
            if let data = obj.data {
                self.productCategories = data
            }
            
            self.bindingProductViewModel?(obj, .categoriesMapping)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
    
}

extension ProductViewModal : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return self.banners.count
            
        }else if collectionView.tag == 2{
            
            return self.productModals.count
            
        }else if collectionView.tag == 3 {
            
            return self.productModals.count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftBannerCollectionViewCell", for: indexPath as IndexPath) as! GiftBannerCollectionViewCell
            
            print("-------- banner collection called ----------- ")
            if let bundle = Utility.bundle(forView: GiftBannerCollectionViewCell.self){
                let banner = self.banners[indexPath.row]
                cell.bannerImageView.image = UIImage(named: banner,
                in: bundle,
                compatibleWith: nil)
                return cell
            }else{
                return UICollectionViewCell()
            }
            
            
        }else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingProductCollectionViewCell", for: indexPath as IndexPath) as! TrendingProductCollectionViewCell
            let product = self.productModals[indexPath.row]
            
            if let image = product.image {
                let finalImage = image.replacingOccurrences(of: " ", with: "%20")
                cell.productImage.sd_setImage(with: URL(string: finalImage), placeholderImage: UIImage(named: "default"), options: SDWebImageOptions(rawValue: 0)) { (image:UIImage?, error :Error?, cache, url) in
                    
                }
                
            }
            
            cell.descriptionLabel.text = product.title ?? ""
            
            if let price = product.price {
                cell.pointsLabel.text = "Pts : \(price.points)"
                cell.priceLabel.text = "₹ \(price)"
                
            }
            cell.baseView.addShadow()
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            
        }else if collectionView.tag == 2 {
            
            let width = collectionView.frame.size.width - 5
            let height = collectionView.frame.size.height - 3
            return CGSize(width: width/2, height: height)
            
        }
        return CGSize.zero
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            
            
        }else if collectionView.tag == 2 {
            
            delegate?.onDidClick(product: self.productModals[indexPath.row])
        }
        
        
    }
    
    
}


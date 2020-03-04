//
//  ProductViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/12/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet var baseScrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    
    @IBOutlet weak var bestSellingCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet var view1HC: NSLayoutConstraint!
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet var giftCardsCollectionView: UICollectionView!
    
    
    @IBOutlet weak var filterButton: UIButton!
    
    var tempCollectionViewHC = 0.0
    
    //Properties
    fileprivate let viewModal = ProductViewModal()
    fileprivate var selectedCategories = Set<String>()
    fileprivate var selectedPrices = Set<String>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.bindingViewModals()
        
        self.viewModal.callProductCategoryAPIService()
        self.getCatologes()
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func initialSetup(){
        
        self.view2.isHidden = true
        self.viewModal.delegate = self
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.catalogue)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        let _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.bannerScrollsAuto), userInfo: nil, repeats: true)
        
        
        self.bannerCollectionView.delegate = viewModal
        self.bannerCollectionView.dataSource = viewModal
        self.giftCardsCollectionView.delegate = viewModal
        self.giftCardsCollectionView.dataSource = viewModal
        
        
        self.filterButton.addShadow()
        self.tempCollectionViewHC = Double(self.bestSellingCollectionViewHC.constant)
        
    }
    
    private func bindingViewModals(){
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "GiftViewController error! --------- %@",alertMessage ?? "")
            //Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
            
            //self.hideHud()
            
        }
        
        self.viewModal.bindingProductViewModel = {(data:Any?, serviceType : Services) in
            
            if serviceType == .gift_banner {
                DispatchQueue.main.async {
                    self.bannerCollectionView.reloadData()
                    
                }
            }else if serviceType == .products {
                
                //self.hideHud()
                
                DispatchQueue.main.async {
                    
                    self.viewModal.productModals.count == 0 ? (self.baseScrollView.isHidden = true) : (self.baseScrollView.isHidden = false)
                    if self.view2.isHidden  {self.view2.isHidden = false}
                    
                    
                    self.giftCardsCollectionView.reloadData()
                    
                    self.bestSellingCollectionViewHC.constant = self.giftCardsCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.view.layoutIfNeeded()
                    
                }
            }
            
        }
        
    }
    
    private func getCatologes(){
        
        var params = [String:Any]()
        if self.selectedCategories.count > 0 {
            params["categories"] = self.selectedCategories.reduce("") { (result, item) -> String in
                if result == ""{
                    return result + "\(item)"
                }else{
                    return result + "%2C\(item)"
                }
                
            }
            
        }
        
        if self.selectedPrices.count > 0 {
            params["prices"] = self.selectedPrices.reduce("") { (result, item) -> String in
                if result == ""{
                    return result + "\(item)"
                }else{
                    return result + "%2C\(item)"
                }
            }
            
        }
        
        self.bestSellingCollectionViewHC.constant = CGFloat(self.tempCollectionViewHC)
        self.view.layoutIfNeeded()
        self.view2.isHidden = true
        //self.showHud()
        self.viewModal.callProductAPIService(parameters: params)
        
    }
    
    @objc private func bannerScrollsAuto (){
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < viewModal.banners.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
    }
    
    
    
    private func moveToDetailViewController(obj : Product){
        
        //        let vc : ProductDetailViewController = MultipleStoryBoards.kProduct.instantiateViewController(withIdentifier: VCIdentifire.productDetailViewController.rawValue) as! ProductDetailViewController
        //        vc.product = obj
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if let bundle = Utility.bundle(forView: ProductDetailViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : ProductDetailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.product = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func filterBtnClick(_ sender: Any) {
        //        let vc = MultipleStoryBoards.kProduct.instantiateViewController(withIdentifier: VCIdentifire.filterViewController.rawValue) as! FilterViewController
        //        vc.categoriesArray = self.viewModal.productCategories
        //        vc.delegate = self
        //        vc.selectedCotegories = self.selectedCategories
        //        vc.selectedPrices = self.selectedPrices
        //        self.present(vc, animated: true, completion: nil)
        
        if let bundle = Utility.bundle(forView: FilterViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : FilterViewController = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
            vc.delegate = self
            vc.selectedCotegories = self.selectedCategories
            vc.selectedPrices = self.selectedPrices
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ProductViewController : ProductViewModalDelegate {
    func onDidClick(product: Product) {
        self.moveToDetailViewController(obj: product)
    }
}

extension ProductViewController : FilterViewControllerDelegate {
    
    func clearFilter() {
        if (selectedCategories.count > 0 ||  selectedPrices.count > 0){
            self.selectedCategories = []
            self.selectedPrices = []
            self.giftCardsCollectionView.reloadData()
            self.viewModal.clearAllData()
            self.getCatologes()
            
        }
    }
    
    func apply(withCategories categories: Set<String>, withPrices prices: Set<String>) {
        
        Utility.printLog(messge: "\(categories) && \(prices)")
        if (categories.count > 0 ||  prices.count > 0){
            self.selectedCategories = categories
            self.selectedPrices = prices
            self.viewModal.clearAllData()
            self.giftCardsCollectionView.reloadData()
            self.getCatologes()
        }else if self.selectedCategories.count > 0 || self.selectedPrices.count > 0  &&  categories.count == 0 && prices.count == 0 {
            self.selectedCategories = []
            self.selectedPrices = []
            
            self.viewModal.clearAllData()
            self.giftCardsCollectionView.reloadData()
            
            self.getCatologes()
        }
        
        
    }
}




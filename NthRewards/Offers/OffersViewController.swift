//
//  OffersViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 29/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class OffersViewController: UIViewController {
    
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    
    @IBOutlet weak var noAvailableDataLabel: UILabel!
    
    @IBOutlet var baseScrollView: UIScrollView!
    
    @IBOutlet var LatestOfferCollectionView: UICollectionView!
    
    @IBOutlet var greateBrandsCollectionView: UICollectionView!
    
    @IBOutlet var allOffersCollectionView: UICollectionView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var view1HC: NSLayoutConstraint!
    
    @IBOutlet var view2HC: NSLayoutConstraint!
    
    @IBOutlet var allOfersCollectionViewHC: NSLayoutConstraint!
    
    @IBOutlet weak var filterButton: UIButton!
    
    //Properties
    fileprivate let viewModal = OfferViewModal()
    fileprivate var selectedCategories = Set<String>()
    fileprivate var selectedArea = Set<String>()
    
    private var tempView1HeightConstant : CGFloat = 0.0
    private var tempView2HeightConstant : CGFloat = 0.0
    private var tempAllOfersCollectionViewheightConstant : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
        self.viewModalBinding()
        self.viewModal.callOfferCategoryAPIService()
        self.getOffersFromAPI()
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
       
        
        self.noAvailableDataLabel.isHidden = true
        self.tempView1HeightConstant = self.view1HC.constant
        self.tempView2HeightConstant = self.view2HC.constant
        self.tempAllOfersCollectionViewheightConstant = self.allOfersCollectionViewHC.constant
        
        self.showIndicater()
        self.filterButton.addShadow()
        
    }
    
    private func viewModalBinding(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
        }
        
        self.viewModal.bindingOfferViewModel = {(data:Any?, serviceType : Services) in
            
            if serviceType == .offers_byOfset {
                self.hideIndicater()
                DispatchQueue.main.async {
                    
                    if self.viewModal.DealOfTheDayOffersModalArray.count == 0 && self.viewModal.DiscountOffersModalArray.count == 0 && self.viewModal.allOffersModalArray.count == 0 {
                        self.noDataAvailableView()
                        return
                    }
                    
                    self.resetUIInterface()
                    self.LatestOfferCollectionView.reloadData()
                    self.greateBrandsCollectionView.reloadData()
                    self.allOffersCollectionView.reloadData()
                    
                    self.adjustScrollView()
                }
            }else if serviceType == .offer_categories{
                
                DispatchQueue.main.async {
                    self.filterButton.isEnabled = true
                }
                
            }
            
        }
        
    }
    
    private func showIndicater(){
        self.filterButton.isHidden = true
        self.baseScrollView.isHidden = true
        self.noAvailableDataLabel.isHidden = true
        self.activityIndicater.isHidden = false
        self.activityIndicater.startAnimating()
    }
    
    private func hideIndicater(){
        self.filterButton.isHidden = false
        self.baseScrollView.isHidden = false
        self.noAvailableDataLabel.isHidden = false
        self.activityIndicater.isHidden = true
        self.activityIndicater.stopAnimating()
    }
    
    private func noDataAvailableView(){
        self.filterButton.isHidden = false
        self.baseScrollView.isHidden = true
        self.noAvailableDataLabel.isHidden = false
        self.activityIndicater.isHidden = true
        self.activityIndicater.stopAnimating()
    }
    
    private func getOffersFromAPI(){
        
        self.showIndicater()
        
        var filterString = ""
        if self.selectedCategories.count > 0 {
            let categories = self.selectedCategories.reduce("") { (result, item) -> String in
                if result == ""{
                    return result + "tags in \(item)" }
                else{
                    return result + " or tags in \(item)"
                }
            }
            Utility.printLog(messge: "FINAL CATEGORY =======\(categories)")
            filterString += categories
        }
        
        
        
        if self.selectedArea.count > 0 {
            let areas = self.selectedArea.reduce("") { (result, item) -> String in
                if result == ""{
                    return result + "tags in \(item)" }
                else{
                    return result + " or tags in \(item)"
                }
            }
            Utility.printLog(messge: "FINAL AREA =======\(areas)")
            filterString += areas
        }
        Utility.printLog(messge: "FINAL FILTER STRING =======\(filterString)")
        let encodedFinalString = filterString.replacingOccurrences(of: " ", with: "%20")
        self.viewModal.callAPIService(withOffset: 0, withLimit: 300, withFilter: encodedFinalString)
        
    }
    
    
    private func resetUIInterface(){
        self.view1HC.constant = self.tempView1HeightConstant
        self.view2HC.constant = self.tempView2HeightConstant
        self.allOfersCollectionViewHC.constant = self.tempAllOfersCollectionViewheightConstant
        self.view.layoutIfNeeded()
    }
    
    
    private func adjustScrollView(){
        
        (self.viewModal.DealOfTheDayOffersModalArray.count == 0) ? (self.view1HC.constant = 0) : (self.view1HC.constant = self.tempView1HeightConstant)
        
        self.viewModal.DiscountOffersModalArray.count == 0 ? ( self.view2HC.constant = 0) : (self.view2HC.constant = self.tempView2HeightConstant)
        
        
        self.viewModal.allOffersModalArray.count > 0 ? (self.allOfersCollectionViewHC.constant = allOffersCollectionView.collectionViewLayout.collectionViewContentSize.height) : (self.allOfersCollectionViewHC.constant = 0)
        
        self.view.layoutIfNeeded()
        
    }
    
    private func moveToDetailViewController(offerCode : String?){
        
        if let bundle = Utility.bundle(forView: OfferDetailViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : OfferDetailViewController = storyboard.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.offerCode = offerCode
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    
    
    @IBAction func filterBtnClick(_ sender: Any) {
        
        guard self.viewModal.filterCategories.count != 0 else{return}
        
        if let bundle = Utility.bundle(forView: OfferFilterViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc = storyboard.instantiateViewController(withIdentifier: VCIdentifire.offerFilterViewController.rawValue) as! OfferFilterViewController
            vc.filterCategoryArray = self.viewModal.filterCategories
            vc.filterAreaArray = self.viewModal.filterArea
            vc.filterSectionArray = self.viewModal.filterSections
            vc.selectedCotegories = self.selectedCategories
            vc.selectedArea = self.selectedArea
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    
}


extension OffersViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return viewModal.DealOfTheDayOffersModalArray.count
            
        }else if collectionView.tag == 2{
            
            
            return viewModal.DiscountOffersModalArray.count
            
        }else if collectionView.tag == 3 {
            
            return viewModal.allOffersModalArray.count
        }
        
        
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Offer0CollectionViewCell", for: indexPath as IndexPath) as! Offer0CollectionViewCell
            
            if let offerDetailResponse = self.viewModal.DealOfTheDayOffersModalArray[indexPath.row].offerDetailResponse {
                cell.bannerImageView.sd_setImage(with: URL(string: offerDetailResponse.imageLink ?? ""), placeholderImage: UIImage(named: "default"))
                cell.logoImageView.sd_setImage(with: URL(string: offerDetailResponse.logoImageLink ?? ""), placeholderImage: UIImage(named: "default"))
                
                cell.descriptionLabel.text = offerDetailResponse.description ?? ""
                
            }
            cell.addShadow()
            
            return cell
            
        }else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Offer0CollectionViewCell", for: indexPath as IndexPath) as! Offer0CollectionViewCell
            
            if let offerDetailResponse = self.viewModal.DiscountOffersModalArray[indexPath.row].offerDetailResponse {
                
                
                cell.bannerImageView.sd_setImage(with: URL(string: offerDetailResponse.imageLink ?? ""), placeholderImage: UIImage(named: "default"))
                cell.logoImageView.sd_setImage(with: URL(string: offerDetailResponse.logoImageLink ?? ""), placeholderImage: UIImage(named: "default"))
                
                cell.descriptionLabel.text = offerDetailResponse.description ?? ""
                
            }
            cell.addShadow()
            
            return cell
        }else if collectionView.tag == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Offer1CollectionViewCell", for: indexPath as IndexPath) as! Offer1CollectionViewCell
            cell.addShadow()
            
            if let offerDetailResponse = self.viewModal.allOffersModalArray[indexPath.row].offerDetailResponse {
                cell.offerLogoImageView.sd_setImage(with: URL(string: offerDetailResponse.imageLink ?? ""), placeholderImage: UIImage(named: "default"))
                cell.offerNameLabel.text = offerDetailResponse.title ?? ""
                cell.discountLable.text = offerDetailResponse.description ?? ""
            }
            
            
            return cell
            
        }
        
        return UICollectionViewCell()
        
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            let width = collectionView.frame.size.width - 10
            return CGSize(width: width/2.5, height: collectionView.frame.size.height - 7)
            
        }else if collectionView.tag == 2 {
            let width = collectionView.frame.size.width - 10
            return CGSize(width: width/2.5, height: collectionView.frame.size.height - 7)
            
        }else if collectionView.tag == 3 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
            
        }
        return CGSize.zero
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            self.moveToDetailViewController(offerCode: viewModal.DealOfTheDayOffersModalArray[indexPath.row].offerDetailResponse?.code)
            
        }else if collectionView.tag == 2{
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            
            self.moveToDetailViewController(offerCode: viewModal.DiscountOffersModalArray[indexPath.row].offerDetailResponse?.code)
            
        }else if collectionView.tag == 3 {
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            self.moveToDetailViewController(offerCode: viewModal.allOffersModalArray[indexPath.row].offerDetailResponse?.code)
            
        }
    }
}


extension OffersViewController : OfferFilterViewControllerDelegate{
    func apply(withCategories categories: Set<String>, withArea area: Set<String>) {
        Utility.printLog(messge: "\(categories) && \(area)")
        
        if categories.count > 0 || area.count > 0{
            self.selectedCategories = categories
            self.selectedArea = area
            self.viewModal.clearAllData()
            self.resetUIInterface()
            self.getOffersFromAPI()
        }else if self.selectedCategories.count > 0 || self.selectedArea.count > 0  &&  categories.count == 0 && area.count == 0 {
            self.selectedCategories = []
            self.selectedArea = []
            self.viewModal.clearAllData()
            self.resetUIInterface()
            self.getOffersFromAPI()
        }
    }
    
    func clearFilter() {
        
        if self.selectedCategories.count > 0 || self.selectedArea.count > 0{
            self.selectedCategories = []
            self.selectedArea = []
            self.viewModal.clearAllData()
            self.resetUIInterface()
            self.getOffersFromAPI()
        }
        
    }
}

//
//  GiftViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 02/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import Foundation

class GiftViewController: UIViewController {
    
    @IBOutlet var baseScrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    
    // @IBOutlet var contentViewHC: NSLayoutConstraint!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view3: UIView!
    
    //@IBOutlet var view2HC: NSLayoutConstraint!
    
    @IBOutlet var view1HC: NSLayoutConstraint!
    
    //@IBOutlet var view3HC: NSLayoutConstraint!
    
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet var giftCardsCollectionView: UICollectionView!
    
    @IBOutlet var trendingGiftCollectionView: UICollectionView!
    
    @IBOutlet var trendingGiftCollectionViewHC: NSLayoutConstraint!
    
    
    //Properties
    fileprivate let viewModal = GiftViewModal()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.gifts)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        let _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.bannerScrollsAuto), userInfo: nil, repeats: true)
        
        
        self.initialInit()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initialInit(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "GiftViewController error! --------- %@",alertMessage ?? "")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
            
            self.hideShimmer()
            
        }
        
        self.viewModal.bindingGiftViewModel = {(data:Any?, serviceType : Services) in
            
            self.hideShimmer()
            Utility.printLog(messge: "GiftViewController Success Api!  \(serviceType)")
            
            if serviceType == .gift_banner {
                DispatchQueue.main.async {
                    self.bannerCollectionView.reloadData()
                    
                    //self.view1HC.constant = self.viewModal.giftBannerModalArray.count == 0 ? 0 : self.view1HC.constant
                }
            }else if serviceType == .gift_points {
                DispatchQueue.main.async {
                    self.giftCardsCollectionView.reloadData()
                    
                    //self.view2HC.constant = self.viewModal.giftPointsModalArray.count == 0 ? 0 : self.view2HC.constant
                }
            }else if serviceType == .gift_cards {
                DispatchQueue.main.async {
                    self.trendingGiftCollectionView.reloadData()
                    
                    
                    let height = self.trendingGiftCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.trendingGiftCollectionViewHC.constant = height
                    //self.view3HC.constant = self.viewModal.giftTrendingModalArray.count == 0 ? 0 : self.trendingGiftCollectionViewHC.constant + 50
                }
            }
            
            self.adjustScrollView()
            
            
        }
        
        self.showShimmer()
        self.viewModal.callAPIService(withOffset: 0 , withLimit: 0)
        
    }
    
    @objc private func bannerScrollsAuto (){
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < viewModal.giftBannerModalArray.count - 1){
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
    
    private func showShimmer(){
        //        ABLoader().startSmartShining(view1)
        //        ABLoader().startSmartShining(view2)
        //        ABLoader().startSmartShining(view3)
    }
    
    
    private func hideShimmer(){
        //        ABLoader().stopSmartShining(self.view1)
        //        ABLoader().stopSmartShining(self.view2)
        //        ABLoader().stopSmartShining(self.view3)
    }
    
    private func adjustScrollView(){
        
        //self.contentViewHC.constant = view1HC.constant +  view2HC.constant + view3HC.constant
    }
    
    private func moveToDetailViewController(code : String){
        
        //        let vc = MultipleStoryBoards.kGiftSB.instantiateViewController(withIdentifier: VCIdentifire.giftDetailViewController.rawValue) as! GiftDetailViewController
        //        vc.giftCode = code
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if let bundle = Utility.bundle(forView: GiftDetailViewController.self){
                  
                  let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                  let vc : GiftDetailViewController = storyboard.instantiateViewController(withIdentifier: "GiftDetailViewController") as! GiftDetailViewController
                   vc.giftCode = code
                  self.navigationController?.pushViewController(vc, animated: true)
              }
    }
    
}



extension GiftViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return viewModal.giftBannerModalArray.count
            
        }else if collectionView.tag == 2{
            
            return viewModal.giftPointsModalArray.count
            
        }else if collectionView.tag == 3 {
            
            return viewModal.giftTrendingModalArray.count
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftBannerCollectionViewCell", for: indexPath as IndexPath) as! GiftBannerCollectionViewCell
            let banner = viewModal.giftBannerModalArray[indexPath.row]
            cell.bannerImageView.sd_setImage(with: URL(string: banner.image ?? ""), placeholderImage: UIImage(named: "default"))
            return cell
            
        }else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListing0CollectionViewCell", for: indexPath as IndexPath) as! GiftListing0CollectionViewCell
            
            let giftCard : OfferModal = viewModal.giftPointsModalArray[indexPath.row]
            
            cell.bannerImageView.sd_setImage(with: URL(string: giftCard.offerDetailResponse?.imageLink ?? ""), placeholderImage: UIImage(named: "default"))
            
            cell.titleLabelView.text = giftCard.offerDetailResponse?.title ?? ""
            cell.descriptionLabel.text = giftCard.offerDetailResponse?.description ?? ""
            
            cell.containerView.addShadow()
            
            return cell
            
        }else if collectionView.tag == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftListing1CollectionViewCell", for: indexPath as IndexPath) as! GiftListing1CollectionViewCell
            
            let giftCard = viewModal.giftTrendingModalArray[indexPath.row]
            
            cell.logoImageView.sd_setImage(with: URL(string: giftCard.image ?? ""), placeholderImage: UIImage(named: "default"))
            
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
            
            return CGSize(width: collectionView.frame.size.width/2.5, height: collectionView.frame.size.height)
            
        }else if collectionView.tag == 3 {
            return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.height - 3) / 2)
            
        }
        return CGSize.zero
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            if let giftCode = viewModal.giftBannerModalArray[indexPath.row].offer_code {
                //self.moveToDetailViewController(code: giftCode)
                
                let offerCode = giftCode.split(separator: "/").filter({$0.hasPrefix("GCD")})
                if offerCode.count > 0{
                    self.moveToDetailViewController(code:String(offerCode[0]))}
            }
            
        }else if collectionView.tag == 2{
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            if let giftCode = viewModal.giftPointsModalArray[indexPath.row].offerDetailResponse?.code {
                self.moveToDetailViewController(code: giftCode)
            }
            
            
        }else if collectionView.tag == 3 {
            Utility.printLog(messge: "\(indexPath.row) of collectionView tag \(collectionView.tag)")
            if let giftCode = viewModal.giftTrendingModalArray[indexPath.row].code {
                self.moveToDetailViewController(code: giftCode)
            }
            
        }
    }
    
    
}

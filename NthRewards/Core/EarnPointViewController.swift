//
//  EarnPointViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class EarnPointViewController: UIViewController {
    
    @IBOutlet var baseScrollView: UIScrollView!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var view1: UIView!
    
    @IBOutlet var view2: UIView!
    
    @IBOutlet var view2HC: NSLayoutConstraint!
    
    @IBOutlet var view1HC: NSLayoutConstraint!
    
    @IBOutlet var bannerCollectionView: UICollectionView!
    
    @IBOutlet var giftCardsCollectionView: UICollectionView!
    
    @IBOutlet weak var earnPointsCollectionViewHC: NSLayoutConstraint!
    //Properties
    fileprivate let viewModal = EarnPointViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.baseScrollView.isHidden = true
        self.initialInterface()
        
        self.bindingViewModal()
        
        self.showShimmer()
        self.viewModal.callAPIService(withOffset: 0 , withLimit: 0)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initialInterface(){
        
        self.viewModal.delegate = self
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.earnPoints)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        let _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.bannerScrollsAuto), userInfo: nil, repeats: true)
        
        self.bannerCollectionView.delegate = viewModal
        self.bannerCollectionView.dataSource = viewModal
        self.giftCardsCollectionView.delegate = viewModal
        self.giftCardsCollectionView.dataSource = viewModal
        
    }
    
    
    func bindingViewModal(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "GiftViewController error! --------- %@",alertMessage ?? "")
            
            self.hideShimmer()
            
        }
        
        self.viewModal.bindingEarnPointViewModel = {(data:Any?, serviceType : Services) in
            
            self.hideShimmer()
            
            Utility.printLog(messge: "GiftViewController Success Api!  \(serviceType)")
            
            if serviceType == .offer_byPoints {
                DispatchQueue.main.async {
                    self.bannerCollectionView.reloadData()
                    self.giftCardsCollectionView.reloadData()
                    
                    self.adjustScrollView()
                }
            }
            
            
        }
    }
    
    private func adjustScrollView(){
        
        if viewModal.offerByPointsModalArray.count != 0{
            self.baseScrollView.isHidden = false
       
            self.earnPointsCollectionViewHC.constant = giftCardsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.view.setNeedsLayout()
        }
        
        
        
    }
    
    @objc private func bannerScrollsAuto (){
        
        if let coll  = bannerCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < viewModal.earnBannersModalArray.count - 1){
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
    }
    
    
    private func hideShimmer(){
        //        ABLoader().stopSmartShining(self.view1)
        //        ABLoader().stopSmartShining(self.view2)
    }
    
    
    
    private func moveToDetailViewController(code : String){
        
        //        let vc = MultipleStoryBoards.kGiftSB.instantiateViewController(withIdentifier: VCIdentifire.giftDetailViewController.rawValue) as! GiftDetailViewController
        //        vc.giftCode = code
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension EarnPointViewController : EarnPointViewModalDelegate{
    func onOfferDidClick(atRow: Int) {
        //        if let offerCode = self.viewModal.offerByPointsModalArray[atRow].offerDetailResponse?.code{
        //            let vc = MultipleStoryBoards.kHomeSB.instantiateViewController(withIdentifier: VCIdentifire.offerDetailViewController.rawValue) as! OfferDetailViewController
        //            vc.offerCode = offerCode
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    
}

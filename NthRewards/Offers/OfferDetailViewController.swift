//
//  OfferDetailViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 31/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage
import FittedSheets

enum OfferInfo : String {
    
    case offerDetail = "Offer Detail"
    case escalationMatrix = "Escalation Matrix"
    case termsAndCondition = "Terms & Conditions"
    case redemptionProcess = "Offer Redeem Process"
}

class OfferDetailViewController: UIViewController {
    
    
    @IBOutlet var bannerImageView: UIImageView!
    
    @IBOutlet var logoOfferImageView: UIImageView!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    
    @IBOutlet var userCodeLabel: UILabel!
    
    
    @IBOutlet var offerValidityLabel: UILabel!
    
    @IBOutlet var offerDetailTableView: UITableView!
    
    
    @IBOutlet var dottedView: UIView!
    
    @IBOutlet var offerDetailView2: UIView!
    
    @IBOutlet var redeemOfferButton: UIButton!
    
    
    @IBOutlet weak var shareButton: UIButton!
    //Properties
    fileprivate let viewModal = OfferDetailVM()
    
    public var offerCode : String?
    
    var offerDetailArray = [OfferInfo]()
    let offerDetailImageArray = ["offer_redeem_process" , "matrix" , "offer_detail" , "terms_conditions"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialInit()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.dottedView.addDottedMask()
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
        
        self.offerDetailTableView.isScrollEnabled = false;
        self.offerDetailTableView.separatorStyle = .none;
        
        self.offerDetailView2.addShadow()
        
        
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.offerDetail)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        //
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "OfferDetailViewController error! --------- %@",alertMessage ?? "")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
            
        }
        
        self.viewModal.bindingOfferDetailViewModel = {(data:Any?, serviceType : Services) in
            
            self.setOfferDetails()
            Utility.printLog(messge: "OfferDetailViewController Success Api!  \(serviceType)")
            
        }
        
        self.viewModal.callAPIService(offerCode: offerCode)
        
    }
    
    
    private func setOfferDetails() {
        
        DispatchQueue.main.async {
            
            
            self.bannerImageView.sd_setImage(with: URL(string: self.viewModal.offerDetailModal.offerDetailResponse?.imageLink ?? ""), placeholderImage: UIImage(named: "default"))
            self.logoOfferImageView.sd_setImage(with: URL(string: self.viewModal.offerDetailModal.offerDetailResponse?.logoImageLink ?? ""), placeholderImage: UIImage(named: "default"))
            
            self.descriptionLabel.text = self.viewModal.offerDetailModal.offerDetailResponse?.description ?? ""
            
            if let offerCode = self.viewModal.offerDetailModal.offerDetailResponse?.offerCode {
                if offerCode != ""{
                    self.userCodeLabel.text = "Use Code : \(offerCode)"
                }else{
                    self.dottedView.isHidden = true
                }
                
            }
            
            
            if let validity = self.viewModal.offerDetailModal.offerDetailResponse?.endDateTime {
                
                self.offerValidityLabel.text = Utility.UTCToLocal(date:validity , fromFormat: DateFormat.utc1.rawValue, toFormat: DateFormat.medStyle1.rawValue)
            }
            
            self.redeemOfferButton.isHidden =  (self.viewModal.offerDetailModal.offerDetailResponse?.externalLink == nil &&  self.viewModal.offerDetailModal.offerDetailResponse?.internalLink == nil) ? true : false
            
            
            if let _ = self.viewModal.offerDetailModal.offerDetailResponse?.longDescription {
                
                self.offerDetailArray.append(OfferInfo.offerDetail)
            }
            
            if let _ = self.viewModal.offerDetailModal.offerDetailResponse?.redemptionProcess {
                
                self.offerDetailArray.append(OfferInfo.redemptionProcess)
            }
            if let _ = self.viewModal.offerDetailModal.offerDetailResponse?.escalationMatrix {
                self.offerDetailArray.append(OfferInfo.escalationMatrix)
            }
            
            if let _ = self.viewModal.offerDetailModal.offerDetailResponse?.termAndCondition {
                self.offerDetailArray.append(OfferInfo.termsAndCondition)
            }
            
            Utility.printLog(messge: "FINAL ARRAY -----\(self.offerDetailArray)")
            
            
            self.offerDetailTableView.reloadData()
        }
        
        
    }
    
    private func moveToDetailViewController(code : String){
        
        //        let vc = MultipleStoryBoards.kGiftSB.instantiateViewController(withIdentifier: VCIdentifire.giftDetailViewController.rawValue) as! GiftDetailViewController
        //        vc.giftCode = code
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    private func openOfferStepInfoViewController(data : String?){
        
        if let bundle = Utility.bundle(forView: OfferInfoStepsViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let controller = storyboard.instantiateViewController(withIdentifier: VCIdentifire.offerInfoStepsViewController.rawValue) as! OfferInfoStepsViewController
            controller.typo = data
            let sheetController = SheetViewController(controller: controller)
            // It is important to set animated to false or it behaves weird currently
            self.present(sheetController, animated: false, completion: nil)
            
        }
        
        
        
        
        
    }
    
    
    //MARK; IBOutlets
    @IBAction func redeemOfferButtonClick(_ sender: Any) {
        
        if let link = URL(string: self.viewModal.offerDetailModal.offerDetailResponse?.externalLink ?? "") {
            UIApplication.shared.open(link)
        }else if let internalLink = self.viewModal.offerDetailModal.offerDetailResponse?.internalLink {
            let subInternalLinkss = internalLink.split(separator: "/")
            if let giftCardCode = subInternalLinkss.last{
                self.moveToDetailViewController(code: String(giftCardCode))
            }
        }
    }
    
    
    @IBAction func shareBtnClick(_ sender: Any) {
        
        let firstActivityItem = NSURL(string: "https://nthrewards.com/offers/offer-detail/" + (offerCode ?? ""))! //"Reward Points"
        // let secondActivityItem : NSURL = NSURL(string: "https://nthrewards.com/offers/offer-detail/" + (offerCode ?? ""))!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.unknown
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}


extension OfferDetailViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offerDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(min(Int(self.offerDetailTableView.frame.height)/self.offerDetailArray.count,80))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferDetailTableViewCell", for: indexPath as IndexPath) as! OfferDetailTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let offerInfo = offerDetailArray[indexPath.row]
        cell.nameLabel.text = offerInfo.rawValue
        
        Utility.printLog(messge: "OFFERINFO -------%@",offerInfo)
        
        switch  offerInfo {
        case .offerDetail:
            cell.imgView.image = UIImage.getImage(ofName: offerDetailImageArray[2])
            break
        case .redemptionProcess:
            cell.imgView.image = UIImage.getImage(ofName: offerDetailImageArray[0])
            break
        case .escalationMatrix:
            cell.imgView.image = UIImage.getImage(ofName: offerDetailImageArray[1])
            break
        case .termsAndCondition:do {
            cell.imgView.image = UIImage.getImage(ofName: offerDetailImageArray[3])
        }
        
            break
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let offerInfo = offerDetailArray[indexPath.row]
        switch  offerInfo {
        case .redemptionProcess:
            
            self.openOfferStepInfoViewController(data: self.viewModal.offerDetailModal.offerDetailResponse?.redemptionProcess)
            
            break
        case .escalationMatrix:
            self.openOfferStepInfoViewController(data: self.viewModal.offerDetailModal.offerDetailResponse?.escalationMatrix)
            break
        case .termsAndCondition:
            self.openOfferStepInfoViewController(data: self.viewModal.offerDetailModal.offerDetailResponse?.termAndCondition)
            break
            
        case .offerDetail:
            self.openOfferStepInfoViewController(data: self.viewModal.offerDetailModal.offerDetailResponse?.longDescription)
            break
        }
    }
    
    
    
    
}

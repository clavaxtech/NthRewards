//
//  HomeViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 20/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SDWebImage


class MenuOptionsCollectionCell : UICollectionViewCell{
    
    @IBOutlet weak var title: UILabel!
    
    static var identifier : String  {
        return String(describing:MenuOptionsCollectionCell.self)
    }
}


class HomeViewController: BaseViewController {
    
    
    //Anurag changes
    // Anurg chnages and
    
    @IBOutlet var baseScrollView: UIScrollView!
    
    @IBOutlet var menuOptionsCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    
    @IBOutlet var view4StackView: UIStackView!
    
    @IBOutlet var view2StackView: UIStackView!
    
    @IBOutlet var view3StackView: UIStackView!
    @IBOutlet var view1HC: NSLayoutConstraint!
    
    @IBOutlet var view2HC: NSLayoutConstraint!
    @IBOutlet var view3HC: NSLayoutConstraint!
    
    @IBOutlet var view4HC: NSLayoutConstraint!
    
    
    @IBOutlet var bannersCollectionView: UICollectionView!
    
    @IBOutlet var latestOfferCollectionView: UICollectionView!
    
    @IBOutlet var giftCardsCollectionView: UICollectionView!
    
    @IBOutlet var latestProductCollectionView: UICollectionView!
    
    @IBOutlet var latestProductCollectionViewHC: NSLayoutConstraint!
    
    
    
    @IBOutlet var productsViewAllButton: UIButton!
    
    
    //Properties
    fileprivate let homeViewModel = HomeVM()
    var cartView : UIView!
    var badgeLabel : UILabel!
    
    
    fileprivate var tempView1HC  : CGFloat = 0
    fileprivate var tempView2HC  : CGFloat = 0
    fileprivate var tempView3HC  : CGFloat  = 0
    fileprivate var tempView4HC  : CGFloat = 0
    fileprivate var tempLatestProductCollectionViewHC  : CGFloat = 0
    
    
    fileprivate let menuOptions = ["My Account" , "Offers", "Earn Points" , "Catalogue" , "Gift Cards" , "Order History" , "Activity Log"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.home)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        //        self.setupNavigationRightButtons()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        menuOptionsCollectionView.collectionViewLayout = flowLayout
        self.menuOptionsCollectionView.reloadData()
        
        
        let _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.bannerScrollsAuto), userInfo: nil, repeats: true)
        
        self.initialInit()
        
        self.showShimmer()
        self.homeViewModel.callApi()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //NotificationCenter.default.addObserver(self, selector: #selector(handleDidLeftMenuItemClick(notification:)), name: .didChangeVCFromeLeftMenu, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refershUIInterface), name:  UIApplication.didBecomeActiveNotification, object: nil)
        self.homeViewModel.callCartDetailService()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
        
        self.tempView1HC = self.view1HC.constant
        self.tempView2HC = self.view2HC.constant
        self.tempView3HC = self.view3HC.constant
        self.tempView4HC = self.view4HC.constant
        self.tempLatestProductCollectionViewHC = self.latestProductCollectionViewHC.constant
        
        self.homeViewModel.showAlert = { (alertMessage : String? , service : Services) in
            
            //Utility.printLog(messge: "HomeViewController error! --------- %@",alertMessage ?? "")
            
            self.hideShimmer()
            
        }
        
        self.homeViewModel.bindingHomeViewModel = {(data:Any?, serviceType : Services) in
            
            //Utility.printLog(messge: "HomeViewController Success Api!  \(serviceType)")
            self.hideShimmer()
            switch serviceType {
            case .banners:
                
                DispatchQueue.main.async {
                    self.bannersCollectionView.reloadData()
                    self.view1HC.constant = self.homeViewModel.bannersModals.count == 0 ? 0 : self.tempView1HC
                }
                break
            case .offers:
                DispatchQueue.main.async {
                    self.latestOfferCollectionView.reloadData()
                    self.view2HC.constant = self.homeViewModel.latestOffersModals.count == 0 ? 0 : self.tempView2HC
                }
                break
            case .giftcards:
                DispatchQueue.main.async {
                    self.giftCardsCollectionView.reloadData()
                    
                    self.view3HC.constant = self.homeViewModel.giftCardsModals.count == 0 ? 0 : self.tempView3HC
                }
                break
            case .products:
                DispatchQueue.main.async {
                    
                    
                    self.latestProductCollectionView.reloadData()
                    
                    self.latestProductCollectionViewHC.constant = self.latestProductCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.view4HC.constant = self.homeViewModel.productModals.count == 0 ? 0 : self.latestProductCollectionViewHC.constant + 70
                    
                }
                
                
            default:
                break
            }
            
        }
        
        
        self.homeViewModel.updateCart = { (data:Any?, serviceType : Services) in
            DispatchQueue.main.async {
                //                if let count = (data as? AddToCardModal)?.data?.products_list?.count{
                //
                //                    self.badgeLabel.text = String(count)
                //                }else{
                //                    self.badgeLabel.text = String(0)
                //                }
            }
        }
        
        
        
        
    }
    
    private func showShimmer(){
        
        
        self.activityIndicater.isHidden = false
        self.activityIndicater.startAnimating()
        self.baseScrollView.isHidden = true
    }
    
    
    private func hideShimmer(){
        
        self.activityIndicater.isHidden = true
        self.activityIndicater.stopAnimating()
        self.baseScrollView.isHidden = false
    }
    
    @objc private func bannerScrollsAuto (){
        
        if let coll  = bannersCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < homeViewModel.bannersModals.count - 1){
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
    
    private func resetAllCollectionView(){
        self.view1HC.constant = self.tempView1HC
        self.view2HC.constant = self.tempView2HC
        self.view3HC.constant = self.tempView3HC
        self.view4HC.constant = self.tempView4HC
        self.latestProductCollectionViewHC.constant = self.tempLatestProductCollectionViewHC
        self.view.layoutIfNeeded()
    }
    
    
    private func setupNavigationMenuButton(){
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
        ///button.addTarget(self, action: #selector(self.presentLeftMenuViewController(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0 , y : 0, width: 35.0, height: 35.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 0)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    
    private func setupNavigationRightButtons(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "cart"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20.0)
        button.addTarget(self, action:#selector(handleCart), for: .touchUpInside)
        
        
        cartView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        badgeLabel = UILabel(frame: CGRect(x: cartView.frame.size.width - 15, y: 0, width: 15, height: 15))
        badgeLabel.backgroundColor = UIColor.pageControl_fill
        badgeLabel.textColor = UIColor.white
        badgeLabel.font = FontBook.Helvetica_Bold.of(size: 10.0)
        badgeLabel.textAlignment = .center
        badgeLabel.numberOfLines = 1;
        badgeLabel.adjustsFontSizeToFitWidth = true;
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
        badgeLabel.layer.masksToBounds = true
        badgeLabel.text = String(describing:"0")
        
        cartView.addSubview(button)
        cartView.addSubview(badgeLabel)
        
        let barButtonItem = UIBarButtonItem(customView: cartView)
        
        
        let button2 = UIButton(type: .custom)
        button2.setImage(UIImage (named: "bell"), for: .normal)
        button2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10.0)
        button2.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        button2.addTarget(self, action:#selector(handleBell), for: .touchUpInside)
        
        let barButtonItem2 = UIBarButtonItem(customView: button2)
        
        self.navigationItem.rightBarButtonItems = [barButtonItem, barButtonItem2]
    }
    
    @objc func refershUIInterface(){
        
        if (self.homeViewModel.bannersModals.count == 0 || self.homeViewModel.latestOffersModals.count == 0 ||
            self.homeViewModel.giftCardsModals.count == 0 || self.homeViewModel.productModals.count == 0){
            self.resetAllCollectionView()
            self.homeViewModel.clearAllData()
            self.bannersCollectionView.reloadData()
            self.latestOfferCollectionView.reloadData()
            self.giftCardsCollectionView.reloadData()
            self.latestProductCollectionView.reloadData()
            self.showShimmer()
            self.homeViewModel.callApi()
        }
        
    }
    
    
    @objc func handleCart(){
        //        let cartDetailVC : CartViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.cartViewController.rawValue) as! CartViewController
        //        self.navigationController?.pushViewController(cartDetailVC, animated: true)
    }
    
    
    private func handleDidLeftMenuItemClick(atRow : Int){
          print("get go")
        switch atRow {
        case 0:
            print("get registred")
                //here is new changes
            
            if let bundle = Utility.bundle(forView: RegisterViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : MyAccountViewController = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        case 1:
            
            let podBundle = Bundle(for: OffersViewController.self)
            
            let bundleURL = podBundle.url(forResource: "NthRewards", withExtension: "bundle")
            let bundle = Bundle(url: bundleURL!)!
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "OffersViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            
            if let bundle = Utility.bundle(forView: EarnPointViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : EarnPointViewController = storyboard.instantiateViewController(withIdentifier: "EarnPointViewController") as! EarnPointViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        case 3:
            print("clicked at 3")
            
            if let bundle = Utility.bundle(forView: ProductViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : ProductViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 4:
            print("clicked at 4")
            
            if let bundle = Utility.bundle(forView: GiftViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : GiftViewController = storyboard.instantiateViewController(withIdentifier: "GiftViewController") as! GiftViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 5:
            
            if let bundle = Utility.bundle(forView: MyOrderViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : MyOrderViewController = storyboard.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        case 6:
            if let bundle = Utility.bundle(forView: ActivityLogViewController.self){
                
                let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
                let vc : ActivityLogViewController = storyboard.instantiateViewController(withIdentifier: "ActivityLogViewController") as! ActivityLogViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            print("default")
        }
    }
    
    
    @objc func handleBell(){
        
    }
    
    func didTapEditButton(sender: AnyObject){
        
    }
    
    func didTapSearchButton(sender: AnyObject){
        
    }
    
    private func moveToDetailViewController(offerCode : String?){
        
        //        let offersDetailVC = MultipleStoryBoards.kHomeSB.instantiateViewController(withIdentifier: VCIdentifire.offerDetailViewController.rawValue) as! OfferDetailViewController
        //        offersDetailVC.offerCode = offerCode
        //        self.navigationController?.pushViewController(offersDetailVC, animated: true)
        
        if let bundle = Utility.bundle(forView: OfferDetailViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : OfferDetailViewController = storyboard.instantiateViewController(withIdentifier: "OfferDetailViewController") as! OfferDetailViewController
            vc.offerCode = offerCode
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func moveToDetailViewController(product : Product){
        
        //        let vc = MultipleStoryBoards.kProduct.instantiateViewController(withIdentifier: VCIdentifire.productDetailViewController.rawValue) as! ProductDetailViewController
        //        vc.product = product
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if let bundle = Utility.bundle(forView: ProductDetailViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : ProductDetailViewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailViewController") as! ProductDetailViewController
            vc.product = product
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    
    
    //MARK: IBOutlets
    @IBAction func latestOfferViewAllClick(_ sender: Any) {
        
        //        let offersVC = MultipleStoryBoards.kHomeSB.instantiateViewController(withIdentifier: VCIdentifire.offersViewController.rawValue) as! OffersViewController
        //        self.navigationController?.pushViewController(offersVC, animated: true)
        
        if let bundle = Utility.bundle(forView: OffersViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : OffersViewController = storyboard.instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func giftsViewAllClick(_ sender: Any) {
        
        //        let giftVC = MultipleStoryBoards.kGiftSB.instantiateViewController(withIdentifier: VCIdentifire.giftViewController.rawValue) as! GiftViewController
        //        self.navigationController?.pushViewController(giftVC, animated: true)
        
        if let bundle = Utility.bundle(forView: GiftViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : GiftViewController = storyboard.instantiateViewController(withIdentifier: "GiftViewController") as! GiftViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func productViewAllBtnClick(_ sender: Any) {
        
        //        if let vc = MultipleStoryBoards.kProduct.instantiateViewController(withIdentifier: VCIdentifire.productViewController.rawValue) as? ProductViewController{
        //            self.navigationController?.pushViewController(vc, animated: true)
        //        }
        
        if let bundle = Utility.bundle(forView: ProductViewController.self){
            
            let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
            let vc : ProductViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}


extension HomeViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
            
            return homeViewModel.bannersModals.count
            
        }else if collectionView.tag == 2{
            
            return homeViewModel.latestOffersModals.count
            
        }else if collectionView.tag == 3 {
            
            return homeViewModel.giftCardsModals.count
        }
        else if collectionView.tag == 4 {
            
            return homeViewModel.productModals.count >= 4 ? 4 : homeViewModel.productModals.count
        }else if collectionView.tag == 5{
            
            return menuOptions.count
        }
        
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath as IndexPath) as! BannerCollectionViewCell
            
            let banner = homeViewModel.bannersModals[indexPath.row]
            cell.imageViewBanner.clipsToBounds = true
            cell.imageViewBanner.sd_setImage(with: URL(string:  banner.image ?? ""), placeholderImage: UIImage(named: "default"), options: SDWebImageOptions(rawValue: 0)) { (image:UIImage?, error :Error?, cache, url) in
                
                guard let image = image else { return }
                cell.imageViewBanner.image = image.sd_resizedImage(with: self.bannersCollectionView.frame.size, scaleMode: SDImageScaleMode.aspectFill)
            }
            
            return cell
            
        }else if collectionView.tag == 2 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestOfferCollectionViewCell", for: indexPath as IndexPath) as! LatestOfferCollectionViewCell
            
            if let offerDetailResponse = self.homeViewModel.latestOffersModals[indexPath.row].offerDetailResponse {
                
                cell.logoImageView.sd_setImage(with: URL(string: offerDetailResponse.logoImageLink ?? ""), placeholderImage: UIImage(named: ""))
                
                if let description = offerDetailResponse.description {
                    cell.offerDescription.text = description
                }
                
            }
            
            var colorGrdient : (UIColor,UIColor)
            
            if indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8 || indexPath.row == 12 || indexPath.row == 16{
                colorGrdient = UIColor.gradient1
            }else if  indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 9 || indexPath.row == 13 || indexPath.row == 17{
                colorGrdient = UIColor.gradient2
            }else if indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 10 || indexPath.row == 14 || indexPath.row == 18{
                colorGrdient = UIColor.gradient3
            }else{
                colorGrdient = UIColor.gradient4
            }
            cell.layer.insertSublayer(Utility.gradient(frame:  cell.bounds, colorTuple: colorGrdient), at:0)
            
            return cell
            
            
        }else if collectionView.tag == 3 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCardCollectionViewCell", for: indexPath as IndexPath) as! GiftCardCollectionViewCell
            let giftCard = homeViewModel.giftCardsModals[indexPath.row]
            
            if let logoImageUrl = giftCard.image {
                cell.logoImageView.sd_setImage(with: URL(string: logoImageUrl), placeholderImage: UIImage(named: "default"))
            }
            cell.logoImageView.clipsToBounds = true
            
            return cell
            
        }else if collectionView.tag == 4 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingProductCollectionViewCell", for: indexPath as IndexPath) as! TrendingProductCollectionViewCell
            
            
            let product = homeViewModel.productModals[indexPath.row]
            
            if let image = product.image {
                let finalImage = image.replacingOccurrences(of: " ", with: "%20")
                cell.productImage.sd_setImage(with: URL(string: finalImage), placeholderImage: UIImage(named: "default"), options: SDWebImageOptions(rawValue: 0)) { (image:UIImage?, error :Error?, cache, url) in
                    
                    if error != nil {
                        Utility.printLog(messge: "URL IS INVALID ----> \(String(product.image ?? "XXXXX"))")
                        Utility.printLog(messge: "Error ----> \(String(describing: error))")
                    }
                }
            }
            
            
            cell.descriptionLabel.text = product.title ?? ""
            
            if let price = product.price {
                cell.pointsLabel.text = "Pts : \(price.points)"
                cell.priceLabel.text = "₹ \(price)"
                
            }
            cell.baseView.addShadow()
            
            return cell
            
        }else if collectionView.tag == 5{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuOptionsCollectionCell", for: indexPath as IndexPath) as! MenuOptionsCollectionCell
            cell.title.text = menuOptions[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1{
            
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
            
        }else if collectionView.tag == 2{
            
            let width = collectionView.frame.size.width - 10
            return CGSize(width: width/2, height: collectionView.frame.size.height)
            
        }else if collectionView.tag == 3 {
            
            let width = collectionView.frame.size.width - 5
            let height = collectionView.frame.size.height - 3
            return CGSize(width: width/2, height: height/2)
            
        }else if collectionView.tag == 4 {
            
            let width = collectionView.frame.size.width - 5
            let height = collectionView.frame.size.height - 3
            return CGSize(width: width/2, height: height/2)
            
        }else if collectionView.tag == 5 {
            print("flowlayout running")
            let width : CGFloat = 90
            let height = collectionView.frame.size.height
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView.tag == 1{
            if let offerUrl = self.homeViewModel.bannersModals[indexPath.row].offer_code{
                let offerCode = offerUrl.split(separator: "/").filter({$0.hasPrefix("NTH")})
                if offerCode.count > 0{
                    self.moveToDetailViewController(offerCode:String(offerCode[0]))}
            }
            
        }else if collectionView.tag == 2{
            
            self.moveToDetailViewController(offerCode: self.homeViewModel.latestOffersModals[indexPath.row].offerDetailResponse?.code)
            
        }else if collectionView.tag == 3 {
            
            if let giftCode = self.homeViewModel.giftCardsModals[indexPath.row].code {
                self.moveToDetailViewController(code: giftCode)
            }
            
        }else if collectionView.tag == 4 {
            
            self.moveToDetailViewController(product: self.homeViewModel.productModals[indexPath.row])
            
        }else if collectionView.tag == 5{
            
            self.handleDidLeftMenuItemClick(atRow: indexPath.row)
        }
    }
    
}

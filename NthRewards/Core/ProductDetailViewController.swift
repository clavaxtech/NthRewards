    //
    //  ProductDetailViewController.swift
    //  nth Rewards
    //
    //  Created by akshay on 11/12/19.
    //  Copyright © 2019 Deepak Tomar. All rights reserved.
    //
    
    import UIKit
    import FittedSheets
    
    class ProductDetailViewController: UIViewController {
        
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var productDetailView: UIView!
        
        @IBOutlet weak var tableView: UITableView!
        
        @IBOutlet weak var productTitleLabel: UILabel!
        
        @IBOutlet weak var pointsLabel: UILabel!
        @IBOutlet weak var totalAmountLabel: UILabel!
        
        //Properties
        fileprivate let viewModal = ProductDetailViewModal()
        var cartView : UIView!
        var badgeLabel : UILabel!
        private var cartAddButtonType = AddCartButtonType.none
        
        public var product : Product!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view.
            self.initialSetup()
            // self.setupCartButton()
            
            self.bindingViewModals()
        }
        
        
        override func viewWillAppear(_ animated: Bool) {
            self.viewModal.callCartDetailService()
        }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
        
        
        func initialSetup(){
            
            self.viewModal.delegate = self
            
            self.tableView.delegate = viewModal
            self.tableView.dataSource = viewModal
            
            self.tableView.isScrollEnabled = false;
            self.tableView.separatorStyle = .none;
            
            self.productDetailView.addShadow()
            
            //            if let title = product.title{
            //                self.setNavigationBar(hidden: false, controller: self, titleName: title)
            //            }else{
            //                self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.catalogue)
            //            }
            //            self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
            
            self.setOfferDetails()
        }
        
        
        func bindingViewModals(){
            self.viewModal.updateCart = {(data:Any?, serviceType : Services) in
                DispatchQueue.main.async {
                    //                    if let cartValue = (data as? AddToCardModal)?.data?.products_list?.count{
                    //                        self.badgeLabel.text = String(cartValue)
                    //                    }else{
                    //                        self.badgeLabel.text = String(0)
                    //                    }
                }
            }
            
            self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
                
                // self.hideHud()
                Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
                
            }
            
            self.viewModal.bindingProductDetailViewModel = {(data:Any?, serviceType : Services) in
                
                // self.hideHud()
                
                if serviceType == .addtocart{
                    
                    if self.cartAddButtonType == AddCartButtonType.addCart{
                        
                        if let toastMessage = (data as? AddToCardModal)?.message {
                            Toast.show(message: toastMessage, controller: self)
                        }
                        
                        //                        if let cartValue = (data as? AddToCardModal)?.data?.products_list?.count{
                        //                            self.badgeLabel.text = String(cartValue)
                        //                            Utility.animateCart(lockView: self.cartView)
                        //                        }else{
                        //                            self.badgeLabel.text = String(0)
                        //                        }
                    }else if self.cartAddButtonType == AddCartButtonType.checkout{
                        //                        let cartDetailVC : CartViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.cartViewController.rawValue) as! CartViewController
                        //                        self.navigationController?.pushViewController(cartDetailVC, animated: true)
                    }
                    
                }
            }
        }
        
        
        private func setOfferDetails() {
            
            DispatchQueue.main.async {
                if let image = self.product.image {
                    let finalImage = image.replacingOccurrences(of: " ", with: "%20")
                    self.imageView.sd_setImage(with: URL(string: finalImage), placeholderImage: UIImage(named: "default"))
                }
                
                
                
                self.productTitleLabel.text = self.product.title ?? ""
                if let price = self.product.price {
                    self.pointsLabel.text = "\(String(describing: price.points)) Pts"
                    self.totalAmountLabel.text = "Rs \(price)"
                }else{
                    self.pointsLabel.isHidden = true
                    self.totalAmountLabel.isHidden = true
                }
                
                self.tableView.reloadData()
            }
        }
        
        
        private func openOfferStepInfoViewController(data : String?){
            
            //            let controller = MultipleStoryBoards.kHomeSB.instantiateViewController(withIdentifier: VCIdentifire.offerInfoStepsViewController.rawValue) as! OfferInfoStepsViewController
            //            controller.typo = data
            //            let sheetController = SheetViewController(controller: controller)
            //            // It is important to set animated to false or it behaves weird currently
            //            self.present(sheetController, animated: false, completion: nil)
        }
        
        
        private func setupCartButton(){
            let button = UIButton(type: .custom)
            button.setImage(UIImage (named: "cart"), for: .normal)
            button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
            // button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20.0)
            button.addTarget(self, action:#selector(handleCart), for: .touchUpInside)
            
            
            cartView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
            
            badgeLabel = UILabel(frame: CGRect(x: cartView.frame.size.width - 15, y: 0, width: 15, height: 15))
            badgeLabel.backgroundColor = UIColor.pageControl_fill
            badgeLabel.textColor = UIColor.white
            badgeLabel.font = FontBook.Helvetica_Bold.of(size: 10.0)
            badgeLabel.numberOfLines = 1;
            badgeLabel.adjustsFontSizeToFitWidth = true;
            badgeLabel.textAlignment = .center
            badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width/2
            badgeLabel.layer.masksToBounds = true
            badgeLabel.text = String(describing:"0")
            
            cartView.addSubview(button)
            cartView.addSubview(badgeLabel)
            
            let barButtonItem = UIBarButtonItem(customView: cartView)
            
            self.navigationItem.rightBarButtonItems = [barButtonItem]
            
        }
        
        
        @objc func handleCart(){
            //            let cartDetailVC : CartViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.cartViewController.rawValue) as! CartViewController
            //            self.navigationController?.pushViewController(cartDetailVC, animated: true)
        }
        
        @IBAction func addToCartBtnClick(_ sender: Any) {
            
            var parameters = [String:Any]()
            parameters["item_type"] = "Product"
            parameters["quantity"] = 1
            parameters["message"] = ""
            parameters["receiver_email"] = ""
            parameters["receiver_name"] = ""
            parameters["sender_name"] = ""
            parameters["receiver_mobile"] = ""
            
            parameters["product_code"] =  self.product.code ?? ""
            
            parameters["user_code"] =  UserInfo.getUserInformation()?.data?.customercode ?? ""
            parameters["denomination"] = self.product.price ?? 0
            
            self.cartAddButtonType = .addCart
            //self.showHud()
            self.viewModal.callAddToCartService(withDic: parameters)
        }
        
        @IBAction func placeOrderBtnClick(_ sender: Any) {
            var parameters = [String:Any]()
            parameters["item_type"] = "Product"
            parameters["quantity"] = 1
            parameters["message"] = ""
            parameters["receiver_email"] = ""
            parameters["receiver_name"] = ""
            parameters["sender_name"] = ""
            parameters["receiver_mobile"] = ""
            
            parameters["product_code"] = self.product.code ?? ""
            
            parameters["user_code"] =  UserInfo.getUserInformation()?.data?.customercode ?? ""
            parameters["denomination"] = self.product.price ?? 0
            
            self.cartAddButtonType = .checkout
            //self.showHud()
            self.viewModal.callAddToCartService(withDic: parameters)
        }
        
    }
    
    
    extension ProductDetailViewController : ProductDetailViewModalDelegate{
        func onDidClick(atIndex: Int) {
            if let description = self.product.description {
                openOfferStepInfoViewController(data: description) }
        }
        
    }

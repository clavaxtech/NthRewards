//
//  CartViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 11/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import FittedSheets

class CartViewController: BaseViewController {
    
    
    //MARK: IBOUTLETS
    
    @IBOutlet var emptyView: UIView!
    
    
    @IBOutlet var fastForwardEditButton: UIButton!
    
    @IBOutlet var baseScrollView: UIScrollView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var containerViewHC: NSLayoutConstraint!
    
    @IBOutlet var itemTableViewHC: NSLayoutConstraint!
    
    @IBOutlet var itemTableView: UITableView!
    
    
    @IBOutlet var view2: UIView!
    
    
    @IBOutlet var view2HC: NSLayoutConstraint!
    
    @IBOutlet var view2CollapseButton: UIButton!
    
    @IBOutlet var view2PaymentOptionStackView: UIStackView!
    
    @IBOutlet var view2PointsRenderedView: UIView!
    
    
    @IBOutlet var fastForwardButton: UIButton!
    
    @IBOutlet var throughBankButton: UIButton!
    
    @IBOutlet var view2PointsRedeemLabel: UILabel!
    @IBOutlet var view2AmountLabel: UILabel!
    
    
    @IBOutlet var view3: UIView!
    
    @IBOutlet var subTotalView: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    @IBOutlet var valueOfPointsRedeemLabel: UILabel!
    
    @IBOutlet var finalSummaryView: UIView!
    
    @IBOutlet var placeOrderButton: UIButton!
    
    
    @IBOutlet var totalPayableAmountLabel: UILabel!
    
    
    
    //MARK: Properties
    fileprivate let viewModal = CartViewModal()
    
    private let view2HCValue : CGFloat = 160
    
    private var totalPoints : Int = 0
    private var subTotals : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        
        self.viewModal.delegate = self
        
        self.emptyView.isHidden = true
        self.baseScrollView.isHidden = true
        self.finalSummaryView.isHidden = true
        self.placeOrderButton.isHidden = true
        
        self.itemTableView.delegate = viewModal
        self.itemTableView.dataSource = viewModal
        self.itemTableView.separatorStyle = .none
        
        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.shoppingCart)
        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.view2.addShadow()
        self.view3.addShadow()
        
        
        self.view2PointsRedeemLabel.text = ""
        self.view2AmountLabel.text = ""
        
        self.view2CollapseButton.isSelected = false
        self.view2Collapsed()
        
        self.fastForwardEditButton.isHidden = true
        
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
           // self.hideHud()
            Utility.printLog(messge: "CartView Controller error! --------- %@",alertMessage ?? "")
            //Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
            
        }
        
        self.viewModal.bindingCartViewModel = { (data:Any?, serviceType : Services) in
           // self.hideHud()
            Utility.printLog(messge: "Cart View Controller success \(serviceType.rawValue)")
            if serviceType == .cartDetail{
                
            }else if serviceType == .deletefromcart{
                
            }else if serviceType == .updatecart{
                
                
            }
            
            DispatchQueue.main.async {
                self.updateTableInterface()
                self.updatePriceDetailInterface()
                
                self.adjustScrollView()
                
            }
        }
        
        //self.showHud()
        self.viewModal.callCartDetailService()
        self.viewModal.callCustomerWalletInfolService()
        
    }
    
    private func updateTableInterface(){
        
        Utility.printLog(messge: "Update TableInterface")
        
        if self.viewModal.productList.count == 0{
            Utility.printLog(messge: "Update TableInterface count is zero")
            self.emptyView.isHidden  = false
            self.baseScrollView.isHidden = true
            self.finalSummaryView.isHidden = true
            self.placeOrderButton.isHidden = true
             //self.placeOrderButton.setTitle( "Continue Shopping" , for: .normal)
            
            
        }else{
            Utility.printLog(messge: "Update TableInterface count is Not zero")
            self.emptyView.isHidden = true
            self.baseScrollView.isHidden = false
            self.finalSummaryView.isHidden = false
            self.itemTableView.reloadData()
            self.placeOrderButton.isHidden = false
            //self.placeOrderButton.setTitle( "Place Order" , for: .normal)
            
            
        }
    }
    
    private func updatePointsInterface(){
        
        DispatchQueue.main.async {
            if self.totalPoints > 0 {
                
                self.view2PointsRedeemLabel.text = "\(self.totalPoints)Pts"
                self.view2AmountLabel.text = String(self.totalPoints.amount)
                
                
            }else{
                self.view2PointsRedeemLabel.text = ""
                self.view2AmountLabel.text = ""
                
            }
            
        }
    }
    
    private func updatePriceDetailInterface(){
        
        self.subTotals = self.viewModal.cartModalObj?.data?.total ?? 0
        
        self.subTotalView.text =  "₹ \( self.subTotals)"
        self.valueOfPointsRedeemLabel.text =  "₹ \(self.totalPoints.amount)"
        
        let totalValue = self.subTotals - self.totalPoints.amount
        self.totalLabel.text =  "₹ \(totalValue)"
        
        self.totalPayableAmountLabel.text = "₹ \(totalValue)"
    }
    
    
    
    
    private func adjustScrollView(){
        
        DispatchQueue.main.async {
            
            self.itemTableViewHC.constant = CGFloat(self.viewModal.productList.count * self.viewModal.ItemHeight)
            
            self.containerViewHC.constant = self.itemTableViewHC.constant + self.view2.frame.height + self.view3.frame.height + 100
            
        }
    }
    
    @IBAction func view2CollapseButtonClick(_ sender: UIButton) {
        
        let isSelected = view2CollapseButton.isSelected
        view2CollapseButton.isSelected = !isSelected
        
        if !isSelected {
            
            self.view2Uncollpased()
        }else{
            
            self.view2Collapsed()
        }
        
        self.adjustScrollView()
        
    }
    
    private func view2Collapsed(){
        Utility.printLog(messge: "unselected")
        
        self.view2HC.constant = 70
        
        self.view2PaymentOptionStackView.isHidden = true
        self.view2PointsRenderedView.isHidden = true
        UIView.animate(withDuration: 0.4) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    private func view2Uncollpased(){
        Utility.printLog(messge: "selected")
        
        self.view2HC.constant = self.view2HCValue
        
        self.view2PaymentOptionStackView.isHidden = false
        self.view2PointsRenderedView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func fastForwardButtonClick(_ sender: Any) {
        Utility.printLog(messge: "FastForward Button")
        
        let isSelected = self.fastForwardButton.isSelected
        
        if !isSelected{
            self.fastForwardEditButton.isHidden = false
        }else{
            self.fastForwardEditButton.isHidden = true
        }
        
        self.fastForwardButton.isSelected = !isSelected
        self.throughBankButton.isSelected = isSelected
        
    }
    
    @IBAction func throughBankButtonClick(_ sender: Any) {
        
        Utility.printLog(messge: "Through Bank Button")
        
        let isSelected = self.throughBankButton.isSelected
        self.throughBankButton.isSelected = !isSelected
        self.fastForwardButton.isSelected = isSelected
    }
    
    
    @IBAction func fastForwardEditButtonClick(_ sender: Any) {
        
//        let fastForwardVC : FastForwardRedeemViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.fastForwardRedeemViewController.rawValue) as! FastForwardRedeemViewController
//        fastForwardVC.maxPoints = self.subTotals.points
//        fastForwardVC.modalPresentationStyle = .overCurrentContext
//        fastForwardVC.delegate = self
//        // It is important to set animated to false or it behaves weird currently
//        self.present(fastForwardVC, animated: true, completion: nil)
    }
    
    
    @IBAction func placeOrderButtonClick(_ sender: Any) {
        
//        if placeOrderButton.titleLabel?.text == "Place Order"{
//
//            let checkoutObjc = CheckoutModal()
//            checkoutObjc.redeemPoints = self.totalPoints
//            checkoutObjc.totalAmount = self.subTotals - self.totalPoints.amount
//
//            if checkoutObjc.totalAmount < 0 {
//                return
//            }
//
//            let addressVC : AddressViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.addressViewController.rawValue) as! AddressViewController
//            addressVC.checkout = checkoutObjc
//            self.navigationController?.pushViewController(addressVC, animated: true)
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
    
}

extension CartViewController : CartViewModalDelegate{

    func updateCartItem(indexPath: IndexPath, quantity: String) {
        var parameters = [String:Any]()

        if let cartCode = self.viewModal.cartModalObj?.data?.code{
            parameters["cart_code"] = cartCode
        }

        if let denomination  =  self.viewModal.productList[indexPath.row].denomination {
            parameters["denomination"] = denomination
        }
        if let itemType  =  self.viewModal.productList[indexPath.row].item_type {
            parameters["item_type"] = itemType
        }
        if let product_code  =  self.viewModal.productList[indexPath.row].product_code {
            parameters["product_code"] = product_code
        }
        if let user_code = UserInfo.getUserInformation()?.data?.customercode   {
            parameters["user_code"] = user_code
        }
        parameters["quantity"] = quantity

        //self.showHud()
        self.viewModal.updateCart(dic: parameters)
    }



    func deleteCartItem(indexPath: IndexPath) {

        let alert = UIAlertController(title: key.k_Alert, message: key.k_Msg_DeleteConfirmation, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            var parameters = [String:Any]()
            if let cartCode = self.viewModal.cartModalObj?.data?.code {
                parameters["cart_code"] = cartCode
            }
            if let productCode = self.viewModal.productList[indexPath.row].product_code {
                parameters["product_code"] = productCode
            }
            //self.showHud()
            self.viewModal.deleteCartItem(dic: parameters)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}


extension CartViewController : FastForwardRedeemViewControllerDelegate{

    func pointToBeRedeem(points: String) {
        print("FINAL POINTS TO BE REDEEMED")
        if let points = Int(points){
            self.totalPoints = points
        }

        self.updatePointsInterface()
        self.updatePriceDetailInterface()

    }

}

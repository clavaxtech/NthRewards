//
//  GiftDetailViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 03/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FittedSheets

enum AddCartButtonType {
    case addCart
    case checkout
    case none
}

class GiftDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var baseScrollView: UIScrollView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var dominationCollectionView: UICollectionView!
    
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    
    @IBOutlet var senderNameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var receiverNameTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet var receiverEmailTextField: SkyFloatingLabelTextField!
    
    
    @IBOutlet var receiverNumberTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var receiverMessageTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var discountLabelFinal: UILabel!
    
    @IBOutlet var amountLabelFinal: UILabel!
    
    
    @IBOutlet weak var totalAmountViewHC: NSLayoutConstraint!
    
    
    @IBOutlet var descriptionLabel: UILabel!
    
    
    @IBOutlet var discountInfoLabel: UILabel!
    
    //MARK: Properties
    
    let TOTAL_AMOUNT_VIEW_EXPAND_HC : CGFloat = 60
    let TOTAL_AMOUNT_VIEW_COLLAPSE_HC : CGFloat = 45
    
    fileprivate let viewModal  = GiftDetailViewModal()
    private var currentAmountValue = 1
    public var giftCode : String?
    
    var cartView : UIView!
    var badgeLabel : UILabel!
    
    var finalDiscountValue : Int = 0
    
    private var cartAddButtonType = AddCartButtonType.none
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.setupCartButton()
        self.initialInit()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerKeyboardNotifications()
        self.viewModal.callCartDetailService()
        cartAddButtonType = AddCartButtonType.none
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func initialInit(){
        
        self.baseScrollView.keyboardDismissMode = .interactive;
        //
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.gifts)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.dominationCollectionView.delegate = viewModal
        self.dominationCollectionView.dataSource = viewModal
        let layout = dominationCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumInteritemSpacing = 8
        
        self.discountInfoLabel.textColor = UIColor.pageControl_fill
        self.discountInfoLabel.text = ""
        
        
        self.viewModal.updateCart = {(data:Any?, serviceType : Services) in
            DispatchQueue.main.async {
//                if let cartValue = (data as? AddToCardModal)?.data?.products_list?.count{
//                    self.badgeLabel.text = String(cartValue)
//                }else{
//                    self.badgeLabel.text = String(0)
//                }
            }
        }
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            //self.hideHud()
            Utility.printLog(messge: "GiftViewController error! --------- %@",alertMessage ?? "")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
            
        }
        
        self.viewModal.bindingGiftDetailViewModel = {(data:Any?, serviceType : Services) in
            
            //self.hideHud()
            
            if serviceType == .gift_detail{
                Utility.printLog(messge: "GiftViewController Success Api!  \(serviceType)")
                DispatchQueue.main.async {
                    self.setGiftModalData()
                }
            }else if serviceType == .addtocart{
                
                if self.cartAddButtonType == AddCartButtonType.addCart{
                    
                    if let toastMessage = (data as? AddToCardModal)?.message {
                        Toast.show(message: toastMessage, controller: self)
                    }
                    
                    if let cartValue = (data as? AddToCardModal)?.data?.products_list?.count{
                        self.badgeLabel.text = String(cartValue)
                        Utility.animateCart(lockView: self.cartView)
                    }else{
                        self.badgeLabel.text = String(0)
                    }
                }else if self.cartAddButtonType == AddCartButtonType.checkout{
                    //                    let cartDetailVC : CartViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.cartViewController.rawValue) as! CartViewController
                    //                    self.navigationController?.pushViewController(cartDetailVC, animated: true)
                }
                
            }
            
        }
        
        
        self.viewModal.updatePoints = {
            let totalValue = self.viewModal.denominationSelectedValue
            self.discountInfoLabel.text = self.viewModal.discountInfo ?? ""
            
            if let discountValues = self.viewModal.DiscountResponse{
                
                Utility.printLog(messge: "// DISCOUNT AVAILABLE////////////")
                
                Utility.printLog(messge: "Discount values are -------\(discountValues)")
                if discountValues.type == "fixed"{
                    
                    if let value = discountValues.value {
                        
                        let discountedValue = totalValue - value
                        
                        self.finalDiscountValue = Int(discountedValue)
                        
                        let finalActualWithQuantity = totalValue * Int(self.amountLabel.text ?? "0")!
                        let finalDiscountedWithQuantity = discountedValue * Int(self.amountLabel.text ?? "0")!
                        
                        Utility.printLog(messge: "totalValue Value  -------\(totalValue)")
                        Utility.printLog(messge: "Discounted Value  -------\(discountedValue)")
                        
                        self.pointsLabel.text = "Pts : \(finalDiscountedWithQuantity.points)"
                        
                        
                        self.amountLabelFinal.text = String(finalDiscountedWithQuantity)
                        
                        
                        
                        
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(Int(finalActualWithQuantity) ))
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        self.discountLabelFinal.attributedText = attributeString
                        self.discountLabelFinal.isHidden = false
                        
                        self.totalAmountViewHC.constant = self.TOTAL_AMOUNT_VIEW_EXPAND_HC
                    }
                    
                }else{
                    if let  percentage = discountValues.value {
                        
                        let InPercentageValue : Double  = (Double(percentage)/100.0)
                        
                        let finalValue  = InPercentageValue * Double(totalValue)
                        
                        let discountedValue = Double(totalValue) - finalValue
                        
                        self.finalDiscountValue = Int(discountedValue)
                        
                        let finalActualWithQuantity = totalValue * Int(self.amountLabel.text ?? "0")!
                        let finalDiscountedValueWithQuantity = Int(discountedValue) * Int(self.amountLabel.text ?? "0")!
                        
                        Utility.printLog(messge: "InPercentageValue Value  -------\(InPercentageValue)")
                        Utility.printLog(messge: "Percentage Value  -------\(percentage)")
                        Utility.printLog(messge: "totalValue Value  -------\(totalValue)")
                        Utility.printLog(messge: "Discounted Final Value  -------\(finalValue)")
                        
                        self.pointsLabel.text = "Pts : \(Int(finalDiscountedValueWithQuantity).points)"
                        
                        self.amountLabelFinal.text =  "₹ " + String(Int(finalDiscountedValueWithQuantity))
                        
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "₹ " + String(Int(finalActualWithQuantity) ))
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        self.discountLabelFinal.attributedText =   attributeString
                        self.discountLabelFinal.isHidden = false
                        self.totalAmountViewHC.constant = self.TOTAL_AMOUNT_VIEW_EXPAND_HC
                        
                    }
                    
                }
                
            }
                
            else {
                Utility.printLog(messge: "// NO DISCOUNT////////////")
                
                self.finalDiscountValue = Int(totalValue)
                
                let finalActualValueWithQuantity = totalValue * Int(self.amountLabel.text ?? "0")!
                
                self.pointsLabel.text = "Pts : \(Int(finalActualValueWithQuantity).points)"
                
                self.discountLabelFinal.text = ""
                self.discountLabelFinal.isHidden = true
                self.amountLabelFinal.text =  "₹ " + String(finalActualValueWithQuantity)
                self.discountInfoLabel.text = ""
                self.totalAmountViewHC.constant = self.TOTAL_AMOUNT_VIEW_COLLAPSE_HC
            }
        }
        
        if let code = giftCode {
            // self.showHud()
            self.viewModal.callAPIService(giftCode: code)
            
        }
        
    }
    
    private func setGiftModalData(){
        
        guard let giftModal = self.viewModal.giftDetailObject else {return}
        
        self.logoImageView.sd_setImage(with: URL(string: giftModal.image ?? ""), placeholderImage: UIImage(named: "tutorial1"))
        self.titleLabel.text = giftModal.title ?? ""
        
        Utility.printLog(messge: "Description ====== \(String(describing: giftModal.description))")
        
        self.descriptionLabel.text = self.viewModal.descriptionValue ?? ""
        
        self.dominationCollectionView.reloadData()
        
        self.viewModal.updatePoints?()
    }
    
    
    private func setupCartButton(){
        let button = UIButton(type: .custom)
        button.setImage(UIImage (named: "cart"), for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        // button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20.0)
        button.addTarget(self, action:#selector(handleCart), for: .touchUpInside)
        
        
        cartView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        //cartView.backgroundColor = UIColor.yellow
        
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
        //        let cartDetailVC : CartViewController = MultipleStoryBoards.kShoppingCart.instantiateViewController(withIdentifier: VCIdentifire.cartViewController.rawValue) as! CartViewController
        //        self.navigationController?.pushViewController(cartDetailVC, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.baseScrollView.contentInset = contentInsets
        self.baseScrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.baseScrollView.contentInset = .zero
        self.baseScrollView.scrollIndicatorInsets = .zero
    }
    
    @objc func endAllEditing(){
        self.view.endEditing(true)
    }
    
    
    
    //MARK: IBOUTLETS
    @IBAction func amtNegativeClick(_ sender: Any) {
        if self.currentAmountValue > 1{
            self.currentAmountValue -= 1
        }
        
        self.amountLabel.text = String(self.currentAmountValue)
        self.viewModal.updatePoints?()
    }
    
    @IBAction func amtPositiveClick(_ sender: Any) {
        if self.currentAmountValue < self.viewModal.maxQuantityValue {
            self.currentAmountValue += 1
        }
        self.amountLabel.text = String(self.currentAmountValue)
        self.viewModal.updatePoints?()
    }
    
    
    @IBAction func termsAndConditionButtonClick(_ sender: Any) {
        
        if let data = self.viewModal.termsAndCondition {
            
            //            let controller = MultipleStoryBoards.kGiftSB.instantiateViewController(withIdentifier: VCIdentifire.termsAndConditionViewController.rawValue) as! TermsAndConditionViewController
            //            controller.tandCText = data
            //            let sheetController = SheetViewController(controller: controller)
            //
            //            // It is important to set animated to false or it behaves weird currently
            //            self.present(sheetController, animated: false, completion: nil)
        }
        
    }
    
    
    @IBAction func addToCardButtonClick(_ sender: Any) {
        
        if (self.senderNameTextField.text?.trim() == "" || self.receiverNameTextField.text?.trim() == "" || self.receiverEmailTextField.text?.trim() == "" || self.receiverNumberTextField.text?.trim() == "") {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Required)
            return
        }
        let Special = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let characterInverted = CharacterSet(charactersIn: Special).inverted
        let phonefilters: String = (self.receiverNumberTextField.text!.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
        
        
        let validation = Utility.commonEmailValidations(emailString: self.receiverEmailTextField.text!)
        if !validation.0 {
            self.showAlertView(title: key.k_Alert, message: validation.1)
            return
        }
        
        
        if (self.receiverNumberTextField.text!.count) != 10 {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Phone)
            return
        }
            
        else if self.receiverNumberTextField.text! == phonefilters {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_PhoneAlpha)
            return
        }
        
        
        var parameters = [String: Any]()
        parameters["denomination"] = String(self.viewModal.denominationSelectedValue)
        parameters["item_type"] = "Giftcard"
        
        
        parameters["discount_price"] = String(self.finalDiscountValue)
        
        
        if let code = self.viewModal.giftDetailObject?.code {
            parameters["product_code"] = code
        }
        if let quantity = self.amountLabel.text {
            parameters["quantity"] = quantity
        }
        
        if let message = self.receiverMessageTextField.text {
            parameters["message"] = message
        }
        if let email = self.receiverEmailTextField.text {
            parameters["receiver_email"] = email
        }
        if let name = self.receiverNameTextField.text {
            parameters["receiver_name"] = name
        }
        if let name = self.senderNameTextField.text {
            parameters["sender_name"] = name
        }
        if let no = self.receiverNumberTextField.text {
            parameters["receiver_mobile"] = no
        }
        
        if let user_code = UserInfo.getUserInformation()?.data?.customercode  {
            parameters["user_code"] = user_code
        }
        self.cartAddButtonType = .addCart
        //self.showHud()
        self.viewModal.callAddToCartService(withDic: parameters)
    }
    
    @IBAction func checkoutButtonClick(_ sender: Any) {
        
        if (self.senderNameTextField.text?.trim() == "" || self.receiverNameTextField.text?.trim() == "" || self.receiverEmailTextField.text?.trim() == "" || self.receiverNumberTextField.text?.trim() == "") {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Required)
            return
        }
        let Special = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let characterInverted = CharacterSet(charactersIn: Special).inverted
        let phonefilters: String = (self.receiverNumberTextField.text!.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
        
        
        let validation = Utility.commonEmailValidations(emailString: self.receiverEmailTextField.text!)
        if !validation.0 {
            self.showAlertView(title: key.k_Alert, message: validation.1)
            return
        }
        
        
        if (self.receiverNumberTextField.text!.count) != 10 {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Phone)
            return
        }
            
        else if self.receiverNumberTextField.text! == phonefilters {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_PhoneAlpha)
            return
        }
        
        
        
        var parameters = [String: Any]()
        parameters["denomination"] = String(self.viewModal.denominationSelectedValue)
        parameters["item_type"] = "Giftcard"
        
        
        parameters["discount_price"] = String(self.finalDiscountValue)
        
        
        if let code = self.viewModal.giftDetailObject?.code {
            parameters["product_code"] = code
        }
        if let quantity = self.amountLabel.text {
            parameters["quantity"] = quantity
        }
        
        if let message = self.receiverMessageTextField.text {
            parameters["message"] = message
        }
        if let email = self.receiverEmailTextField.text {
            parameters["receiver_email"] = email
        }
        if let name = self.receiverNameTextField.text {
            parameters["receiver_name"] = name
        }
        if let name = self.senderNameTextField.text {
            parameters["sender_name"] = name
        }
        if let no = self.receiverNumberTextField.text {
            parameters["receiver_mobile"] = no
        }
        
        if let user_code = UserInfo.getUserInformation()?.data?.customercode  {
            parameters["user_code"] = user_code
        }
        self.cartAddButtonType = .checkout
        //self.showHud()
        self.viewModal.callAddToCartService(withDic: parameters)
        
        
    }
    
}






//
//  OrderDetailViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 25/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class OrderDetailViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewHC: NSLayoutConstraint!
    
    
    @IBOutlet var orderIdLabel: UILabel!
    
    @IBOutlet var orderDateLabel: UILabel!
    
    //Address View
    
    @IBOutlet weak var shippingAddressView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var paymentStatus: UILabel!
    
    //Price Detail View
    
    @IBOutlet weak var priceDetailView: UIView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var pointsRedeemedLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var totalAmountView: UIView!
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    //MARK: Properties
    fileprivate let viewModal = OrderDetailViewModal()
    
    var orderID : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialInterface()
        self.bindingInterface()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getOrderDetail()
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
        
        self.scrollView.isHidden = true
        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.orderDetail)
        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.tableView.delegate = viewModal
        self.tableView.dataSource = viewModal
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        
        self.shippingAddressView.addShadow()
        self.priceDetailView.addShadow()
        self.totalAmountView.addShadow()
    }
    
    func bindingInterface(){
        
        self.viewModal.showAlert = { (message:String?,serviceType : Services)-> Void in
            
        }
        
        self.viewModal.bindingOrderDetailViewModel = { (data:Any?, serviceType:Services)->Void in
            
           // self.hideHud()
            
            switch serviceType {
            case .orderDetail:
                
                DispatchQueue.main.async {
                    
                    guard let orderObject = data as? OrderDetailModal else {
                        return
                    }
                    
                    self.scrollView.isHidden = false
                    
                    if let orderID = orderObject.data?.code{
                        self.orderIdLabel.text = "Order ID : \(orderID)"
                    }
                    
                    if let orderedDate = orderObject.data?.order_date {
                        let date = Utility.UTCToLocal(date:orderedDate , fromFormat: DateFormat.f_date.rawValue, toFormat: DateFormat.longlongStyle.rawValue)
                        self.orderDateLabel.text = "Ordered on \(date)"
                    }
                    
                    if let name = orderObject.data?.shipping_address?.firstname , let lastName =  orderObject.data?.shipping_address?.lastname {
                        self.nameLabel.text = name + " " + lastName
                    }
                    
                    let fullAddress =  "\(String(describing: orderObject.data?.shipping_address?.address_line1 ?? "")), \(String(describing: orderObject.data?.shipping_address?.address_line2 ?? "")), \(String(describing: orderObject.data?.shipping_address?.city ?? "")), \(String(describing: orderObject.data?.shipping_address?.state ?? "")) , \(String(describing: orderObject.data?.shipping_address?.zip ?? ""))"
                    self.addressLabel.text = fullAddress
                    
                    
                    if let razorPayId = orderObject.data?.razorpay_payment_id , razorPayId == "" {
                        self.paymentStatus.text = "Payment Mode : Points"
                    }else{
                        self.paymentStatus.text = "Payment Mode : Cash"
                    }
                    
                    if let pointsRedeemed = orderObject.data?.total_points_redeemed {
                        
                        self.pointsRedeemedLabel.text = "\(pointsRedeemed)".toRupeeQuotation()
                        
                    }else{
                        self.pointsRedeemedLabel.text = "0".toRupeeQuotation()
                    }
                    
                    
                    if let itemList = orderObject.data?.item_list {
                        let subTotal = itemList.reduce(0) { (result, item) -> Int in
                            return  result + (item.discount_price ?? 0)
                        }
                        self.subTotalLabel.text = String(subTotal).toRupeeQuotation()
                        
                    }
                    
                    
                    self.totalLabel.text = "\(orderObject.data?.total_payment ?? 0)".toRupeeQuotation()
                    self.totalAmountLabel.text = "\(orderObject.data?.total_payment ?? 0)".toRupeeQuotation()
                    
                    if let novasTransactionId = orderObject.data?.novus_transaction_id , novasTransactionId == "" {
                        
                    }
                    
                    
                    
                    self.tableView.reloadData()
                    self.tableViewHC.constant = CGFloat(self.viewModal.itemListArray.count  * OrderDetailTableViewCell.cellHeight) + 45.0
                }
                
                break
                
            default:
                break
            }
            
        }
        
    }
    
    func getOrderDetail(){
        if let code = orderID{
            //self.showHud()
            self.viewModal.callOrderDetailAPI(code: code) }
    }
    
}




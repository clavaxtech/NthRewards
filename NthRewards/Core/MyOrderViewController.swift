//
//  MyOrderViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 25/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var emptyOrderView: UIView!
    
    //Properties
    fileprivate let viewModal = MyOrderViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialInterface()
        
        //Calling Api.......
        //self.showHud()
        self.viewModal.callOrdersAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
        //self.emptyOrderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emptyOrderView)
        //        NSLayoutConstraint.activate([
        //
        //            emptyOrderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
        //            emptyOrderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        //            emptyOrderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        //            emptyOrderView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        //        ])
        self.emptyOrderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        // self.emptyOrderView.backgroundColor = UIColor.red
        
        self.view.bringSubviewToFront(self.tableView)
        
        
        
//        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.myOrders)
//        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.tableView.delegate = viewModal
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        self.tableView.dataSource = viewModal
        
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "ERROR API IN ")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
        }
        
        self.viewModal.openDetailViewController = { (code : String)->Void in
            
//            let orderDetailVC  : OrderDetailViewController = MultipleStoryBoards.kDashboard.instantiateViewController(withIdentifier: VCIdentifire.orderDetailViewController.rawValue) as! OrderDetailViewController
//            orderDetailVC.orderID  = code
//            self.navigationController?.pushViewController(orderDetailVC, animated: true)
            
        }
        
        self.viewModal.bindingMyOrderViewModel = {(data:Any?, serviceType : Services) in
            //self.hideHud()
            switch serviceType {
            case .orders:
                
                Utility.printLog(messge: "SUCCESSFULL API IN \(serviceType.rawValue)")
                
                DispatchQueue.main.async {
                    if self.viewModal.ordersArrayObject.count > 0{
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }else{
                        self.tableView.isHidden = true
                    }
                }
                break
            default:
                break
            }
            
        }
    }
    
    
    @IBAction func backToHomeBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

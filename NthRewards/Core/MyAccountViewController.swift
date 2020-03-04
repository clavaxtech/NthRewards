//
//  MyAccountViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Properties
    fileprivate let viewModal = MyAccountViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialInterface()
        
        self.bindingViewModal()
        
        // self.showHud()
        self.viewModal.getCustomerInfo()
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
        
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.myAccount)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.collectionView.delegate = viewModal
        self.collectionView.dataSource = viewModal
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = layout
        
    }
    
    
    func bindingViewModal(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "ERROR API IN ")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
        }
        
        self.viewModal.bindingMyAccountViewModel = {(data:Any?, serviceType : Services) in
            //self.hideHud()
            switch serviceType {
            case .getCustomer:
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                break
            default:
                break
            }
            
        }
        
    }
    
}

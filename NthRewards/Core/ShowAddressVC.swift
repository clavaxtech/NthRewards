//
//  ShowAddressVC.swift
//  DomeNational
//
//  Created by Clavax MAC on 22/07/19.
//  Copyright © 2019 Clavax MAC. All rights reserved.
//

import UIKit

class ShowAddressVC: UIViewController {

    
    
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewAddressBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionAddress: UICollectionView!
    
    //MARK: - Variables
    var sectionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    //MARK: - Variable
    var arrOfAddress = [Int]()
    var addressHandler:((Bool, String, String, String, String, String) -> ())?
   
    var providerId = String()
    var isComingFromDetail = false
    var addressId = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewBG.isHidden = true
        // Do any additional setup after loading the view.
        view.isOpaque = false
        self.definesPresentationContext = true
        view.backgroundColor = UIColor.clear
        
       
       // self.updateConstantsWithAnimation()
    }
    
  

    
    
    
}

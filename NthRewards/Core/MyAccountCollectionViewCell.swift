//
//  MyAccountCollectionViewCell.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class MyAccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var info0Label: UILabel!
    
    @IBOutlet weak var info1Label: UILabel!
    
    
    @IBOutlet weak var info2Label: UILabel!
    
  
    
    static var identifier : String{
        return String(describing: MyAccountCollectionViewCell.self)
    }
    
    
}

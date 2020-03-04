//
//  GiftCardCollectionViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 26/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class GiftCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    
    private var shadowLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        
        
        //        containerView.layer.shadowColor = UIColor.shadowBase.cgColor
        //        containerView.layer.shadowOffset = .zero
        //        containerView.layer.shadowRadius = 4.0
        //        containerView.layer.shadowOpacity = 0.1
        //        containerView.layer.masksToBounds = false
        //        //containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        //        containerView.layer.shouldRasterize = true
        
        self.containerView.addShadow()
        
        
    }
    
    
    override func prepareForReuse() {
        logoImageView.image = nil
    }
    

}

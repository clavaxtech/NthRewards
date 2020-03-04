//
//  TrendingProductCollectionViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 26/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class TrendingProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var baseView: UIView!
    
    @IBOutlet var pointsLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var productImage: UIImageView!
    
    
    override func prepareForReuse() {
        self.descriptionLabel.text = ""
        self.priceLabel.text = ""
        self.pointsLabel.text = ""
        self.productImage.image = nil
    }
    
    override func awakeFromNib() {
        
    }
    
//    func startShimmer(){
//        ABLoader().startSmartShining(pointsLabel)
//        ABLoader().startSmartShining(priceLabel)
//        ABLoader().startSmartShining(descriptionLabel)
//        ABLoader().startSmartShining(productImage)
//    }
//    func stopShimmer(){
//        ABLoader().stopSmartShining(pointsLabel)
//        ABLoader().stopSmartShining(priceLabel)
//        ABLoader().stopSmartShining(descriptionLabel)
//        ABLoader().stopSmartShining(productImage)
//    }
}

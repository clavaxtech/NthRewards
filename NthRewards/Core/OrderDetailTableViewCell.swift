//
//  OrderDetailTableViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 27/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

class OrderDetailTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var itemNameLabel: UILabel!
    
    @IBOutlet var itemQuantityLabel: UILabel!
    
    @IBOutlet var totalAmountLabel: UILabel!
    
    @IBOutlet var pointsLabel: UILabel!
    
    
    static var cellHeight : Int {
        return 100
    }
    
    static var identifier : String {
        return String(describing:OrderDetailTableViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.addShadow()
    }
    
    var orderObject : ItemListProduct?{
        didSet{
            
            Utility.printLog(messge: orderObject?.image ?? "No Image")
            self.itemImageView.sd_setImage(with: URL(string: orderObject?.image ?? ""), placeholderImage:  UIImage(named: "default"), options: SDWebImageOptions(rawValue: 0)) { (image, error, cacheType, url) in
                
            }
            self.itemNameLabel.text = orderObject?.title ?? ""
            self.itemQuantityLabel.text = "Quantity: \(orderObject?.quantity ?? "")"
            
            if let denomination = orderObject?.denomination {
                self.totalAmountLabel.text = "Rs \(denomination)"
                
                //self.pointsLabel.text = "\(denomination.points) Pts"
            }else{
                self.totalAmountLabel.text = ""
                self.pointsLabel.text = "0 Pts"
            }
            
            if let denomination = orderObject?.denomination {
                if let quantity = Int(orderObject?.quantity ?? "0"){
                    let totalPoints = (denomination * quantity).points
                    self.pointsLabel.text = "\(totalPoints) Pts"
                }
                
            }else{
                self.pointsLabel.text = "0 Pts"
            }
            
            
            
            
            
            
        }
    }
    
}

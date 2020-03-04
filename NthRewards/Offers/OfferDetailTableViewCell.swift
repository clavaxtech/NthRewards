//
//  OfferDetailTableViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 31/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class OfferDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet var baseView: UIView!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.baseView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

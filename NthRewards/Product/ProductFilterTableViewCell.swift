//
//  ProductFilterTableViewCell.swift
//  nth Rewards
//
//  Created by akshay on 11/18/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

protocol ProductFilterTableViewCellDelegate {
    func onCheckBoxClicked(atIndexPath : IndexPath , isSelected : Bool)
}

class ProductFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkBox: UIButton!
    
    var indexPath : IndexPath!
    var delegate : ProductFilterTableViewCellDelegate?
    
    static var identifier : String{
        return String(describing:ProductFilterTableViewCell.classForCoder())
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkBoxBtnClick(_ sender: Any) {
        self.checkBox.isSelected = !self.checkBox.isSelected
        delegate?.onCheckBoxClicked(atIndexPath: indexPath ?? IndexPath(row: -1, section: -1), isSelected: self.checkBox.isSelected)
    }
}

//
//  MyOrderTableViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 25/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit


protocol MyOrderTableViewCellDelegate {
    func onDidViewMoreAt(Id  : String?)
}

class MyOrderTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var orderStatusLabel: UILabel!
    
    @IBOutlet var orderDateLabel: UILabel!
    
    @IBOutlet var orderIDLabel: UILabel!
    
    @IBOutlet var viewMoreButton: UIButton!
    
    @IBOutlet var totalAmountLabel: UILabel!
    
    
    //Properties
    var delegate : MyOrderTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.addShadow()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static var identifier : String {
        return String(describing:MyOrderTableViewCell.self)
    }
    
    
    //MARK: IBOutlets
    
    @IBAction func viewMoreBuutonClick(_ sender: Any) {
        delegate?.onDidViewMoreAt(Id: orderObject?.code)
    }
    
    
    var orderObject : MyOrderModalData? {
        didSet{
            
            self.orderIDLabel.text = "Order ID : \(orderObject?.code ?? "")"
            
            if let status = orderObject?.order_status {
                if status == 1{
                    self.orderStatusLabel.text = "Order Status : SUCCESS"
                }else{
                    self.orderStatusLabel.text = "Order Status : FAIL"
                }
                
            }
            
            if let orderedDate = orderObject?.order_date {
                let date = Utility.UTCToLocal(date:orderedDate , fromFormat: DateFormat.f_date.rawValue, toFormat: DateFormat.longlongStyle.rawValue)
                self.orderDateLabel.text = "Ordered on \(date)"
            }
            
            if let totalPayment = orderObject?.total_payment{
                self.totalAmountLabel.text = "Rs \(totalPayment)"
            }
            
        }
    }
    
}

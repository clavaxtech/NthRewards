//
//  ActivityLogTableViewCell.swift
//  nth Rewards
//
//  Created by akshay on 11/6/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class ActivityLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    static var identifier : String {
        return String(describing:ActivityLogTableViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public var log : Logs?{
        didSet{
            self.descriptionLabel.text = log?.description ?? ""
            
            if let validity = self.log?.activityDateTime {
                
                self.timeLabel.text = Utility.UTCToLocal(date:validity , fromFormat: DateFormat.utc2.rawValue, toFormat: DateFormat.longlongStyle.rawValue)
            }
        }
    }
    
}

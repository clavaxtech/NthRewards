//
//  CartItemTableViewCell.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 11/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SDWebImage


protocol CartItemTableViewCellDelegate {
    func deleteItemAt(indexPath : IndexPath)
    func updateQuantityAt(indexPath : IndexPath, quantity:String)
}

class CartItemTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var itemTitle: UILabel!
    @IBOutlet var itemDescription: UILabel!
    
    @IBOutlet var quantityLabel: UILabel!
    
    
    @IBOutlet var amountLabel: UILabel!
    
    @IBOutlet var discountedAmountLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    
    //MARK: Properties
    var delegate : CartItemTableViewCellDelegate?
    var indexPath : IndexPath?
    var tempProductObj  : ProductList? = nil
    
    
    private var maximumQuantityVlue : Int = 1
    
    
    static var identifier : String {
        return String(describing: CartItemTableViewCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func incrementQuantityButtonClick(_ sender: Any) {
        
        guard let item_type = self.productObj?.item_type, item_type != "Giftcard" else {
            return
        }
        
        if self.maximumQuantityVlue < 10 {
            self.maximumQuantityVlue += 1
        }
        self.quantityLabel.text = String(self.maximumQuantityVlue)
        if let indexpath = indexPath {
            delegate?.updateQuantityAt(indexPath: indexpath, quantity: self.quantityLabel?.text ?? "1")
        }
    }
    
    @IBAction func decrementQuantityButtonClick(_ sender: Any) {
        
        guard let item_type = self.productObj?.item_type, item_type != "Giftcard" else {
            return
        }
        
        if self.maximumQuantityVlue > 1{
            self.maximumQuantityVlue -= 1
        }
        
        self.quantityLabel.text = String(self.maximumQuantityVlue)
        if let indexpath = indexPath {
            delegate?.updateQuantityAt(indexPath: indexpath, quantity: self.quantityLabel?.text ?? "1")
        }
    }
    
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        if let indexpath = indexPath {
            delegate?.deleteItemAt(indexPath: indexpath)
        }
        
    }
    
    
    var productObj : ProductList? {
        
        didSet{
            if self.tempProductObj == nil{
                self.tempProductObj = productObj
            }
            
            
            if let maxValue = productObj?.quantity{
                self.maximumQuantityVlue = Int(maxValue) ?? -1
            }
            
            self.itemImageView.sd_setImage(with: URL(string: productObj?.image ?? (tempProductObj?.image ?? "")), placeholderImage: UIImage(named: "tutorial2"), options: SDWebImageOptions(rawValue: 0)) { (image:UIImage?, error :Error?, cache, url) in
            }
            
            if let title = productObj?.name{
                self.itemTitle.text = title
            }else if let title = tempProductObj?.name{
                self.itemTitle.text = title
            }else{
                self.itemTitle.text = ""
            }
            
            
            Utility.printLog(messge: "Quantity ---- \(productObj?.quantity ?? "-100")")
            
            self.quantityLabel.text = productObj?.quantity ?? "1"
            
            let denominationValue = Int(productObj?.denomination ?? "0") ?? 0
            let discountPrice = Int(productObj?.discount_price ?? "0") ?? 0
            
            Utility.printLog(messge: "denominationValue ---- \(denominationValue)")
            Utility.printLog(messge: "discountPrice ---- \(discountPrice)")
            
            if denominationValue > 0 &&  discountPrice > 0 {
                
                
                Utility.printLog(messge: " ----- DICOUNT AVAILABLE ----- ")
                self.pointsLabel.text = "Pts: \(discountPrice.points)"
                
                if denominationValue == discountPrice {
                    
                    self.updateAmountLabel(amount: denominationValue, isDisountAvailable: false)
                    self.discountedAmountLabel.text = ""
                    
                }else{
                    
                    let finalActualValue = denominationValue * Int(productObj?.quantity ?? "1")!
                    
                    self.updateAmountLabel(amount: finalActualValue, isDisountAvailable: true)
                    
                    
                    self.discountedAmountLabel.text = String(discountPrice * Int(productObj?.quantity ?? "1")!)
                    
                    
                }
                
            }else{
                
                Utility.printLog(messge: " ----- DICOUNT NOT AVAILABLE ----- ")
                
                self.updateAmountLabel(amount: denominationValue, isDisountAvailable: false)
                self.discountedAmountLabel.text = ""
                
                self.pointsLabel.text = "Pts: \(denominationValue.points)"
            }
            
        }
    }
    
    var updatedProductObj : ProductList? {
        didSet{
            if let maxValue = updatedProductObj?.quantity{
                self.maximumQuantityVlue = Int(maxValue) ?? -1
            }
        }
    }
    
    
    
    private func updateAmountLabel(amount : Int, isDisountAvailable : Bool){
        
        if isDisountAvailable {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(amount))
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            
            self.amountLabel.attributedText = attributeString
            
        }else{
            self.amountLabel.text = String(amount)
        }
    }
    
}

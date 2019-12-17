//
//  KExtentions.swift
//  MakePlus
//
//  Created by Deepak Tomar on 15/03/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation
import UIKit


extension NSNotification.Name {
    static let splashPageControllerMove = Notification.Name("splashPageControllerMove")
    static let didChangeVCFromeLeftMenu = Notification.Name("didChangeVCFromeLeftMenu")
    
}


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970)
    }
    
}


extension Int {
    var points : Int {
        return self * 4
    }
    
    var amount : Int{
        return self/4
    }
    
    var paise : Int{
        return self * 100
    }
}

extension UIColor{
    
    //Tutorial
    static let pageControl_border = Utility.hexStringToUIColor(hex:"#707070")
    static let pageControl_fill = Utility.hexStringToUIColor(hex:"#FD771A")
    
    //OTPViewController
    static let otpTextcolor = Utility.hexStringToUIColor(hex:"#0E1C2A")
    static let otpDefaultBorderColor = Utility.hexStringToUIColor(hex:"#D5D5D5")
    static let otpEnteredBorderColor = Utility.hexStringToUIColor(hex:"#FD771A")
    
    //LatestOffer Home color gradient
    static let gradient1 = (startColor : Utility.hexStringToUIColor(hex:"#F4E5F3"), endColor : Utility.hexStringToUIColor(hex:"#E6DCF4"))
    static let gradient2 = (startColor : Utility.hexStringToUIColor(hex:"#E0F4FF"), endColor : Utility.hexStringToUIColor(hex:"#C7E9FF"))
    static let gradient3 = (startColor : Utility.hexStringToUIColor(hex:"#F9EEF2"), endColor : Utility.hexStringToUIColor(hex:"#FEDADF"))
    static let gradient4 = (startColor : Utility.hexStringToUIColor(hex:"#E9E5FF"), endColor : Utility.hexStringToUIColor(hex:"#DBD5FE"))
    
    static let shadowBase = Utility.hexStringToUIColor(hex: "#0A20AE")
    
    static let dottedBorderColor = Utility.hexStringToUIColor(hex: "#48A148")
    
    
    
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
}

extension UIViewController {
    
    
//    func showHud() {
//        DispatchQueue.main.async {
//
//            if !SVProgressHUD.isVisible() {
//                SVProgressHUD.setBackgroundLayerColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
//                SVProgressHUD.setMaximumDismissTimeInterval(10.0)
//
//                UIApplication.shared.beginIgnoringInteractionEvents()
//                SVProgressHUD.show()
//            }else{
//                self.hideHud()
//                self.view.isUserInteractionEnabled = true
//                SVProgressHUD.dismiss()
//            }
//
//        }
//    }
    
    
//    func hideHud() {
//        DispatchQueue.main.async {
//            
//            UIApplication.shared.endIgnoringInteractionEvents()
//            SVProgressHUD.dismiss()
//            
//        }
//    }
    
    func showAlertView(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: key.k_Ok, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
}


extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
    
    
}


extension UINavigationController
{
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


extension  UITextField {
    
    func setPlaceholdercolor (text:String,color:UIColor, font : UIFont){
        let attributes = [
            NSAttributedString.Key.font : font
        ]
        
        self.attributedPlaceholder =  NSAttributedString(string: text,
                                                         attributes: attributes)
    }
}

extension UIButton {
    
    override var cornerRadiusView: CGFloat {
        get{
            return layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
}




extension UILabel {
    
    func circleLable(){
        self.layer.cornerRadius = self.frame.width/2
    }
}

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func localization() -> String {
        return  NSLocalizedString(self, comment: "")
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func replace_fromStart(str:String , endIndex:Int , With:String) -> String {
        var strReplaced = str ;
        let start = str.startIndex;
        let end = str.index(str.startIndex, offsetBy: endIndex);
        strReplaced = str.replacingCharacters(in: start..<end, with: With) ;
        return strReplaced;
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    func toRupeeQuotation() -> String{
        return "Rs \(self)"
    }
    
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension UIView {
    
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    var safeAreaLeft : CGFloat {
        
        get {
            
            if #available(iOS 11.0, *) {
                return self.safeAreaInsets.left
            }
            else {
                return 0
            }
        }
        
    }
    
    var safeAreaRight : CGFloat {
        
        get {
            
            if #available(iOS 11.0, *) {
                return self.safeAreaInsets.right
            }
            else {
                return 0
            }
        }
        
    }
    
    func addDottedMask(){
        
        _ = layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        
        let dottedMaskLayer = CAShapeLayer()
        dottedMaskLayer.name = "DashedTopLine"
        dottedMaskLayer.strokeColor = UIColor.dottedBorderColor.cgColor
        dottedMaskLayer.lineDashPattern = [2, 2]
        dottedMaskLayer.frame = bounds
        dottedMaskLayer.fillColor = nil
        dottedMaskLayer.path = UIBezierPath(rect: bounds).cgPath
        layer.addSublayer(dottedMaskLayer)
        
    }
    
    func addShadow(){
        self.layer.shadowColor = UIColor.shadowBase.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3.0  // 4.0
        self.layer.shadowOpacity = 0.1
        self.layer.masksToBounds = false
        //containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        //self.layer.shouldRasterize = true
    }
    
    func addBlurEffectTo(){
        if !UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundColor = .black
        }
    }
}


extension UIScrollView {
    
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
}

import UIKit
import Foundation

class Utility  {
    
    
    class func showAlertView(title: String, message: String, in vc: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: key.k_Ok, style: UIAlertAction.Style.default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    class func alertViewWithOKPopupAction(title: String, message: String, in vc: UIViewController) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: key.k_Ok, style: UIAlertAction.Style.default, handler: { (_) in
            vc.navigationController?.popViewController(animated: true)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func gradient(frame:CGRect, colorTuple : (UIColor,UIColor)) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.colors = [
            colorTuple.0.cgColor,colorTuple.1.cgColor]
        return layer
    }
    
    
    class func saveUserDefault(value : Any? , key : String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: key)
        userDefaults.synchronize()
    }
    
    class func userDefault(key : String)-> Any? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key)
    }
    
    
    class  func findStoryBoard(storyboardName : String) -> UIStoryboard {
        
        let storyBoard  = UIStoryboard(name : storyboardName, bundle : Bundle.main)
        return storyBoard
        
    }
    
    class func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
    
    class func  bezierShadowAtTop(view:UIView){
        
        let shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowPath = shadowPath.cgPath
    }
    
    
    
    
    class func animateCart(lockView:UIView){
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: lockView.center.x-5.0, y: lockView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: lockView.center.x+5.0, y: lockView.center.y))
        lockView.layer.add(animation, forKey: "position")
    }
    
    
    class func updateMasterCart(option : MathUtility){
        
        guard let value = userDefault(key: keyUD.k_cartValue) as? Int else {
            saveUserDefault(value: 0 , key: keyUD.k_cartValue)
            updateMasterCart(option: .increment)
            return
        }
        
        switch option {
        case .increment:
            saveUserDefault(value: value+1 , key: keyUD.k_cartValue)
            break
        case .subtract:
            saveUserDefault(value: value-1 , key: keyUD.k_cartValue)
            break
            
        case .clear:
            saveUserDefault(value: 0 , key: keyUD.k_cartValue)
            break
        }
        
    }
    
    
    class func printLog(messge : Any...){
        
        #if DEBUG
        print(messge)
        #endif
        
    }
    
    class func setPlaceholder(obj: [UITextField], text: [String]) {
        for (index, textfields) in obj.enumerated() {
            textfields.placeholder = NSLocalizedString(text[index], comment: "")
        }
    }
    
    class func changeAlignment(lb: UILabel, alignment: NSTextAlignment) {
        switch alignment {
        case .left:
            lb.textAlignment = .left
            break
        case .right:
            lb.textAlignment = .right
            break
        default:
            break
        }
    }
    
    class func newVc(controllerIdentifier: String, storyBoard: UIStoryboard) -> UIViewController {
        return storyBoard.instantiateViewController(withIdentifier: controllerIdentifier)
    }
    
    
    class func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        if let date = dt {
            return dateFormatter.string(from: date)}
        else{
            return ""
        }
        
    }
    
    class func commonEmailValidations(emailString: String) -> (Bool, String) {
        
        if emailString.trim().count <= 0 {
            return (false, key.k_Msg_InvalidEmail)
        }
        else if emailString.isValidEmail() == false {
            return(false, key.k_Msg_InvalidEmail)
        }
        return (true, "")
        
    }
    
    
}


class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

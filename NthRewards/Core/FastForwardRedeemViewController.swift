//
//  FastForwardRedeemViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 14/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol FastForwardRedeemViewControllerDelegate {
    
    func pointToBeRedeem(points:String)
    
}

class FastForwardRedeemViewController: UIViewController {
    
    @IBOutlet var baseView: UIView!
    
    @IBOutlet var baseViewBC: NSLayoutConstraint!
    @IBOutlet var availablePointsLabel: UILabel!
    
    @IBOutlet var pointsToBeRedeemTextField: SkyFloatingLabelTextField!
    
    
    //MARK: Properties
    var delegate : FastForwardRedeemViewControllerDelegate?
    
    var maxPoints : Int = 0
    var availabelPoints = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.registerKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func initialInit(){
        
        self.view.addBlurEffectTo()
        self.baseView.addShadow()
        self.view.bringSubviewToFront(self.baseView)
        self.baseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stopEditing)))
        
        self.pointsToBeRedeemTextField.delegate = self
        //        self.pointsToBeRedeemTextField.isSelected = true
        //        self.pointsToBeRedeemTextField.isUserInteractionEnabled = false
        
        
        guard let points = UserProfileInfo.getUserProfile()?.data?.wallet?.point  else {
            return
        }
        
        self.availabelPoints = Int(points)
        
        DispatchQueue.main.async {
            self.availablePointsLabel.text = "Total Points : \(points)"
            self.pointsToBeRedeemTextField.text = String(self.maxPoints)
        }
        
    }
    
    
    func registerKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
        let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        
        
        
        self.baseViewBC.constant = (keyboardSize!.height - 50)
        
        
        UIView.animate(withDuration: TimeInterval(truncating: duration), delay: 0, options: [UIView.AnimationOptions(rawValue: UInt(truncating: curve!))], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.baseViewBC.constant = 0
    }
    
    @objc func stopEditing() {
        self.view.endEditing(true)
        self.baseViewBC.constant = 0
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    //MARK: CLICK EVENTS
    @IBAction func dissmissButtonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func redeemNowButtonClick(_ sender: Any) {
        
        
        if let points = self.pointsToBeRedeemTextField.text {
            
            if let pointsInt = Int(points){
                
                if pointsInt > availabelPoints {
                    self.showAlertView(title: key.k_Alert, message: key.k_Msg_PointsCannotBeGreater)
                    
                    return
                }
                
                
            }
            
            self.delegate?.pointToBeRedeem(points: points)
            self.dismiss(animated: true, completion: nil)
        }
        
        
        
    }
    
}

extension FastForwardRedeemViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

//
//  RegisterViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 14/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: BaseViewController {
    
    //testing
    @IBOutlet var noTextField: SkyFloatingLabelTextField!
    @IBOutlet var createPasswordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var termsButton: UIButton!
    
    @IBOutlet var eyeButton: UIButton!
    
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    //MARKS: Properties
    
    fileprivate var termsAndCondition = false
    fileprivate let onBoardViewModel = OnboardingFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onDismissKeyboard)))
        
        
        self.onBoardViewModel.showAlert = { (alertMessage : String) in
            Utility.printLog(messge: "RegisterViewController error! --------- %@",alertMessage)
            Utility.showAlertView(title: key.k_Alert, message: alertMessage, in: self)
           // self.hideHud()
            
        }
        
        onBoardViewModel.updateUI = { (data:Any?, serviceType:Services)  in
            Utility.printLog(messge: "RegisterViewController sucess! --------- %@",data as Any)
            //self.hideHud()
            if let userinfo = data as? UserInfo {
                
                if let _ = userinfo.data{
                    if (userinfo.totalCount ?? 0) > 0{
                        
                       
                        
                    }else{
                        
                    }
                    
                }
                
            }
            
        }
        
        self.initialInit()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initialInit(){
        self.noTextField.delegate = self
        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.register)
        self.enableLeftBarButton(with: ControllerDismissType.backButton, isBackButtonHidden: false, controller: self)
        
        self.noTextField.titleFormatter = { $0 }
        self.createPasswordTextField.titleFormatter = { $0 }
    }
    
    
    private func hitRegisterationApi(){
        let result = onBoardViewModel.validation(tField: [self.noTextField.text!, self.createPasswordTextField.text!], screenType: .signUp)
        
        switch result {
        case .invalid(let alert) :
            
            Utility.showAlertView(title: key.k_Alert, message: alert, in: self)
            
        case .valid:
            
            
            if !termsAndCondition {
                Utility.showAlertView(title: key.k_Alert, message: key.k_Msg_Terms_Condtion , in: self)
                return
            }
            
           // self.showHud()
            let parameters = [ "mobile": self.noTextField.text!, "password": self.createPasswordTextField.text!]
            self.onBoardViewModel.callApi(service: .registeration, param: parameters)
            
            break
        }
    }
    
    
    
    
    @IBAction func loginButtonClick(_ sender: Any) {
        
        self.onBackButtonClick()
    }
    
    @IBAction func termsButtonClick(_ sender: Any) {
        
        let selected = !termsButton.isSelected
        self.termsButton.isSelected = selected
        
        self.termsAndCondition = selected
    }
    
    
    @IBAction func eyeButtonClick(_ sender: Any) {
        
        let selected = !eyeButton.isSelected
        self.eyeButton.isSelected = selected
        
        self.createPasswordTextField.isSecureTextEntry = !selected
        
        
    }
    
    
    @IBAction func signupButtonClick(_ sender: Any) {
        self.hitRegisterationApi()
        
        
    }
    
    @IBAction func facebookButtonClick(_ sender: Any) {
    }
    
    @IBAction func googleButtonClick(_ sender: Any) {
    }
    
    
    @IBAction func termsAndConditionBtnClick(_ sender: Any) {
        
       
    }
    
    @IBAction func privacyPolicyBtnClick(_ sender: Any) {
        
       
    }
    
    
    @objc func onDismissKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.noTextField {
            let aSet = NSCharacterSet(charactersIn:"0123456789+").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
        
        return true
    }
}

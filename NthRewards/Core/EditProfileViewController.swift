//
//  EditProfileViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DatePickerDialog

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var mobileNumberTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var dobTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    
    fileprivate let viewModal = EditProfileViewModal()
    
    private var isEditingEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.initialInterface()
        
        self.bindingViewModal()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       // self.showHud()
        self.viewModal.getCustomerInfo()
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
    
    func initialInterface(){
        
        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.editProfile)
        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.dobTextField.delegate = self
        self.mobileNumberTextField.isUserInteractionEnabled = false
        self.scrollView.keyboardDismissMode = .interactive;
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
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset = .zero
        self.scrollView.scrollIndicatorInsets = .zero
    }
    
    func bindingViewModal(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            //self.hideHud()
            Utility.printLog(messge: "ERROR API IN ")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
        }
        
        self.viewModal.bindingEditProfileViewModal = {(data:Any?, serviceType : Services) in
           // self.hideHud()
            switch serviceType {
            case .getCustomer:
                
                DispatchQueue.main.async {
                    guard let userInfo  = data as? UserProfileInfo else {return}
                    if let mobileNumber = userInfo.data?.mobile{
                        self.mobileNumberTextField.text = mobileNumber
                    }
                    if let firstName = userInfo.data?.name{
                        self.firstNameTextField.text = firstName
                    }
                    
                    if let lastName = userInfo.data?.lastName{
                        self.lastNameTextField.text = lastName
                    }
                    
                    
                    if let email = userInfo.data?.email{
                        self.emailTextField.text = email
                    }
                    
                    
                    if let dob = userInfo.data?.dob{
                        self.dobTextField.text = dob
                    }
                    
                    if let gender = userInfo.data?.gender{
                        if gender == "0" {
                            self.maleButton.isSelected = false
                            self.femaleButton.isSelected = true
                        }else{
                            self.femaleButton.isSelected = false
                            self.maleButton.isSelected = true
                        }
                    }
                    
                }
            case .customer:
                
                DispatchQueue.main.async {
                    if let message = (data as? UserProfileInfo)?.message{
                        
                        let alert = UIAlertController(title: key.k_Alert, message: message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            default:
                break
            }
            
        }
        
    }
    
    func validatePassword2(Input:String) -> Bool {
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: Input)
    }
    
    
    @IBAction func changePasswordBtnClick(_ sender: Any) {
        
        if (self.mobileNumberTextField.text?.trim() == "" || self.passwordTextField.text?.trim() == "") {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Required)
            return
        }
        let Special = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let characterInverted = CharacterSet(charactersIn: Special).inverted
        let phonefilters: String = (self.mobileNumberTextField.text!.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
        
        
        if self.mobileNumberTextField.text! == phonefilters {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_PhoneAlpha)
            return
        }
        
        if (self.mobileNumberTextField.text!.count) != 10 {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Phone)
            return
        }
        
        if (self.passwordTextField.text!.count) < 8 || (passwordTextField.text!.count) > 20 || self.validatePassword2(Input: passwordTextField.text ?? "") == false {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Length)
            return
        }
        
        var params = [String:Any]()
        params["password"] = self.passwordTextField.text!
        params["mobile"] = self.mobileNumberTextField.text!
        
        //self.showHud()
        self.viewModal.callEditCustomerApi(params: params)
        
    }
    
    @IBAction func updateBtnClick(_ sender: Any) {
        
        if (self.firstNameTextField.text?.trim() == "" || self.lastNameTextField.text?.trim() == "" || self.emailTextField.text?.trim() == "" || self.dobTextField.text?.trim() == ""  ||   self.mobileNumberTextField.text?.trim() == "") {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Required)
            return
        }
        
        let validation = Utility.commonEmailValidations(emailString: self.emailTextField.text!)
        if !validation.0 {
            self.showAlertView(title: key.k_Alert, message: validation.1)
            return
        }
        
        let Special = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let characterInverted = CharacterSet(charactersIn: Special).inverted
        let phonefilters: String = (self.mobileNumberTextField.text!.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
        
        
        if self.mobileNumberTextField.text! == phonefilters {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_PhoneAlpha)
            return
        }
        
        if (self.mobileNumberTextField.text!.count) != 10 {
            self.showAlertView(title: key.k_Alert, message: key.k_Msg_Phone)
            return
        }
        
        
        var params = [String:Any]()
        params["name"] = self.firstNameTextField.text!
        params["lastName"] = self.lastNameTextField.text!
        params["mobile"] = self.mobileNumberTextField.text!
        params["email"] = self.emailTextField.text!
        params["gender"] = self.maleButton.isSelected ? "1" : "0"
        params["dob"] = self.dobTextField.text!
        
        //self.showHud()
        self.viewModal.callEditCustomerApi(params: params)
        
    }
    
    @IBAction func maleButtonClick(_ sender: Any) {
        let isSelected = self.maleButton.isSelected
        self.maleButton.isSelected = !isSelected
        self.femaleButton.isSelected = isSelected
    }
    
    @IBAction func femaleBtnClick(_ sender: Any) {
        
        let isSelected = self.femaleButton.isSelected
        self.femaleButton.isSelected = !isSelected
        self.maleButton.isSelected = isSelected
    }
    
}

extension EditProfileViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == dobTextField{
            DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-YYYY"
                    self.dobTextField.text = formatter.string(from: dt)
                }
            }
        }
    }
    
}

//
//  OnboardingFile.swift
//  Sparehub
//
//  Created by clavax on 18/01/19.
//  Copyright © 2019 clavax. All rights reserved.
//

import Foundation
import UIKit
//import FBSDKLoginKit

let maxLength = 32
var currentString: NSString?
var newString: NSString?

enum Screens {
    case login
    case signUp
    case forget
    case OTP
    case changePaswd
}

enum ValidationState {
    case invalid(String)
    case valid
}

class OnboardingFile {
    
   public var objtextFieldStruct : textFieldStruct!
    
    var trimmedString = String()
    var status: ATType?
    
    //var showAlert : ((_ alertStr : String, _ states: ATType) ->())?
    
    var showAlert : ((_ alertStr : String) ->())?
    var updateUI : ((_ data : Any , _ serviceType : Services) ->())?
    
    let Special = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    private var alertMessage : String? {
        didSet {
            self.showAlert?(alertMessage ?? "")
        }
    }
    
    // MARK: - VALIDATIONS FOR TEXTFIELDS
    func validateTextField(screen: Screens) -> ValidationState {
        
        let characterInverted = CharacterSet(charactersIn: Special).inverted
        
        switch screen {
        case .login:
            let phonefilters: String = (objtextFieldStruct.phone.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
            
            //let passValidation = commonPasswordValidations(passwordString: objtextFieldStruct.password)
            
            //            if objtextFieldStruct.email.trim().count <= 0 {
            //                return .invalid(key.k_Msg_Required)
            //            }
            //            else if objtextFieldStruct.email.trim().count < 10 {
            //                return .invalid(key.k_Msg_Email)
            //            }
            
            if (objtextFieldStruct.phone.count) != 10 {
                return .invalid(key.k_Msg_Phone)
            }
                
            else if objtextFieldStruct.phone == phonefilters {
                return .invalid(key.k_Msg_PhoneAlpha)
            }
                
            else if objtextFieldStruct.password.trim().count <= 0 {
                return .invalid(key.k_Msg_Password)
            }
            
            //            else if !passValidation.0 {
            //                return .invalid(passValidation.1)
            //            }
            return .valid
            
        case .signUp:
            
            
            let phonefilters: String = (objtextFieldStruct.phone.components(separatedBy: characterInverted)as NSArray).componentsJoined(by: "")
            
            
            if (objtextFieldStruct.phone.count) != 10 {
                return .invalid(key.k_Msg_Phone)
            }
                
            else if (objtextFieldStruct.phone == "0000000000") {
                return .invalid(key.k_Msg_Phone)
            }
                
            else if objtextFieldStruct.phone == phonefilters {
                return .invalid(key.k_Msg_PhoneAlpha)
            }
                
            else if objtextFieldStruct.password.trim().count <= 0 {
                return .invalid(key.k_Msg_Password)
            }
                
            else if (objtextFieldStruct.password.count) < 8 || (objtextFieldStruct.password.count) > 20 || self.validatePassword2(Input: objtextFieldStruct.password) == false {
                
                return .invalid(key.k_Msg_Length)
            }
            
            
            return .valid
            
        case .forget:
            
            let validation = commonEmailValidations(emailString: objtextFieldStruct.email)
            if !validation.0 {
                return .invalid(validation.1)
            }
            return .valid
        case .OTP:
            if objtextFieldStruct.firstField.trim().count <= 0 || objtextFieldStruct.secondField.trim().count <= 0 || objtextFieldStruct.thirdField.trim().count <= 0 || objtextFieldStruct.fourthField.trim().count <= 0  {
                
                return .invalid(key.k_Msg_Required)
            }
            return .valid
            
        case .changePaswd:
            
            if objtextFieldStruct.oldPasswd.trim().count <= 0 || objtextFieldStruct.newPasswd.trim().count <= 0 || objtextFieldStruct.retype.trim().count <= 0  {
                
                return .invalid(key.k_Msg_Required)
            }
            else if objtextFieldStruct.newPasswd.trim().count <= 6 || objtextFieldStruct.newPasswd.trim().count >= 20{
                
                return .invalid(key.k_Msg_Length)
            }
            else if objtextFieldStruct.newPasswd != objtextFieldStruct.retype {
                return .invalid(key.k_Msg_Mismatch)
            }
        }
        return .valid
        
    }
    
    func commonEmailValidations(emailString: String) -> (Bool, String) {
        
        if emailString.trim().count <= 0 {
            return (false, key.k_Msg_InvalidEmail)
        }
        else if emailString.isValidEmail() == false || isEmailValidation(testStr: emailString) == false {
            return(false, key.k_Msg_InvalidEmail)
        }
        return (true, "")
        
    }
    
    func isEmailValidation(testStr:String) -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@._")
        if testStr.rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }
        return true
    }
    
    func commonPasswordValidations(passwordString: String) -> (Bool, String) {
        //let Result = self.validatePassword2(Input: passwordString)
        if passwordString.trim().count <= 0 {
            return (false, key.k_Msg_Required)
        }
        //        else if  (objtextFieldStruct.password.count) < 6 || (objtextFieldStruct.password.count) > 20 || Result == false {
        //
        //            return(false, key.k_Msg_Length)
        //
        //        }
        return (true, "")
    }
    
    func validatePassword2(Input:String) -> Bool {
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"        
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return predicate.evaluate(with: Input)
    }
    
    // MARK: - DISPLAY ERROR MESSAGE ON VALIDATIONS
    func validation(tField: [String], screenType: Screens) -> ValidationState {
        switch screenType {
        case .login:
            
            objtextFieldStruct = textFieldStruct(phone: tField[0], password:  tField[1])
            break
            
        case .signUp:
            
            objtextFieldStruct = textFieldStruct(phone: tField[0], password:  tField[1])
            break
            
        case .forget:
            
            objtextFieldStruct = textFieldStruct(email: tField[0])
            break
            
        case .OTP:
            objtextFieldStruct = textFieldStruct(firstField : tField[0], secondField: tField[1], thirdField: tField[2], fourthField: tField[3])
            
            
        case .changePaswd:
            objtextFieldStruct = textFieldStruct(oldPasswd: tField[0], newPasswd: tField[1], retype: tField[2])
        }
        
        return self.validateTextField(screen: screenType)
        
    }
    
    // MARK: - CALL API
    func callApi(service: Services, param: [String: Any]) {
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: param, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!!")
                self.status = ATType.fail
                self.alertMessage = dictData as? String
                break
                
            case .sucess:
                Utility.printLog(messge: "API SUCCESS!!")
                
                if service == .token {
                    self.handleTokenResponse(responseDict: dictData as! [String : Any])
                    
                }else if service == .login {
                    self.handleLoginResponse(responseDict: dictData as! [String : Any] )
                }
                else  if service == .registeration {
                    self.handleSignUpResponse(responseDict: dictData as! [String : Any] )
                }
                else  if service == .otpVerify {
                    self.handleOTPResponse(responseDict: dictData as! [String : Any] )
                }
                else  if service == .resendOtp {
                    self.handleResendOTPResponse(responseDict: dictData as! [String : Any] )
                    
                } else  if service == .getCustomer {
                    self.handleGetCustomerResponse(responseDict: dictData as! [String : Any] )
                }
                
                
                break
                
            }
            
        })
        
    }
    
    func handleTokenResponse(responseDict : [String : Any]){
        
        guard let access_token = responseDict["access_token"] as? String else {return}
        guard let token_type = responseDict["token_type"] as? String else {return}
        
        Utility.saveUserDefault(value: token_type + " \(access_token)", key: keyUD.k_token)
        
        if let expiresIn = responseDict["expires_in"] as? Int64 {
            let currentTimeStamp = Date().toMillis()
            let addValue = currentTimeStamp! + expiresIn
            Utility.saveUserDefault(value: String(addValue), key: keyUD.k_expiryTime)
        }
        
        self.updateUI?(responseDict, .token)
        
        
    }
    
    
    func handleGetCustomerResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(UserProfileInfo.self, from: jsonData)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(objUserInfo), forKey:keyUD.k_UserProfileInfo)
            userDefaults.synchronize()
            
            
            self.updateUI?(objUserInfo, .getCustomer)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
    
    
    //MARK: - Handle Response Method
    func handleSignUpResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(UserInfo.self, from: jsonData)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(objUserInfo), forKey:keyUD.k_UserInfo)
            userDefaults.synchronize()
            
            self.updateUI?(objUserInfo, .registeration)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
    }
    
    
    func handleLoginResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(UserInfo.self, from: jsonData)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(objUserInfo), forKey:keyUD.k_UserInfo)
            userDefaults.synchronize()
            
            self.updateUI?(objUserInfo, .login)
            
            
        }
        catch(let error){
            self.alertMessage = key.k_Msg_SomeThing
            Utility.printLog(messge: "JSON Parsing Error >> \(error)")
        }
        
    }
    
    
    func handleOTPResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(UserInfo.self, from: jsonData)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(try? PropertyListEncoder().encode(objUserInfo), forKey:keyUD.k_UserInfo)
            userDefaults.synchronize()
            
            self.updateUI?(jsonData, .otpVerify)
            
        }
        catch(let error){
            self.alertMessage = key.k_Msg_SomeThing
            Utility.printLog(messge: "JSON Parsing Error >> \(error)")
        }
        
    }
    
    func handleResendOTPResponse(responseDict : [String : Any]){
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(UserInfo.self, from: jsonData)
            
            self.updateUI?(objUserInfo, .resendOtp)
            
        }
        catch(let error){
            self.alertMessage = key.k_Msg_SomeThing
            Utility.printLog(messge: "JSON Parsing Error >> \(error)")
        }
        
    }
    
    
}



//class FacebookSignInManager: NSObject {
//    typealias LoginCompletionBlock = (Dictionary<String, AnyObject>?, NSError?) -> Void
//
//    //MARK:- Public functions
//    class func basicInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {
//
//        //Check internet connection if no internet connection then return
//
//
//        self.getBaicInfoWithCompletionHandler(fromViewController) { (dataDictionary:Dictionary<String, AnyObject>?, error: NSError?) -> Void in
//            onCompletion(dataDictionary, error)
//        }
//    }
//
//    class func logoutFromFacebook() {
//        FBSDKLoginManager().logOut()
//        FBSDKAccessToken.setCurrent(nil)
//        FBSDKProfile.setCurrent(nil)
//    }
//
//    //MARK:- Private functions
//    class fileprivate func getBaicInfoWithCompletionHandler(_ fromViewController:AnyObject, onCompletion: @escaping LoginCompletionBlock) -> Void {
//        let permissionDictionary = [
//            "fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)",
//            //"locale" : "en_US"
//        ]
//        if FBSDKAccessToken.current() != nil {
//            FBSDKGraphRequest(graphPath: "/me", parameters: permissionDictionary)
//                .start(completionHandler:  { (connection, result, error) in
//                    if error == nil {
//                        onCompletion(result as? Dictionary<String, AnyObject>, nil)
//                    } else {
//                        onCompletion(nil, error as NSError?)
//                    }
//                })
//
//        } else {
//            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_photos"], from: fromViewController as? UIViewController, handler: { (result, error) -> Void in
//                if error != nil {
//                    FBSDKLoginManager().logOut()
//                    if let error = error as NSError? {
//                        let errorDetails = [NSLocalizedDescriptionKey : "Processing Error. Please try again!"]
//                        let customError = NSError(domain: "Error!", code: error.code, userInfo: errorDetails)
//                        onCompletion(nil, customError)
//                    } else {
//                        onCompletion(nil, error as NSError?)
//                    }
//
//                } else if (result?.isCancelled)! {
//                    FBSDKLoginManager().logOut()
//                    let errorDetails = [NSLocalizedDescriptionKey : "Request cancelled!"]
//                    let customError = NSError(domain: "Request cancelled!", code: 1001, userInfo: errorDetails)
//                    onCompletion(nil, customError)
//                } else {
//                    let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: permissionDictionary)
//                    let _ = pictureRequest?.start(completionHandler: {
//                        (connection, result, error) -> Void in
//
//                        if error == nil {
//                            onCompletion(result as? Dictionary<String, AnyObject>, nil)
//                        } else {
//                            onCompletion(nil, error as NSError?)
//                        }
//                    })
//                }
//            })
//        }
//    }
//}

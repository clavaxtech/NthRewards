//
//  ApiNetworkManager.swift
//
//
//  Created by clavax on 22/01/19.
//  Copyright © 2019 clavax. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


final class NetworkManager: NSObject {
    
    static public let sharedInstance = NetworkManager()
    
    private override init() {}
    
    fileprivate var msg = String()
    
    
    
    func callApiService(serviceType: Services, parameters: [String: Any], successClosure: @escaping callBack) {
        
        if NetworkReachabilityManager()?.isReachable ?? false {
            
            Utility.printLog(messge: "PARAMS -> \(parameters)")
            
            // Serialize to JSON
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                
                // Convert to a string and print
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(" PARAMS JSON ----> \(JSONString)")
                }
            }catch{
                
            }
            
            //            if !delegate.isTokenAuthentic(){
            //
            //                Utility.printLog(messge: "-------- TOKEN  EXPIRED!!! ------ ")
            //
            //                let stringURL = "\(Base.TOKEN_URL)token"
            //                let param = ["client_id": "\(Base.CLIENT_ID)", "client_secret": "\(Base.CLIENT_SECRET)", "grant_type": "client_credentials"]
            //                self.callApiForURLEncoding(url: stringURL, parameters: param, successClosure: {(dictData, ResponseStatus) in
            //
            //                    if ResponseStatus == .sucess {
            //
            //                        self.handleTokenResponse(responseDict:dictData as! [String : Any])
            //
            //                        self.callingApi(serviceType: serviceType, parameters: parameters, successClosure: { (dictData, ResponseStatus) in
            //                            successClosure(dictData, ResponseStatus)
            //                        })
            //
            //                    }else{
            //
            //                    }
            //                })
            //
            //            }else{
            Utility.printLog(messge: " ------- TOKEN  AUTHENTIC!!! -------- ")
            self.callingApi(serviceType: serviceType, parameters: parameters, successClosure: { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            })
            // }
            
        }else{
            successClosure(key.k_Msg_Internet, .fail)
        }
        
        
    }
    
    func callingApi(serviceType: Services, parameters: [String: Any], successClosure: @escaping callBack){
        
        var stringURL : String = ""
        
        if serviceType == .token {
            
            stringURL = "\(Base.TOKEN_URL)\(serviceType.rawValue)"
            self.callApiForURLEncoding(url: stringURL, parameters: parameters, successClosure: {(dictData, ResponseStatus) in
                self.handleTokenResponse(responseDict:dictData as! [String : Any])
                successClosure(dictData, ResponseStatus)
            })
            
        }else if serviceType == .login || serviceType == .registeration || serviceType == .otpVerify || serviceType == .resendOtp{
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: .login, parameters: parameters) { (dictData, ResponseStatus) in
                
                successClosure(dictData, ResponseStatus)
                
            }
        }else if serviceType == .banners{
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "?client_code=nthreward&category=home"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }else if serviceType == .offers{
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Something went wrong", .fail)
            //                return
            //            }
            let customerId = ""
            
            
            Utility.printLog(messge: "CUSTOMER ID  -------> \(customerId)")
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)" + customerId + "?$filters=tags%20in%20offers:Discount"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }
        else if serviceType == .offer_byPoints{
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Something went wrong", .fail)
            //                return
            //            }
             let customerId  = "CUS31673340"
            stringURL = "\(Base.URL)Offers/Customer/" + customerId + "?$filters=tags%20in%20offers:points"
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }else if serviceType == .offer_categories{
            
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }
        else if serviceType == .giftcards {
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }else if serviceType == .products {
            //Important
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            if let categories = parameters["categories"] as? String{
                stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "/?category_code=\(categories)"
            }
            if let prices = parameters["prices"] as? String{
                stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "/?price=\(prices)"
            }
            if let categories = parameters["categories"] as? String , let prices = parameters["prices"] as? String{
                stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "/?category_code=\(categories)&price=\(prices)"
            }
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .categoriesMapping{
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .offers_byOfset {
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Something went wrong", .fail)
            //                return
            //            }
            let customerId  = "CUS31673340"
            
            let offset = parameters["offSet"] as! Int
            let limit = parameters["limit"] as! Int
            let filter = parameters["filter"] as! String
            
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)" + "Customer/\(customerId)?offSet=\(offset)&limit=\(limit)"
            
            if filter != ""{
                stringURL += "&$filters=\(filter)"
                
            }
            
            
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }
        else if serviceType == .offers_detail{
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Something went wrong", .fail)
            //                return
            //            }
            let customerId = "CUS31673340"
            
            guard let offerCode = parameters["code"] as? String else {
                return
            }
            
            
            Utility.printLog(messge: "CUSTOMER ID  -------> \(customerId)")
            
            stringURL = "\(Base.URL)" + "offers/Customer/\(customerId)/\(offerCode)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }
        else if serviceType == .gift_banner {
            
            stringURL = "\(Base.secondary_URL)banners" + "?client_code=nthreward&category=giftcard"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }
        else if serviceType == .gift_points {
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Something went wrong", .fail)
            //                return
            //            }
            let customerId = ""
            
            Utility.printLog(messge: "CUSTOMER ID  -------> \(customerId)")
            
            stringURL = "\(Base.URL)Offers/Customer/" + customerId + "?$filters=tags%20in%20offers:Points"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }
        else if serviceType == .gift_cards {
            
            stringURL = "\(Base.secondary_URL)giftcards"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .gift_detail {
            
            guard let id  = parameters["id"] as? String else {
                successClosure(key.k_Msg_SomeThing, .fail)
                return
            }
            
            stringURL = "\(Base.secondary_URL)giftcards/\(id)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .addtocart {
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: .addtocart, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == . cartDetail{
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Customer Id is nill", .fail)
            //                return
            //            }
            let customerId = ""
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "\(customerId)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .deletefromcart {
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .updatecart {
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        } else if serviceType == .getCustomer {
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .customer {
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Customer Id is nill", .fail)
            //                return
            //            }
            let customerId = ""
            stringURL = "\(Base.URL)\(serviceType.rawValue)" + customerId
            
            self.callPutApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }
            
        else if serviceType == .users{
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }
        else if serviceType == .saveAddress{
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .deleteAddress{
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .generatePaymentToken{
            
            stringURL = "\(Base.TOKEN_URL)token"
            
            self.callApiForURLEncoding(url: stringURL, parameters: parameters, successClosure: {(dictData, ResponseStatus) in
                self.handlePaymentTokenResponse(responseDict:dictData as! [String : Any])
                successClosure(dictData, ResponseStatus)
            })
        }else if serviceType == .transactionRedeem{
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .placeOrder{
            
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == .transactionManager{
            
            stringURL = "\(Base.URL)\(serviceType.rawValue)"
            
            self.callPostApiService(url: stringURL, serviceType: serviceType, parameters: parameters) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        }else if serviceType == . orders{
            
            //            guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
            //                successClosure("Customer Id is nill", .fail)
            //                return
            //            }
            let customerId = ""
            stringURL = "\(Base.secondary_URL)\(serviceType.rawValue)" + "\(customerId)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
        } else if serviceType == .orderDetail{
            
            guard let code = parameters["code"] as? String else {return}
            
            stringURL = "\(Base.secondary_URL)" + serviceType.rawValue + code
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }
        else if serviceType == .activityLog{
            
            let customerCode =  parameters["customer"] as! String
            let limit = parameters["limit"] as! Int
            let page = parameters["page"] as! Int
            
            stringURL = "\(Base.URL)" + serviceType.rawValue + "\(customerCode)/" + "\(limit)/" + "\(page)"
            
            self.callGetApiService(stringUrl: stringURL, serviceType: serviceType) { (dictData, ResponseStatus) in
                successClosure(dictData, ResponseStatus)
            }
            
        }
        
    }
    
    
    
    func callApiForURLEncoding(url : String, parameters: [String: Any], successClosure: @escaping callBack) {
        
        Utility.printLog(messge: "URL  -------> \(url)")
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers:nil
        ).responseJSON { response in
            
            if let responsse = response.result.value{
                Utility.printLog(messge: "Output -> \(response.result.value!)")
                successClosure(responsse, .sucess)
            }
        }
    }
    
    func callPostApiService(url : String, serviceType: Services, parameters: [String: Any], successClosure: @escaping callBack) {
        
        
        Utility.printLog(messge: "URL (\(serviceType)) -------> \(url)")
        
        
        var headers  = Alamofire.SessionManager.defaultHTTPHeaders
        if (serviceType == .transactionRedeem || serviceType == .transactionManager) {
            if let token = Utility.userDefault(key: keyUD.k_tokenPayment) as? String{
                headers["Authorization"] = token
            }
            
        }else{
            
            headers["Authorization"] = (Utility.userDefault(key: keyUD.k_token) as! String)
        }
        headers["Content-Type"] = "application/json"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers
        ).responseJSON
            { response in
                Utility.printLog(messge: "Value -> \(String(describing: response.result.error))")
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        print(data)
                        
                        do {
                            
                            let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:AnyObject]
                            
                            //Utility.printLog(messge: "Output -> \(jsonDict)")
                            
                            if let errors = jsonDict["errors"] as? [[String:Any]] {
                                
                                if  let message  = errors[0]["detail"] as? String {
                                    self.msg = message
                                }
                                successClosure(self.msg, .fail)
                                return
                            }
                            
                            
                            
                            
                            if let status = jsonDict["status"] as? Int {
                                
                                if status == 200{
                                    
                                    successClosure(jsonDict, .sucess)
                                    
                                }else if status == 401 {
                                    
                                    if  let message  = jsonDict["message"] as? String {
                                        self.msg = message
                                    }
                                    
                                    successClosure(self.msg, .fail)
                                }
                                
                                return
                            }
                            
                            successClosure(jsonDict, .sucess)
                            
                        } catch _ as NSError {
                            successClosure("Something went wrong", .fail)
                            
                        }
                        
                    }else{
                        successClosure(response.result.error?.localizedDescription, .fail)
                    }
                    break
                    
                case .failure(_):
                    successClosure("Something went wrong", .fail)
                    break
                    
                }
        }
        
    }
    
    func callPutApiService(url : String, serviceType: Services, parameters: [String: Any], successClosure: @escaping callBack) {
        
        
        Utility.printLog(messge: "URL (\(serviceType)) -------> \(url)")
        
        
        var headers  = Alamofire.SessionManager.defaultHTTPHeaders
        if (serviceType == .transactionRedeem || serviceType == .transactionManager) {
            if let token = Utility.userDefault(key: keyUD.k_tokenPayment) as? String{
                headers["Authorization"] = token
            }
            
        }else{
            
            headers["Authorization"] = (Utility.userDefault(key: keyUD.k_token) as! String)
        }
        headers["Content-Type"] = "application/json"
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers:headers
        ).responseJSON
            { response in
                Utility.printLog(messge: "Value -> \(String(describing: response.result.error))")
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        print(data)
                        
                        do {
                            // Get JSON object from retrieved data string
                            let jsonDict = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:AnyObject]
                            
                            //Utility.printLog(messge: "Output -> \(jsonDict)")
                            
                            if let errors = jsonDict["errors"] as? [[String:Any]] {
                                
                                if  let message  = errors[0]["detail"] as? String {
                                    self.msg = message
                                }
                                
                                successClosure(self.msg, .fail)
                                return
                            }
                            
                            
                            
                            
                            if let status = jsonDict["status"] as? Int {
                                
                                if status == 200{
                                    
                                    successClosure(jsonDict, .sucess)
                                    
                                }else if status == 401 {
                                    
                                    if  let message  = jsonDict["message"] as? String {
                                        self.msg = message
                                    }
                                    
                                    successClosure(self.msg, .fail)
                                }
                                
                                return
                            }
                            
                            
                            successClosure(jsonDict, .sucess)
                            
                        } catch _ as NSError {
                            successClosure("Something went wrong", .fail)
                            
                        }
                        
                    }else{
                        successClosure(response.result.error?.localizedDescription, .fail)
                    }
                    break
                    
                case .failure(_):
                    successClosure("Something went wrong", .fail)
                    break
                    
                }
        }
        
    }
    
    func handleTokenResponse(responseDict : [String : Any]){
        
        guard let access_token = responseDict["access_token"] as? String else {return}
        guard let token_type = responseDict["token_type"] as? String else {return}
        
        Utility.saveUserDefault(value: token_type +  " \(access_token)", key: keyUD.k_token)
        
        if let expiresIn = responseDict["expires_in"] as? Int64 {
            let currentTimeStamp = Date().toMillis()
            let addValue = currentTimeStamp! + expiresIn
            Utility.saveUserDefault(value: String(addValue), key: keyUD.k_expiryTime)
        }
        
    }
    
    func handlePaymentTokenResponse(responseDict : [String : Any]){
        
        guard let access_token = responseDict["access_token"] as? String else {return}
        guard let token_type = responseDict["token_type"] as? String else {return}
        
        Utility.saveUserDefault(value: token_type +  " \(access_token)", key: keyUD.k_tokenPayment)
        
        if let expiresIn = responseDict["expires_in"] as? Int64 {
            let currentTimeStamp = Date().toMillis()
            let addValue = currentTimeStamp! + expiresIn
            Utility.saveUserDefault(value: String(addValue), key: keyUD.k_expiryTime)
        }
        
    }
    
    func callGetApiService(stringUrl: String, serviceType : Services, successClosure: @escaping callBack) {
        
        Utility.printLog(messge: "URL (\(serviceType)) -------> \(stringUrl)")
        var headers  = Alamofire.SessionManager.defaultHTTPHeaders
        if let token = NRSDKAppEvent.token() {
            headers["Authorization"] = token
        }
        
        headers["Content-Type"] = "application/json"
        
        Utility.printLog(messge: " GET API HEADER --------%@",headers)
        
        Alamofire.request(stringUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headers
        ).responseJSON
            { response in
                //Utility.printLog(messge: "RAW RESPONSE........ ->\(response)")
                switch(response.result) {
                case .success(_):
                    Utility.printLog(messge: "CASE SUCCESS!")
                    if let data = response.result.value{
                        
                        print("Raw json Data ------- (\(serviceType.rawValue))  -----> \(data)")
                        
                        do {
                            // Get JSON object from retrieved data string
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as! [String:AnyObject]
                            
                            //Utility.printLog(messge: "Output -> \(json)")
                            
                            if let error = json["error"] {
                                if error as! Int == 1 {
                                    successClosure(response.result.error!, .fail)
                                    return
                                }
                            }
                            
                            successClosure(response.result.value!, .sucess)
                            
                        } catch let error as NSError {
                            print(error)
                            successClosure("Something went wrong", .fail)
                        }
                        
                    }else{
                        successClosure("Something went wrong", .fail)
                    }
                    break
                    
                case .failure(let error):
                    Utility.printLog(messge: "CASE FAILURE!")
                    Utility.printLog(messge: error)
                    successClosure(error.localizedDescription, .fail)
                    break
                    
                }
        }
        
    }
    
    
}






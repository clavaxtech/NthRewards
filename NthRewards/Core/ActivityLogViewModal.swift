//
//  ActivityLogViewModal.swift
//  nth Rewards
//
//  Created by akshay on 11/6/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class ActivityLogViewModal: NSObject {
    
    public var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingActivityLogViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    public var logSectionDateArray = [String]()
    public var logsArray = [[Logs]]()
    
    public func callActivityLogApi(withLimit limit:Int, withPageNo page:Int){
//        guard let customerId = UserInfo.getUserInformation()?.data?.customercode  else {
//            return
//        }
       let customerId  = "CUS31673340"
        var params : [String:Any] = [:]
        params["limit"] = limit
        params["page"] = page
        params["customer"] = customerId
        self.populateData(service: .activityLog, params: params)
        
    }
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in MyAccountViewModal")
                
                self.showAlert?(dictData as? String , service)
                
            case .sucess:
                
                switch service {
                    
                case .activityLog:
                    self.handleActivityLogResponse(responseDict: dictData as! [String : Any])
                    
                default:
                    break
                }
            }
            
        })
        
    }
    
    func handleActivityLogResponse(responseDict : [String : Any]){
        
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objectInfo  = try objDecoder.decode(ActivityLogModal.self, from: jsonData)
            
            var logsArray = [Logs]()
            if let logs = objectInfo.data {
                Utility.printLog(messge: "Orignal array Left ------->\(logs.count)")
                logsArray.append(contentsOf: logs.filter({
                    $0.description != "Verify OTP" &&  $0.description != "Login"  &&  $0.description != "Resend OTP"
                }))
            }
            Utility.printLog(messge: "Total array Left ------->\(logsArray.count)")
            
            self.parseLogArray(array: logsArray)
            self.bindingActivityLogViewModel?(objectInfo,.activityLog)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
        
        
    }
    
    private func parseLogArray(array:[Logs]){
        
        let filteredDates = Array(Set(array.map({$0.sectionDate})))
        
        let formater = DateFormatter()
        formater.dateFormat = "MMM yyyy" //date formate should be according to your date formate
        let sortedArray=filteredDates.sorted(){
            (obj1, obj2) in
            let date1=formater.date(from: obj1)
            let date2=formater.date(from: obj2)
            return date1!>date2!
        }
        Utility.printLog(messge: "Date string ------> \(sortedArray)")
        for date in sortedArray.enumerated(){
            self.logSectionDateArray.append(date.element)
            self.logsArray.append(array.filter({$0.sectionDate == date.element}))
        }
    }
}



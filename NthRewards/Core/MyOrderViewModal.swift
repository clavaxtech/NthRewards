//
//  MyOrderViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 25/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class MyOrderViewModal: NSObject {
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingMyOrderViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    public var openDetailViewController : ((_ code : String) ->())?
    
    private (set) var ordersArrayObject = [MyOrderModalData]()
    
    
    public func callOrdersAPI(){
        self.populateData(service: .orders, params: [String:Any]())
    }
    
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in MyOrderViewModal")
                
                self.showAlert?(dictData as? String , service)
                
                break
                
            case .sucess:
                
                switch service {
                case .orders:
                    self.handleOrdersResponse(responseDict: dictData as! [String : Any])
                    break
                default:
                    break
                }
                
                
                break
            }
            
        })
        
        
    }
    
    func handleOrdersResponse(responseDict : [String : Any]){
        do {
            //Get JSON object from retrieved data string
            let jsonData = try JSONSerialization.data(withJSONObject: responseDict)
            let objDecoder = JSONDecoder()
            let objUserInfo  = try objDecoder.decode(MyOrderModal.self, from: jsonData)
            
            if let data = objUserInfo.data{
                self.ordersArrayObject = data
            }
            
            self.bindingMyOrderViewModel?(objUserInfo, .orders)
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")  
        }
    }
}

extension MyOrderViewModal : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersArrayObject.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyOrderTableViewCell.identifier, for: indexPath) as? MyOrderTableViewCell else{
            return UITableViewCell()
        }
        
        cell.orderObject = self.ordersArrayObject[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}


extension MyOrderViewModal : MyOrderTableViewCellDelegate{
    
    func onDidViewMoreAt(Id: String?) {
        if let code = Id {
            self.openDetailViewController?(code)
        }
    }
}



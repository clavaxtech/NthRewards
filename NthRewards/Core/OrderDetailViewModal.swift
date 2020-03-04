//
//  OrderDetailViewModal.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 27/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class OrderDetailViewModal: NSObject {
    
    var showAlert : ((_ alertStr : String? , _ service : Services) ->())?
    
    public var bindingOrderDetailViewModel : ((_ data : Any , _ serviceType : Services) ->())?
    
    public var itemListArray = [ItemListProduct]()
    
    public var orderObject : OrderDetailModal?
    
    public func callOrderDetailAPI(code : String){
        var parameters = [String:Any]()
        parameters["code"] = code
        self.populateData(service: .orderDetail, params: parameters)
    }
    
    private func populateData(service:Services , params : [String:Any]){
        
        NetworkManager.sharedInstance.callApiService(serviceType: service, parameters: params, successClosure: {(dictData, ResponseStatus) in
            switch ResponseStatus {
                
            case .fail:
                
                Utility.printLog(messge: "API FAIL!! in OrderDetailView Model")
                self.showAlert?(dictData as? String , service)
                break
                
            case .sucess:
                Utility.printLog(messge: "API SUCCESS!! in OrderDetailView Model")
                switch service {
                case .orderDetail:
                    
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
            let objOrder  = try objDecoder.decode(OrderDetailModal.self, from: jsonData)
            
            self.orderObject = objOrder
            if let itemList = objOrder.data?.item_list{
                self.itemListArray = itemList
            }
            Utility.printLog(messge: "Total item count ----> \(self.itemListArray)")
            self.bindingOrderDetailViewModel?(objOrder,.orderDetail)
            
        }
        catch(let error){
            print("JSON Parsing Error >> \(error)")
        }
    }
    
}

extension OrderDetailViewModal : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(OrderDetailTableViewCell.cellHeight)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailTableViewCell.identifier, for: indexPath) as? OrderDetailTableViewCell
            else {return UITableViewCell()}
        Utility.printLog(messge: "Cell #\(indexPath.row)")
        cell.orderObject = self.itemListArray[indexPath.row]
        return cell
    }
    
    
}



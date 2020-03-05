//
//  ActivityLogViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/5/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit
import Foundation

class ActivityLogViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
    fileprivate let viewModal = ActivityLogViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialInterface()
        self.bindingViewModal()
        
        self.getActivityLog(pageSize: 200, page: 1)
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
        
        //        self.setNavigationBar(hidden: false, controller: self, titleName: NavigationTitle.activityLog)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: false, controller: self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
        
    }
    
    func bindingViewModal(){
        
        self.viewModal.showAlert = { (alertMessage : String? , service : Services) in
            
            Utility.printLog(messge: "ERROR API IN ")
            Utility.showAlertView(title: key.k_Alert, message: alertMessage ?? "", in: self)
        }
        
        self.viewModal.bindingActivityLogViewModel = {(data:Any?, serviceType : Services) in
            //self.hideHud()
            //Hello testing
            
            switch serviceType {
            case .activityLog:
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            default:
                break
            }
        }
    }
    
    func getActivityLog(pageSize : Int, page:Int){
        //self.showHud()
        self.viewModal.callActivityLogApi(withLimit: pageSize, withPageNo: page)
    }
    
}

 
extension ActivityLogViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModal.logsArray[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModal.logSectionDateArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell : ActivityLogTableViewCell = tableView.dequeueReusableCell(withIdentifier: ActivityLogTableViewCell.identifier, for: indexPath) as? ActivityLogTableViewCell else {return UITableViewCell()}
        cell.log = self.viewModal.logsArray[indexPath.section][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        if let headerView = Bundle.main.loadNibNamed("ActivityLogSectionCell", owner: nil, options: nil)?.first as? ActivityLogSectionCell {
        
        if let bundle = Utility.bundle(forView: ActivityLogSectionCell.self) {
            if let headerView = bundle.loadNibNamed("ActivityLogSectionCell", owner: nil, options: nil)?.first as? ActivityLogSectionCell {
                headerView.dateLabel.text = self.viewModal.logSectionDateArray[section]
                
                return headerView
                
            }
            
            //}
            
        }
        return UIView()
    }
    
    
}

//
//  OfferFilterViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/25/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

protocol OfferFilterViewControllerDelegate {
    func clearFilter()
    func apply(withCategories categories: Set<String> , withArea area: Set<String>)
}

class OfferFilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    public var filterCategoryArray : [Category] = []
    public var filterAreaArray : [Category] = []
    public var filterSectionArray : [String] = []
    
    public var selectedCotegories = Set<String>()
    public var selectedArea = Set<String>()
    
    var delegate : OfferFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.setNavigationBar(hidden: true, controller: self, titleName: NavigationTitle.catalogue)
        //        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: true, controller: self)
      
        
        // Do any additional setup after loading the view.
        if let bundle = Utility.bundle(forView: OfferFilterViewController.self){
            tableView.register(UINib(nibName: "ProductFilterTableViewCell", bundle: bundle), forCellReuseIdentifier: ProductFilterTableViewCell.identifier)
            tableView.delegate = self
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            tableView.dataSource = self
            self.tableView.reloadData()
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func dismissFilter(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @IBAction func clearFilterBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.clearFilter()
            
        })
        
    }
    
    @IBAction func applyBtnClick(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.apply(withCategories: self.selectedCotegories, withArea: self.selectedArea)
            
        })
        
    }
    
}


extension OfferFilterViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filterSectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? self.filterCategoryArray.count :  self.filterAreaArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductFilterTableViewCell.identifier, for: indexPath) as! ProductFilterTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        if indexPath.section == 0 {
            if let name  = self.filterCategoryArray[indexPath.row].name{
                cell.titleLabel.text = name
                
                
            }
            
            if let code  = self.filterCategoryArray[indexPath.row].value{
                selectedCotegories.contains(code) ? (cell.checkBox.isSelected = true) : (cell.checkBox.isSelected = false)
            }
            
            
            
        }else{
            if let name  = self.filterAreaArray[indexPath.row].name{
                cell.titleLabel.text = name
                
                
            }
            
            if let code  = self.filterAreaArray[indexPath.row].value{
                selectedArea.contains(code) ? (cell.checkBox.isSelected = true) : (cell.checkBox.isSelected = false)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewSection = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: viewSection.frame.width - 20, height: viewSection.frame.height))
        viewSection.backgroundColor = UIColor.white
        viewSection.addSubview(label)
        label.font = UIFont(name: "Helvetica Regular", size: 16)
        label.backgroundColor = UIColor.white
        label.text = self.filterSectionArray[section]
        return viewSection
        
    }
    
    
    
    
}

extension OfferFilterViewController : ProductFilterTableViewCellDelegate{
    
    func onCheckBoxClicked(atIndexPath: IndexPath, isSelected: Bool) {
        Utility.printLog(messge: atIndexPath)
        if atIndexPath.section == 0 {
            if let code = self.filterCategoryArray[atIndexPath.row].value {
                if isSelected {
                    self.selectedCotegories.insert(code)
                }else{
                    self.selectedCotegories.remove(code)
                }
                
            }
        }else if atIndexPath.section == 1{
            if let code = self.filterAreaArray[atIndexPath.row].value {
                if isSelected {
                    self.selectedArea.insert(code)
                }else{
                    self.selectedArea.remove(code)
                }
                
            }
            
        }
    }
    
    
}

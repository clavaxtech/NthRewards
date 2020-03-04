//
//  FilterViewController.swift
//  nth Rewards
//
//  Created by akshay on 11/18/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func clearFilter()
    func apply(withCategories categories: Set<String> , withPrices prices: Set<String>)
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    public var categoriesArray : [Category] = []
    private let priceArray = ["0-500" , "500-1000" , "1000-3000" , "3000-5000" ,  "5000-10000" ]
    private let filterSectionArray = ["Categories" , "Price"]
    
    public var selectedCotegories = Set<String>()
    public var selectedPrices = Set<String>()
    
    var delegate : FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setNavigationBar(hidden: true, controller: self, titleName: NavigationTitle.catalogue)
//        self.enableLeftBarButton(with: .backButton, isBackButtonHidden: true, controller: self)
        
        // Do any additional setup after loading the view.
         if let bundle = Utility.bundle(forView: ProductDetailViewController.self){
        tableView.register(UINib(nibName: "ProductFilterTableViewCell", bundle: bundle), forCellReuseIdentifier: ProductFilterTableViewCell.identifier)
        }
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    @IBAction func dismissFilter(_ sender: Any) {
        print("DISMISS")
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
            self.delegate?.apply(withCategories: self.selectedCotegories, withPrices: self.selectedPrices)
            
        })
        
    }
}

extension FilterViewController : UITableViewDelegate , UITableViewDataSource{
    
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
        return (section == 0 ? categoriesArray.count :  priceArray.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductFilterTableViewCell.identifier, for: indexPath) as! ProductFilterTableViewCell
        cell.indexPath = indexPath
        cell.delegate = self
        if indexPath.section == 0 {
            if let name  = self.categoriesArray[indexPath.row].name{
                cell.titleLabel.text = name
                
                
            }
            
            if let code  = self.categoriesArray[indexPath.row].code{
                selectedCotegories.contains(code) ? (cell.checkBox.isSelected = true) : (cell.checkBox.isSelected = false)
            }
            
            
            
        }else{
            let priceRanges = self.priceArray[indexPath.row]
            let prices = priceRanges.split(separator: "-")
            cell.titleLabel.text = "Rs \(prices[0]) - Rs \(prices[1])"
            selectedPrices.contains(self.priceArray[indexPath.row]) ? (cell.checkBox.isSelected = true) : (cell.checkBox.isSelected = false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewSection = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: viewSection.frame.width - 20, height: viewSection.frame.height))
        viewSection.addSubview(label)
        viewSection.backgroundColor = UIColor.white
        label.font = UIFont(name: "Helvetica Regular", size: 16)
        label.backgroundColor = UIColor.white
        label.text = self.filterSectionArray[section]
        return viewSection
        
    }
    
    
    
    
}

extension FilterViewController : ProductFilterTableViewCellDelegate{
    func onCheckBoxClicked(atIndexPath: IndexPath, isSelected: Bool) {
        Utility.printLog(messge: atIndexPath)
        if atIndexPath.section == 0 {
            if let code = self.categoriesArray[atIndexPath.row].code {
                if isSelected {
                    self.selectedCotegories.insert(code)
                }else{
                    self.selectedCotegories.remove(code)
                }
                
            }
        }else if atIndexPath.section == 1{
            if isSelected {
                self.selectedPrices.insert(self.priceArray[atIndexPath.row])
            }else{
                self.selectedPrices.remove(self.priceArray[atIndexPath.row])
            }
            
        }
    }
    
    
}

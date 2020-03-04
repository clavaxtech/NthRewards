//
//  BaseViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 14/08/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit


enum ControllerDismissType : String {
    case backButton = "back_image"
    case crossButton = "cross_image"
    case menu = "menu"
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    public func setNavigationBar(hidden : Bool, controller: UIViewController, titleName: String){
        
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        
        controller.navigationController?.isNavigationBarHidden = hidden
        controller.navigationController?.navigationBar.backgroundColor = UIColor.white
        controller.navigationController?.navigationBar.layer.shadowColor = UIColor.init(red: 220/255, green: 215/255, blue: 248/255, alpha: 1.0).cgColor
        controller.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        controller.navigationController?.navigationBar.layer.shadowRadius = 1.0
        controller.navigationController?.navigationBar.layer.shadowOpacity = 0.5
        controller.navigationController?.navigationBar.layer.masksToBounds = false
        controller.navigationItem.title = titleName;
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        
    }
    
    
    public func enableLeftBarButton(with buttonType :ControllerDismissType , isBackButtonHidden:Bool, controller : UIViewController){
        
        if !isBackButtonHidden{
            let btnBack: UIButton = UIButton()
            btnBack.setImage(UIImage(named: buttonType.rawValue), for: UIControl.State())
            btnBack.addTarget(self, action: #selector(self.onBackButtonClick), for: UIControl.Event.touchUpInside)
            btnBack.backgroundColor = UIColor.clear
            btnBack.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 0)
            btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
            controller.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnBack)
        }else{
            
            controller.navigationItem.hidesBackButton = isBackButtonHidden }
    }
    
    
    @objc func onBackButtonClick(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

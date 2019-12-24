//
//  OfferInfoStepsViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 26/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class OfferInfoStepsViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    //MARK: Properties
    public var typo : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initialInit()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func initialInit(){
      
        
        if let text = typo {
            if let htmlData = text.htmlToAttributedString {
                Utility.printLog(messge: "the text in  TermsAndConditionViewController \(String(describing: htmlData))")
                textView.attributedText = htmlData
            }
        }
        
    }
    
}

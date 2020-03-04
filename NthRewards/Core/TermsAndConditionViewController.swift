//
//  TermsAndConditionViewController.swift
//  nth Rewards
//
//  Created by Deepak Tomar on 09/09/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import UIKit

class TermsAndConditionViewController: UIViewController {
    
    
    @IBOutlet var textView: UITextView!
    public var tandCText : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // self.initialInit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        if let text = tandCText {
            Utility.printLog(messge: "the text in  TermsAndConditionViewController \(String(describing: text.htmlToAttributedString))")
            if let htmlData = text.htmlToAttributedString {
                Utility.printLog(messge: "the text in  TermsAndConditionViewController \(String(describing: htmlData))")
                textView.attributedText = htmlData
            }
        }
        
    }
    
}

//
//  NthRewards.swift
//  NthRewards
//
//  Created by akshay on 12/13/19.
//  Copyright © 2019 akshay. All rights reserved.
//

import Foundation
import UIKit


public class NthRewards {
    
    public static func performSegueToFrameworkVC(caller: UIViewController) {
        
        let podBundle = Bundle(for: OffersViewController.self)
        
        let bundleURL = podBundle.url(forResource: "NthRewards", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        let storyboard = UIStoryboard(name: "NthRewardStoryboard", bundle: bundle)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "OffersViewController")
        caller.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}

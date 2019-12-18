# NthRewards
Nth Rewards is a swift library of unique offer and loyalty platform, powered by NPCI, offering customers to redeem their accumulated loyalty points through various redemption options listed in the app/website



# Installation

CocoaPods (Recommended)

Install CocoaPods


Add this repo to your Podfile

target 'Example' do

IMPORTANT: Make sure use_frameworks! is included at the top of the file

use_frameworks!

platform :ios, '9.0'

pod 'NthRewards', :git => 'https://github.com/clavaxtech/NthRewards.git', :tag => '1.0.0'

end



Run pod install

Open up the .xcworkspace that CocoaPods created

Done!



# Usage

In AppDelegate.swift Class

import NthRewards

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        
        NRSDKAppEvent.activateApp()
        
        return true
}



Any UIViewController.swift

import NthRewards

@IBAction func rewardButnClick(_ sender: Any) {

         NthRewards.performSegueToFrameworkVC(caller: self)
   
}



# Example project

Take a look at the example project over here

Download it

Open the Example.xcworkspace in Xcode

Enjoy!


# Author

clavaxtech, www.clavax.com


# License

NthRewards is available under the MIT license. See the LICENSE file for more info.

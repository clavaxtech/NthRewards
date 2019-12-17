//
//  Constants.swift
//  MakePlus
//
//  Created by Deepak Tomar on 15/03/19.
//  Copyright © 2019 Deepak Tomar. All rights reserved.
//

import Foundation
import UIKit

//var delegate = UIApplication.shared.delegate as! AppDelegate


enum Services: String {
    
    case token  = "token"
    case login = "Customer/Login"
    case registeration = "Customer/Registration"
    case otpVerify =  "Customer/VerifyOTP"
    case resendOtp = "Customer/ResendOTP"
    //Home Service
    
    case banners = "banners"
    case offers = "Offers/Customer/"
    case offer_byPoints = "Offers/Customer/Earnpoints/"
    case giftcards = "giftcards"
    case products = "products"
    case categoriesMapping = "categories/mappings"
    
    //Offers
    
    case offers_byOfset = "Offers/"
    case offers_detail = "offers_detail"
    case offer_categories = "offer-categories/"
    
    //Gifts
    case gift_banner = "gift_banner"
    case gift_points = "gift_points"
    case gift_cards = "gift_cards"
    
    case gift_detail = "gift_detail"
    
    //Cart
    case addtocart = "addtocart"
    case cartDetail = "cartdetail/"
    case deletefromcart  = "deletefromcart"
    case updatecart = "updatecart"
    case customer = "Customer/"
    case getCustomer = "Customer/GetCustomer"
    case users = "users"
    case saveAddress = "save-address"
    case deleteAddress = "delete-address"
    
    
    //payment
    case generatePaymentToken = "PaymentToken"
    case transactionRedeem =  "Transaction/Redeem"
    case placeOrder = "place-order/"
    case transactionManager = "Transaction/TransactionManager"
    
    //Orders
    case orders = "orders/"
    case orderDetail  = "order/"
    
    case activityLog = "ActivityLog/"
    
}

enum PaymentServices: String{
    
    case hello = " dd"
    
}

struct Base {
    
    // nth API
    static let URL = "https://nthrewardsprogramapi.novusloyalty.com/api/"
    //static let URL = "https://stagingprogramapi.azurewebsites.net/api/"
    static let TOKEN_URL = "https://nthrewardsid.novusloyalty.com/connect/"
    //static let TOKEN_URL = "https://stagingprogramidsrv.azurewebsites.net/connect/"
    static let CLIENT_ID = "GeneralClient"
    static let CLIENT_SECRET = "GAZQMSGIRH"
    
    
    //for fulfilment Live others api
    static let GRANT_TYPE = "client_credentials"
    
    
    static let secondary_URL = "https://fulfillmentadminpro.azurewebsites.net/api/"
    //static let secondary_URL = "https://fulfilment-admin.azurewebsites.net/api/"
    static let PLACEORDER_CLIENT_ID = "6825bcf4-45bf-4b69-be65-312528959c03"
    
    //Payment
    static let merchantClientId = "nth fulfillment ios637001474426860087"
    static let merchantClientSecret = "SVQDUDLYHI"
    
    // DEMO -----Razorpay payment api key and secret key
    //    static let RAZORPAY_ID = "rzp_test_r1kZ0eQ229Q3hY"
    //    static let RAZORPAY_SECRET_ID = "lH2Ma1w037VqrBnp2b8504d5"
    
    // LIVE -----Razorpay payment api key and secret key
    static let RAZORPAY_ID = "rzp_live_x9YRmyIqe8cLJD"
    static let RAZORPAY_SECRET_ID = "A5AfzBJ1zs3mt9cJ7qwT2eXM"
}


struct key {
    
    static let k_Alert = NSLocalizedString("Alert", comment: "")
    static let k_Ok = "Ok"
    
    // Message Key
    static let k_Msg_Name =  NSLocalizedString("Please enter name", comment: "")
    static let k_Msg_FirstName =  NSLocalizedString("Please enter first name", comment: "")
    static let k_Msg_LastName = "Please enter last name"
    static let k_Msg_Email = "Please enter a valid email address or username to login"
    static let k_Msg_Password = "Please enter password"
    static let k_Msg_PasswordRange = "Password should be greater then 8 and less then 20 characters"
    
    static let k_Msg_Required = NSLocalizedString("Please fill all the required fields", comment: "")
    static let k_Msg_InvalidEmail = NSLocalizedString("Invalid email", comment: "")
    static let k_Msg_Length = NSLocalizedString("Password must contain at least 8 to 20 characters including one numeric, one uppercase, one lowercase one special character", comment: "")
    static let k_Msg_Space = NSLocalizedString("Please remove the space.", comment: "")
    static let k_Msg_Alpha = NSLocalizedString("Only alphabets are allowed in Firstname.", comment: "")
    static let k_Msg_LAlpha = NSLocalizedString("Only alphabets are allowed in Laststname.", comment: "")
    static let k_Msg_Phone = NSLocalizedString("Please enter valid number", comment: "")
    static let k_Msg_PhoneAlpha = NSLocalizedString("Alphabets are not allowed.", comment: "")
    static let k_Msg_Internet = NSLocalizedString("The Internet connection appears to be offline", comment: "")
    static let k_Msg_ConfirmPwd = NSLocalizedString("Please enter confirm password", comment: "")
    static let k_Msg_Confirm = NSLocalizedString("Password & Confirm Password don't match.", comment: "")
    static let k_Msg_Pincode = NSLocalizedString("Pincode is not correct", comment: "")
    static let k_Msg_PinAlpha = NSLocalizedString("Alphabets are not allowed inside Pincode.", comment: "")
    static let k_Msg_PhoneSpace = NSLocalizedString("Space is not allowed inside Phone Number.", comment: "")
    static let k_Msg_PinSpace = NSLocalizedString("Space is not allowed inside Pincode.", comment: "")
    static let k_Msg_City = NSLocalizedString("Numbers are not allowed in City name.", comment: "")
    static let k_Msg_SomeThing = NSLocalizedString("Something went wrong, Please try again later", comment: "")
    static let k_Msg_Mismatch = NSLocalizedString("Old Password & New Password Mismatched", comment: "")
    static let k_Msg_OTP_Empty = NSLocalizedString("Please enter valid OTP", comment: "")
    static let k_Msg_PointsCannotBeGreater = NSLocalizedString("Required points are more than total points", comment: "")
    static let k_Msg_PointsCannotBeEqualToZero = NSLocalizedString("Redeem the required points first", comment: "")
    static let k_Msg_SelectAddress = NSLocalizedString("Please select the address.", comment: "")
    static let k_Msg_LogoutConfirmation = NSLocalizedString("Are you sure want to logout?", comment: "")
    static let k_Msg_DeleteConfirmation = NSLocalizedString("Are you sure want to delete?", comment: "")
    
    //MARK: - ADDRESS
    static let k_Msg_Country = NSLocalizedString("Please Select Your country", comment: "")
    static let k_Msg_Terms_Condtion = NSLocalizedString("Please check terms & conditions", comment: "")
    
}


struct Constants {
    
    //Iphone x safe areas
    static let k_iphonex_above_safearea_top = 44
    static let k_iphonex_above_safearea_bottom = 34
    static let k_iphonex_above_safearea_left = 0
    static let k_iphonex_above_safearea_right = 0
    
    //Cells height
    static let k_shop_Cell0_width : Int = 60
    static let k_schedule_Cell0_width : Int = 60
    static let k_addCredits_cell0_width = 100
    
    //Collection view Cell spacing
    static let k_shop_emblem_cell_spacing : Int = 18
    
    //Topview height
    static let k_topViewHeight_iphone6 = 158
    static let k_topViewHeight_iphonex_Above = 202 //178
    static let k_topViewHeight_iphoneP = 198
    static let k_topViewHeight_iphoneIPad = 218
    
    static let k_appLogo_Y_iphone6 = 38
    static let k_appLogo_Y_iphoneX_above = 60 + 20     //60 + (44/2 = 22) (safe area top) 2(subtract for beautification)
    static let k_appLogo_Y_iphoneP = 58
    static let k_appLogo_Y_iphoneIPad = 68
    
    //Bottomview height
    static let k_bottomViewHeight_iphone6 = 70
    static let k_bottomViewHeight_iphoneX_Above = 100
    
    //Extra margin
    static let k_top_extraMargin = 25
    
}


struct keyUD {
    static let k_UserInfo = "k_UserInfo"
    static let k_UserProfileInfo = "k_UserProfileInfo"
    static let k_FirstTime = "k_FirstTime"
    static let k_token = "k_token"
    static let k_tokenPayment = "k_token_payment"
    static let k_expiryTime = "k_expiryTime"
    static let k_cartValue = "k_cartValue"
}

// Device
struct DeviceType {
    
    static let iPad   =   UIDevice.current.userInterfaceIdiom == .pad
    static let iPhone =   UIDevice.current.userInterfaceIdiom == .phone
    static let iPhone5 =  (DeviceType.iPhone && UIScreen.main.nativeBounds.height == 1136)
    static let iPhone6 =  (DeviceType.iPhone && UIScreen.main.nativeBounds.height == 1334)
    static let iPhoneP =  (DeviceType.iPhone && UIScreen.main.nativeBounds.height == 1920) || (DeviceType.iPhone && UIScreen.main.nativeBounds.height == 2208)
    static let iPhoneX_Above = (DeviceType.iPhone && (UIScreen.main.nativeBounds.height == 2436) || (UIScreen.main.nativeBounds.height == 2688) || (UIScreen.main.nativeBounds.height == 1792))
    
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


enum MultipleStoryBoards {
    
    static let kSplashAndOnboardingSB = UIStoryboard(name: "Main", bundle: nil)
    static let kHomeSB = UIStoryboard(name: "Home", bundle: nil)
    static let kMenuSB = UIStoryboard(name: "Menu", bundle: nil)
    static let kTutorialSB = UIStoryboard(name: "Tutorial", bundle: nil)
    static let kGiftSB = UIStoryboard(name: "Gift", bundle: nil)
    static let kShoppingCart = UIStoryboard(name: "ShopingCart", bundle: nil)
    static let kDashboard = UIStoryboard(name: "Dashboard", bundle: nil)
    static let kPayment = UIStoryboard(name: "Payment", bundle: nil)
    static let kProduct = UIStoryboard(name: "Product", bundle: nil)
    
}

enum MathUtility {
    case increment
    case subtract
    case clear
}

enum FontBook: String {
    case Helvetica_Bold = "Helvetica Bold"
    case Helvetica_Regular = "Helvetica Regular"
    
    func of(size: CGFloat) -> UIFont? {
        return UIFont(name: self.rawValue, size: size)!
    }
}


enum DateFormat : String{
    case f_date = "dd-MM-yyyy HH:mm:ss"
    case utc = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case utc1 = "yyyy-MM-dd'T'HH:mm:ss"
    case utc2 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    case shortStyle = "MMM yyyy"
    case medStyle = "MMM dd, yyyy"
    case medStyle1 = "E, dd MMM, yyyy"
    
    case longlongStyle = "dd-MM-yyyy hh-mm a"
}

enum VCIdentifire : String {
    
    case splashViewController = "SplashViewController"
    case tutorialViewController = "TutorialViewController"
    case tutorialPageViewController = "TutorialPageViewController"
    case tutorialOneViewController = "TutorialOneViewController"
    case tutorialTwoViewController = "TutorialTwoViewController"
    case tutorialThreeViewController = "TutorialThreeViewController"
    case tutorialFourViewController = "TutorialFourViewController"
    
    case successViewController = "SuccessViewController"
    
    //Onboarding
    case registerViewController = "RegisterViewController"
    case loginViewController = "LoginViewController"
    case otpViewController = "OTPViewController"
    case webViewViewController = "WebViewViewController"
    
    //Home
    case rootViewController = "RootViewController"
    case leftMenuViewController = "LeftMenuViewController"
    case contentViewController = "contentViewController"
    case offersViewController = "OffersViewController"
    case offerDetailViewController = "OfferDetailViewController"
    case offerInfoStepsViewController = "OfferInfoStepsViewController"
    case offerFilterViewController = "OfferFilterViewController"
    
    
    //Gifts
    case giftViewController = "GiftViewController"
    case giftDetailViewController = "GiftDetailViewController"
    case termsAndConditionViewController = "TermsAndConditionViewController"
    
    
    //Shopping
    case cartViewController = "CartViewController"
    case fastForwardRedeemViewController = "FastForwardRedeemViewController"
    case addressViewController = "AddressViewController"
    case addAddressViewController = "AddAddressViewController"
    
    //Order
    case myOrderViewController = "MyOrderViewController"
    case orderDetailViewController = "OrderDetailViewController"
    
    //Payment
    case paymentViewController = "PaymentViewController"
    case paymentOptionViewController = "PaymentOptionViewController"
    case linkWalletViewController = "LinkWalletViewController"
    case upiViewController = "UPIViewController"
    case rPayViewController = "RPayViewController"
    
    //Menu
    case myAccountViewController = "MyAccountViewController"
    case earnPointViewController = "EarnPointViewController"
    case activityLogViewController = "ActivityLogViewController"
    case editProfileViewController = "EditProfileViewController"
    
    
    //Products
    case productViewController = "ProductViewController"
    case productDetailViewController = "ProductDetailViewController"
    case filterViewController = "FilterViewController"
}



struct NavigationTitle {
    
    static let login                = "Login"
    static let register             = "Sign Up"
    static let otpScreen            = "OTP"
    static let profile              = "My Profile"
    static let transactionHistory   = "Transaction History"
    static let myCard               = "My Card"
    static let home                 = "nth Rewards"
    static let forgetPassword       = "Forgot Password"
    static let offerDetail          = "Offer Detail"
    static let offers          = "Offers"
    
    static let gifts   =   "Gift Cards"
    static let shoppingCart = "Shopping cart"
    static let address = "Address"
    static let AddAddress = "Add New Address"
    
    static let myOrders = "My Orders"
    static let orderDetail = "Order Detail"
    
    //Payment
    static let payment = "Payment"
    static let linkWallet = "Link to Wallet"
    static let UPI = "UPI"
    
    static let myAccount = "My Account"
    static let activityLog = "Activity Log"
    
    static let editProfile = "Edit Profile"
    
    static let earnPoints = "Earn Points"
    
    static let catalogue = "Catalogue"
    
}

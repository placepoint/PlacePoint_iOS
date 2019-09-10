
//  GlobalVariable.swift
//  Clip the Deal


//  "" on 30/11/17.
//  Copyright © 2017 "". All rights reserved.


import UIKit
var showAthlonePopUp = false
var boolScheduleCell = false
var upgardeType = String()

var strUserType = String()

var isCatSel = false

var isAllCategories = false

var goToShowFeed = false

var openBusinessess = false

var parentCategory = String()

var arrAllCategories = [AnyObject]()

var dictAllCategories = [String: Any]()

var selectedcategories = [String]()

var arrPostCategories = [AnyObject]()

var dictPostCategories = [String: Any]()

var isMoreVc = false

var isDealFeatureBuisness = false

var isLogout = false

var isFilterBusiness = false

var selectedCategory = String()

var isAllCat = false

var isBusinessDetail = false

var isShowBusinessDetail = false

var isBusinessVc = true

var businessName = String()

var isShowFeed = false

var isLiveFeed = false

var parentCategoryName = String()

var isEditPost = false

var isScheduleVc = false

var isAddPost = false

var savedImages = [AnyObject]()

var arrBusinessImages = [AnyObject]()

var arrUrlSavedImages = [AnyObject]()

var arrNewSavedImages = [AnyObject]()

var arrCheckMaxImages = [UIImage]()

var isCollectionHaveImage: Bool = false

var isYoutubeBtnSelected: Bool = false

var noImage: Bool = false

var isFirstCome = false

var isChooseCategoryVc = false

var checkMyTimeLine: String?

var isShowMyTimeLine = false

var selectedTown = String()

var leftMenuView: Bool = false

var arrFilterTime = [[String: String]]()

var checkBusinessDetailVc = false

var isApplyCoupon = false

var isSubSelectPlane = false

var price = Int()

var couponCode = String()

var isTaxiCat = false

var strBusinessId = String()

var strBusinessUserType = String()

var strBusinessUserId = String()

var taxiBusinessSelected = false

var isCatgoryTabSelected = false

var postId = String()

var boolJumpToSchedule = Bool()

var heightOfTabbar = CGFloat()

var boolJumpToFlashPost = Bool()

//var floatHeightOfSlidingContainer = CGFloat()


struct Global {
   
    static let networkTitle = "Network Unavailable"
    
    static let networkMessage = "Please connect to the internet in order to proceed."
    
    static let tempToken = "GUARD_V1"
    
    static let urlForShare = "https://appurl.io/jegp8lgk"
    
    static let urlForTermsAndCondition = "http://guardian-app.co/termsmobile.php"
    
    static let urlForFAQs = "http://guardian-app.co/faqmobile.php"
    
    
}

struct ValidAlertTitle {
    
    static let FieldMandatory = "All fields are mandatory!"
    
    static let EnterValidEmail = "Email Incorrect!"
    
    static let Warning = "Warning!"
    
    static let Alert = "Alert!"
    
    static let Error = "Error!"
    
     static let Sorry = "Sorry!"
    
    static let Success = "Success"
    
    static let ForgotPasswordAlertTitle = "An email has been sent to your email address with a new password. Please check your email."
    
}

struct ValidAlertMsg {
    
    static let FieldMandatory = "Please enter all values and try again."
    
    static let validOtp = "OTP must be of 4 digits"
    
    static let EnterValidEmail = "Please enter valid email."
    
    static let EnterVehicleNum = "Please enter vehicle number"
    
    static let PwdNotSame = "Password and confirm password must be same."
    
    static let ReportingAlert = "Please make sure you are reporting an actual accident. Reporting a false accident is a criminal offence and legal action can be taken against you."
    
    static let ValidPassword = "Phone number must be of 10 didgits"
}

extension UIAlertController {
    
        class func Alert(title: String, msg: String, vc: UIViewController) -> Void {
            
            let myAlertVC = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            { (result : UIAlertAction) -> Void in
                
                vc.view.endEditing(true)
            }
            
            myAlertVC.addAction(okAction)
            
            vc.present(myAlertVC, animated: true, completion: nil)
        }
}

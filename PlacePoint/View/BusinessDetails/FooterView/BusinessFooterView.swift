//
//  BusinessFooterView.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol showTimePicker: class {
    
    func selectTime(selectedBtn: Int)
    
    func openMap()
    
    func selectWeekDay(tag: Int?)
    
    func checkClosedDay(dayClose: Bool?)
    
    func getContactNumber(str:String)
    
    func applyTimeToAll(isApply: Bool)
    
    func showPopUpPremView()
    
    func upgradePlanPopUp()
    
}

class BusinessFooterView: UIView {
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet var vwCategory: UIView!
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var vwTown: UIView!
    
    @IBOutlet var viewAddress: UIView!
    
    @IBOutlet weak var txtFldPhoneNumber: UITextField!
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    
    @IBOutlet weak var btnClosed: UIButton!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnOpenFrom: UIButton!
    
    @IBOutlet weak var btnOpenTo: UIButton!
    
    @IBOutlet weak var btnClosingFrom: UIButton!
    
    @IBOutlet weak var btnClosingTo: UIButton!
    
    @IBOutlet weak var txtFieldTown: UITextField!
    
    @IBOutlet weak var txtFieldCategory: UITextField!
    
    @IBOutlet var imgVwMonday: UIImageView!
    
    @IBOutlet var imgVwTuesday: UIImageView!
    
    @IBOutlet weak var vwTextPhoneNumber: UIView!
    
    @IBOutlet weak var vwTextEmail: UIView!
    
    @IBOutlet var imgVwWednesday: UIImageView!
    
    @IBOutlet var imgVwThursday: UIImageView!
    
    @IBOutlet var imgVwFriday: UIImageView!
    
    @IBOutlet var imgVwSaturday: UIImageView!
    
    @IBOutlet var imgVwSunday: UIImageView!
    
    @IBOutlet var btnMonday: UIButton!
    
    @IBOutlet var btnTuesday: UIButton!
    
    @IBOutlet var btnWednesday: UIButton!
    
    @IBOutlet var btnThursday: UIButton!
    
    @IBOutlet var btnFriday: UIButton!
    
    @IBOutlet var btnSaturday: UIButton!
    
    @IBOutlet var btnSunday: UIButton!
    
    @IBOutlet var btnCross: UIButton!
    
    @IBOutlet weak var btnApplyAll: UIButton!
    
    @IBOutlet var lblPackageName: UILabel!
    
    @IBOutlet var imgRightArrow: UIImageView!
    
    @IBOutlet var lblEndtime: UILabel!
    
    @IBOutlet var vwChange: UIView!
    
    weak var delegate: showTimePicker?
    
    var textField = UITextField()
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        if let myImage = UIImage(named: "right-arrow") {
            
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            
            imgRightArrow.image = tintableImage
            
            imgRightArrow.tintColor = UIColor(red: 77.0/255.0, green: 183.0/255.0, blue: 254.0/255.0, alpha: 1.0)
     
        }
        
        txtFldPhoneNumber.inputAccessoryView = toolbar
        
        txtFieldEmail.inputAccessoryView = toolbar
        
        txtFieldEmail.isUserInteractionEnabled = true
        
        txtFieldEmail.keyboardType = .emailAddress
        
        self.lblAddress.text = " No Address Selected"
        
        vwTextPhoneNumber.layer.borderWidth = 0.5
        
        vwTextPhoneNumber.layer.borderColor = UIColor.black.cgColor
        
        vwTextPhoneNumber.layer.cornerRadius = 5
        
        vwTown.layer.cornerRadius = 5
        
        vwTown.layer.borderWidth = 0.5
        
        vwTown.layer.borderColor = UIColor.black.cgColor
        
        vwTextEmail.layer.cornerRadius = 5
        
        vwTextEmail.layer.borderWidth = 0.5
        
        vwTextEmail.layer.borderColor = UIColor.black.cgColor
        
        vwCategory.layer.cornerRadius = 5
        
        vwCategory.layer.borderWidth = 0.5
        
        vwCategory.layer.borderColor = UIColor.black.cgColor
        
        viewAddress.layer.cornerRadius = 5
        
        viewAddress.layer.borderWidth = 0.5
        
        viewAddress.layer.borderColor = UIColor.black.cgColor
        
        self.txtFieldCategory.tintColor = UIColor.clear
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
           txtFieldEmail.isUserInteractionEnabled = false
            
        }
    }
    
    
    func setData(dict: [String: Any]) {
        
        if dict.isEmpty {
            return
        }
        
        self.txtFieldTown.text = CommonClass.sharedInstance.getTownName(strTown: (dict["town_id"] as? String)!, array: AppDataManager.sharedInstance.arrTowns )
        
        UserDefaults.standard.setSelectedTown(value: self.txtFieldTown.text!)
        
        let strSelectedCategory = dict["category_id"] as? String
        
        let arrSelectedCategory = strSelectedCategory?.components(separatedBy: ",")
        
        let arrCatName = CommonClass.sharedInstance.getCategoryArrayName(strCategory: arrSelectedCategory!, array: AppDataManager.sharedInstance.arrCategories as [AnyObject])
        
        self.txtFieldCategory.text = arrCatName.joined(separator: ",")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setupView"), object: nil)
        
        UserDefaults.standard.selectedCategory(value: self.txtFieldCategory.text!)
        
        self.txtFldPhoneNumber.text = dict["contact_no"] as? String
        
        if dict["address"] as? String != "" {
            
            self.lblAddress.text = dict["address"] as? String
        }
        else {
            self.lblAddress.text = "No Address Selected"
        }
        
        if dict["email"] as? String != "" {
            
            self.txtFieldEmail.text = dict["email"] as? String
        }
        else {
            
            let email = UserDefaults.standard.getEmail()
            
            self.txtFieldEmail.text = email
        }
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnShowPicker(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
            delegate?.showPopUpPremView()
            
        }
        else {
            delegate?.selectTime(selectedBtn: sender.tag)
        }
        
    }
    
    @IBAction func btnChangePackage(_ sender: UIButton) {
        
        delegate?.upgradePlanPopUp()
        
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
         
        self.endEditing(true)
        
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        
        delegate?.getContactNumber(str: txtFldPhoneNumber.text!)
        
        self.endEditing(true)
        
        
    }
    
    
    @IBAction func btnShowMap(_ sender: UIButton) {
        
        delegate?.openMap()
    }
    
    
    @IBAction func btnClosedAction(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" {
          
            delegate?.showPopUpPremView()
        }
        else {
            
            if sender.tag == 8 {
                
                sender.setBackgroundImage(#imageLiteral(resourceName: "iconClosed"), for: .normal)
                
                btnOpenFrom.isUserInteractionEnabled = false
                
                btnOpenTo.isUserInteractionEnabled = false
                
                btnClosingFrom.isUserInteractionEnabled = false
                
                btnClosingTo.isUserInteractionEnabled = false
                
                btnOpenFrom.alpha = 0.6
                
                btnOpenTo.alpha = 0.6
                
                btnClosingFrom.alpha = 0.6
                
                btnClosingTo.alpha = 0.6
                
                sender.tag = 9
                
                delegate?.checkClosedDay(dayClose: true)
            }
            else {
                
                sender.setBackgroundImage(#imageLiteral(resourceName: "unCheckBox"), for: .normal)
                
                btnOpenFrom.isUserInteractionEnabled = true
                
                btnOpenTo.isUserInteractionEnabled = true
                
                btnClosingFrom.isUserInteractionEnabled = true
                
                btnClosingTo.isUserInteractionEnabled = true
                
                btnOpenFrom.alpha = 1
                
                btnOpenTo.alpha = 1
                
                btnClosingFrom.alpha = 1
                
                btnClosingTo.alpha = 1
                
                sender.tag = 8
                
                delegate?.checkClosedDay(dayClose: false)
                
            }
            
        }
    }
    
    
    @IBAction func btnWeekDayClick(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" {
            
            delegate?.showPopUpPremView()
        }
        else {
            
            btnClosed.setBackgroundImage(#imageLiteral(resourceName: "unCheckBox"), for: .normal)
            
            btnClosed.tag = 8
            
            btnOpenFrom.isUserInteractionEnabled = true
            
            btnOpenTo.isUserInteractionEnabled = true
            
            btnClosingFrom.isUserInteractionEnabled = true
            
            btnClosingTo.isUserInteractionEnabled = true
            
            btnOpenFrom.alpha = 1
            
            btnOpenTo.alpha = 1
            
            btnClosingFrom.alpha = 1
            
            btnClosingTo.alpha = 1
            
            sender .setTitleColor(UIColor.red, for: .selected)
            
            switch sender.tag {
                
            case 0:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.white, for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 1:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.white, for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 2:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.white, for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 3:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.white, for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 4:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.white, for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 5:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.white, for: .normal)
                
                btnSunday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
            case 6:
                
                imgVwMonday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwTuesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwWednesday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwThursday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwFriday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSaturday.image = #imageLiteral(resourceName: "weekDaysGrey")
                
                imgVwSunday.image = #imageLiteral(resourceName: "weekDaysBlue")
                
                btnMonday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnTuesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnWednesday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnThursday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnFriday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSaturday.setTitleColor(UIColor.weekDayBgColor(), for: .normal)
                
                btnSunday.setTitleColor(UIColor.white, for: .normal)
                
            default:
                
                break
            }
            
            delegate?.selectWeekDay(tag: sender.tag)
        }
     
    }
    
    
    @IBAction func btnApplyToAll(_ sender: UIButton) {
        
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" {
            
            delegate?.showPopUpPremView()
        }
        else {
            
            if btnApplyAll.tag == 200 {
                
                sender.setImage(#imageLiteral(resourceName: "checkApplyAll"), for: .normal)
                
                delegate?.applyTimeToAll(isApply: true)
                
                btnApplyAll.tag = 201
                
            }
            else {
                
                sender.setImage(#imageLiteral(resourceName: "checkApplyAll"), for: .normal)
                
                delegate?.applyTimeToAll(isApply: false)
                
                btnApplyAll.tag = 200
            }
            
        }
       
    }
    
    
//    @IBAction func btnCross(_ sender: Any) {
//
//        if btnCross.tag == 300 {
//
//            btnClosingFrom.isUserInteractionEnabled = false
//
//            btnClosingTo.isUserInteractionEnabled = false
//
//            btnClosingFrom.alpha = 0.6
//
//            btnClosingTo.alpha = 0.6
//
//            delegate?.checkClosingHours(closeHour: true)
//
//            btnCross.tag = 301
//
//        }
//        else{
//
//            btnClosingFrom.isUserInteractionEnabled = true
//
//            btnClosingTo.isUserInteractionEnabled = true
//
//            btnClosingFrom.alpha = 1.0
//
//            btnClosingTo.alpha = 1.0
//
//            delegate?.checkClosingHours(closeHour: false)
//
//            btnCross.tag = 300
//        }
//    }
}

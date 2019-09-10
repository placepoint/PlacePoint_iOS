//
//  PickerViewCountriesList.swift
//  MRTChat
//
//  ""s on 26/04/18.
//  Copyright © 2018 . All rights reserved.
//

protocol MyPickerViewProtocol {
    
    func myPickerDidSelectRow(str:String,btnTag: Int)
}

import UIKit
import CoreTelephony

class PickerViewList: UIView {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate : MyPickerViewProtocol?
    
    var btnTag = Int()
    
    var strBtnTitle = String()
    
    //MARK:- Load Picker View Data
    func loadPickerView(btntagId: Int, parentVC: UIViewController, btnText: String)  {
        
        btnTag = btntagId
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "h:mm a"
        
        if let date = dateformatter.date(from: btnText) {
            
            datePicker.date = date
        }
        
        self.strBtnTitle = btnText
        
        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
            
            self.frame = window.bounds
            
            window.addSubview(self)
            
        }
        else {
            
            self.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
            
            parentVC.view.addSubview(self)
        }
        
    }
    
    
    @IBAction func pickerDateChanged(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "h:mm a"
       
       let strDate = formatter.string(from: sender.date)
        
        if strDate.contains("a.m."){
            
             self.strBtnTitle = strDate.replacingOccurrences(of: "a.m.", with: "AM", options: NSString.CompareOptions.literal, range: nil)
            
        }
        else if strDate.contains("p.m."){
            
            self.strBtnTitle = strDate.replacingOccurrences(of: "p.m.", with: "PM", options: NSString.CompareOptions.literal, range: nil)
        }
        else {
            
            self.strBtnTitle = strDate
        }
        
    }
    
    
    //MARK:- Button Action
    @IBAction func btnDoneAction(_ sender: UIBarButtonItem) {
        
        delegate?.myPickerDidSelectRow(str: self.strBtnTitle, btnTag: self.btnTag)
        
        self.removeFromSuperview()
    }
    
    
    @IBAction func btnCancelAction(_ sender: UIBarButtonItem) {
        
        self.removeFromSuperview()
    }
    
}

//
//  SchedulePostCell.swift
//  PlacePoint
//PlacePoint Workspace Group
//  Created by Mac on 27/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol SchedulePicker: class{
    
    func openSchedulePicker(isDay:Bool,IsTime:Bool)
    
    func postNow()
}

class ScheduleAddPostCell: UITableViewCell {

    @IBOutlet var vwSchedulePostTime: UIView!
    
    @IBOutlet var viewScheduleforBtn: UIView!
    
    @IBOutlet var viewAddPostNow: UIView!
    
    @IBOutlet var heightConstrainvwSchedulePost: NSLayoutConstraint!
    
    @IBOutlet var heightConstvwScheduleBtn: NSLayoutConstraint!
    
    @IBOutlet var heightConstVwAddPost: NSLayoutConstraint!
    
    @IBOutlet weak var lblSchedule: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet var viewSelectDays: UIView!
    
    @IBOutlet var viewSelectTime: UIView!
    
    
    @IBOutlet var btnPostThis: UIButton!
    
    weak var delegate: SchedulePicker?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        viewScheduleforBtn.layer.borderWidth = 0.5
        
        viewScheduleforBtn.layer.cornerRadius = 5
        
        viewScheduleforBtn.layer.borderColor = UIColor.black.cgColor
        
        viewSelectDays.layer.borderWidth = 0.5
        
        viewSelectDays.layer.cornerRadius = 5
        
        viewSelectDays.layer.borderColor = UIColor.black.cgColor
        
        viewSelectTime.layer.borderWidth = 0.5
        
        viewSelectTime.layer.cornerRadius = 5
        
        viewSelectTime.layer.borderColor = UIColor.black.cgColor
    }
    

    @IBAction func btnSchedule(_ sender: UIButton) {
        
        delegate?.openSchedulePicker(isDay: false, IsTime: false)
    }
    
    
    @IBAction func btnSelectDay(_ sender: Any) {
        
        delegate?.openSchedulePicker(isDay: true, IsTime: false)
    }
    
    
    @IBAction func btnSelectTime(_ sender: UIButton) {
        
        delegate?.openSchedulePicker(isDay: false, IsTime: true)
        
    }
    
    @IBAction func btnPostNow(_ sender: UIButton) {
        
        delegate?.postNow()
    }
    
    
}

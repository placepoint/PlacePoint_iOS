//
//  FlashPostTVcell.swift
//  PlacePoint
//
//   on 23/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

protocol FlashPostTVcellDelegate {
    
    func FlashActionDelegate()
}


import UIKit


class FlashPostTVcell: UITableViewCell {

//    @IBOutlet weak var switchFlashPost: UISwitch!
    
    @IBOutlet weak var btnFlashPostClicked: UIButton!
    
    @IBOutlet weak var txtFldOffersTobeRedeemed: UITextField!
    
    @IBOutlet weak var btnOffers: UIButton!
    
    @IBOutlet weak var btnPersons: UIButton!
    
    @IBOutlet weak var viewContainedContent: UIView!
    
    @IBOutlet weak var btnExpiryTime: UIButton!
    
    @IBOutlet weak var btnExpiryDate: UIButton!
    
    var delegate: FlashPostTVcellDelegate!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addDoneButtonOnKeyboard(sender: txtFldOffersTobeRedeemed)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    @IBAction func btnFlashPostAction(_ sender: UIButton) {
//
//        if !boolScheduleCell {
//
//            boolScheduleCell = true
//        }
//        else {
//
//            boolScheduleCell = false
//        }
//        delegate.btnFlashActionDelegate()
//    }
    
        
    func addDoneButtonOnKeyboard(sender: UITextField) {
            
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
            
            let items = [flexSpace, done]
            
            doneToolbar.items = items
            
            doneToolbar.sizeToFit()
            
            sender.inputAccessoryView = doneToolbar
        }
    
    
        @objc func doneButtonAction() {
            
            delegate.FlashActionDelegate()
        }
        
}

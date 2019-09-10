//
//  BusinessTopView.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol  ShowImagePicker: class {
    
    func showImagePicker()
    
    func showPopUp()
}

class BusinessTopView: UIView {
    
    @IBOutlet var vwTextFld: UIView!
    
    @IBOutlet weak var textFieldBusinessName: UITextField!
    
    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var lblDescriptionPlaceholder: UILabel!
    
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var viewTextViewBg: UIView!
    
    
    weak var delegate: ShowImagePicker?
    
    
    //MARK: Life Cycle
    override func awakeFromNib() {
        
        vwTextFld.layer.borderWidth = 0.5
        
        vwTextFld.layer.borderColor = UIColor.black.cgColor
        
        vwTextFld.layer.cornerRadius = 5
        
        viewTextViewBg.layer.borderColor = UIColor.lightGray.cgColor
        
        viewTextViewBg.layer.borderWidth = 1
        
        viewTextViewBg.clipsToBounds = true
        
    }
    
    
    //MARK: UIActions
    @IBAction func btnEditAction(_ sender: UIButton) {
        
        delegate?.showImagePicker()
        
    }
    
    
    func setData(dict: [String: Any]) {
        
        if dict.isEmpty {
            return
        }
        
        self.textFieldBusinessName.text = UserDefaults.standard.getBusinessName()
        
        let strUrl = dict["cover_image"] as? String
        
        if strUrl != "" {
            
            let url = URL(string: strUrl as! String)!
            
            self.businessImage.kf.indicatorType = .activity
            
            (self.businessImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .gray
            
            self.businessImage.kf.setImage(with: url ,
                                           placeholder: #imageLiteral(resourceName: "placeholder"),
                                           options: [.transition(ImageTransition.fade(1))],
                                           progressBlock: { receivedSize, totalSize in
            },
                                           completionHandler: { image, error, cacheType, imageURL in
            })
        }
        
        if dict["description"] as? String != "" {
            
            self.lblDescriptionPlaceholder.isHidden = true
            
            self.textView.text = dict["description"] as? String
            
            self.lblCharacterCount.text = String(format: "%d/1000", self.textView.text.count)
            
        }
        else{
            
            self.lblDescriptionPlaceholder.text = "Add Business Description"
            
        }
        
    }
}


//MARK: TextField Delegate
extension BusinessTopView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free" {
            
            textView.resignFirstResponder()
        
           delegate?.showPopUp()
        }
        
        else {
            
            lblDescriptionPlaceholder.isHidden = true
        }
        
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        
        if text == "\n" {

            textView.text = textView.text + "\n"

        } else {

            lblCharacterCount.text = String(format: "%d/1000", textView.text.count)

            return textView.text.characters.count +  (text.characters.count - range.length) <= 1000

        }
        
        return true
        
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        textView.resignFirstResponder()

        return true
    }
}

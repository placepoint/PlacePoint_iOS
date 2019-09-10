//
//  AddPostHeader.swift
//  PlacePoint
//
//  Created by Mac on 11/07/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

protocol OpenImageProtocol: class {
    
    func openCamera()
    
    func openPhotoLibrary()
    
    func addYouTubeLink()
    
    func removeVideoLink()
    
}

class AddPostHeader: UIView {
    
    @IBOutlet weak var lblVideo: UILabel!
    @IBOutlet weak var btnRemoveVideo: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var vwTextViewBd: UIView!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var lblCharacterCount: UILabel!
    
    @IBOutlet weak var vwtextUrl: UIView!
    
    @IBOutlet weak var txtFieldUrl: UITextField!
    
    @IBOutlet var vwChooseCategory: UIView!
    
    @IBOutlet var lblChooseCategory: UILabel!
    
    weak var delegate: OpenImageProtocol?
    
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        lblUserName.text = UserDefaults.standard.getBusinessName()
        
    }
    
    
    //MARK: Set Data
    func setData(dict: [String: Any]) {
        
        if dict.isEmpty {
            
            self.txtView.text = ""
            return
        }
        
        self.lblUserName.text = dict["title"] as? String
        
        self.txtView.text = dict["description"] as? String
        
        self.lblPlaceholder.isHidden = true
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnCamera(_ sender: UIButton) {
        
        delegate?.openCamera()
    }
    
    
    @IBAction func btnPhotoGallery(_ sender: UIButton) {
        
        delegate?.openPhotoLibrary()
    }
    
    
    @IBAction func btnYoutube(_ sender: UIButton) {
        
        delegate?.addYouTubeLink()
        
    }
    
    @IBAction func btnRemoveVideoLink(_ sender: UIButton) {
        
        delegate?.removeVideoLink()
    }
}

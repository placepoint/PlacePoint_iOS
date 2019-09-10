//
//  BusinessContentTableCell.swift
//  PlacePoint
//
//  Created by Mac on 05/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

protocol OpenPhotos: class {
    
    func openCameraPhoto()
    
    func openLibrary()
    
    func openYoutube()
    
    func collectionHaveNoImage()
    
    func showpremiumPopUp()
    
}

class BusinessContentTableCell: UITableViewCell {
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var txtieldHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldUrl: UITextField!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var btnGallery: UIButton!
    
    @IBOutlet weak var btnYoutube: UIButton!
    
    @IBOutlet weak var lblBusinessContent: UILabel!
    
    
    weak var delegate: OpenPhotos?
    
    var imageSelected = UIImage()
    
    var cellIndex: IndexPath?
    
    var dictCreatedBusinessImages = [String: Any]()
    
    var isGalleryFirstSelected: Bool = false
    
    
    //MARK: - LIfe Cycle
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let nib = UINib(nibName: "ViewImageCollectionCell", bundle: nil)
        
        self.collectionImages.register(nib, forCellWithReuseIdentifier: "ViewImageCollectionCell")
        
        self.collectionImages.isHidden = true
        
        self.textFieldUrl.isHidden = true
        
        textFieldUrl.layer.borderWidth = 0.5
        
        textFieldUrl.layer.borderColor = UIColor.black.cgColor
        
        textFieldUrl.layer.cornerRadius = 5
        
    }
    
    
    //MARK: - UIActions
    @IBAction func btnCameraAction(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
            delegate?.showpremiumPopUp()
            
        }
        else {
            
            self.textFieldUrl.isHidden = false
            
            self.txtieldHeightConstrain.constant = 35
            
            delegate?.openCameraPhoto()
        }
        
    }
    
    
    @IBAction func btnYoutube(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
           delegate?.showpremiumPopUp()
            
        }
        else {
            
            self.isGalleryFirstSelected = true
            
            self.textFieldUrl.isHidden = false
            
            self.txtieldHeightConstrain.constant = 35
            
            delegate?.openYoutube()
        }
        
    }
    
    
    @IBAction func btnGalleryaction(_ sender: UIButton) {
        
        let selectedBusinessType = UserDefaults.standard.getBusinessUserType()
        
        if selectedBusinessType == "Free"{
            
          delegate?.showpremiumPopUp()
            
        }
        else {
            
            if dictCreatedBusinessImages["video_link"] != nil {
                
                self.textFieldUrl.isHidden = false
                
                self.txtieldHeightConstrain.constant = 35
                
            }
            else if isGalleryFirstSelected == true {
                
                self.textFieldUrl.isHidden = false
                
                self.txtieldHeightConstrain.constant = 35
            }
            else {
                
                self.textFieldUrl.isHidden = true
                
                self.txtieldHeightConstrain.constant = 0
            }
            
            delegate?.openLibrary()
        }
        
    }
    
    
    func setData(dict: [String: Any]) {
        
        if dict.isEmpty {
            return
        }
        
        if isYoutubeBtnSelected == true {
            
            self.textFieldUrl.isHidden = false
            
        }
        
        let strVideoLink = dict["video_link"]  as? String
        
        if strVideoLink != "" && strVideoLink != nil {
            
            isYoutubeBtnSelected  = true
            
            self.textFieldUrl.isHidden = false
            
            self.textFieldUrl.text = dict["video_link"] as? String
            
        }
        else {
            
            if isYoutubeBtnSelected == false{
                
                self.textFieldUrl.isHidden = true
            }
        }
        
        if isCollectionHaveImage == false {
            
            self.collectionImages.isHidden = true
        }
        
        if arrBusinessImages.count > 0 {
            
            noImage = false
            
            isGalleryFirstSelected = true
            
            isCollectionHaveImage = true
            
            self.reloadCollection(arrayImage: arrBusinessImages)
        }
    }
    
    
    //MARK: - Reload Collection
    func reloadCollection(arrayImage: [AnyObject]){
        
        self.collectionImages.isHidden = false
        
        collectionImages.delegate = self
        
        collectionImages.dataSource = self
        
        collectionImages.reloadData()
    }
}


//MARK: - CollectionView Delegate and DataSource
extension BusinessContentTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if arrBusinessImages.count > 0 {
            
            return arrBusinessImages.count
        }
        
        return 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewImageCollectionCell", for: indexPath) as? ViewImageCollectionCell else {
            fatalError()
        }
        
        cell.delegate = self
        
        cell.btnDelete.tag = indexPath.row
        
        self.cellIndex = indexPath
        
        cell.imgCollection.isHidden = true
        
        cell.setData(arr: arrBusinessImages, index: indexPath.row)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if arrBusinessImages.count > 0 {
            
            return CGSize(width: 80, height: 80)
        }
            
        else {
            
            return CGSize(width: 0, height: 0)
            
        }
    }
}


//MARK: Adopt Protocol
extension BusinessContentTableCell: DeleteCell {
    
    func deleteSavedImage(selectedIndex: Int) {
        
        if arrBusinessImages.count > 0 {
            
            arrBusinessImages.remove(at: selectedIndex)
            
            collectionImages.reloadData()
            
            if arrBusinessImages.count == 0 {
                
                noImage = true
                
                isCollectionHaveImage = false
                
                delegate?.collectionHaveNoImage()
                
            }
        }
    }
}

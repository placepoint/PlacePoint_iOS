//
//  Extension+AddPost.swift
//  PlacePoint
//
//  Created by Mac on 19/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit
import PhotoCropEditor

//MARK: TextView Delegates
extension AddPostVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        headerView.lblPlaceholder.isHidden = true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            textView.resignFirstResponder()
            
            return true
        }
        else {
            
            headerView.lblCharacterCount.text = String(format: "%d/1000", textView.text.count)
            
            return textView.text.characters.count +  (text.characters.count - range.length) <= 1000
        }
        
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()
        
        return true
    }
    
}


//MARK: TextField Delegates
extension AddPostVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.keyBoardNotify()
    }
    
    
    //MARK: Keyboard Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        
        self.view.frame.origin.y = -150
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if UIScreen.main.bounds.size.height == 812 {
            
            self.view.frame.origin.y = 20
        }
        else {
            
            self.view.frame.origin.y = 0
        }
    }
}


//MARK: ImagePicker Controller and NavigationControler Delegateas
extension AddPostVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.selectedImage = image
            
            self.imgURl = ""
            
            self.editDict.removeAll()
            
            self.isImageSend = false
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        self.openEditor()
    }
}


//MARK: - CropViewController Delegate
extension AddPostVC: CropViewControllerDelegate {
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        
        print("Finish cropping")
    }
    
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        
        controller.dismiss(animated: true, completion: nil)
        
        self.croppedImage = image
        
        let getImgViewHeight = 173
        
        let getImgViewWidth = 277
        
        let image = self.resizeImage(image: self.croppedImage, targetSize: CGSize(width: getImgViewWidth, height: getImgViewHeight))
        
        let ratio = image.size.width / image.size.height
        
        let newHeight = 277 / ratio
        
        self.imageHeight = newHeight
        
        tblViewAddPost.reloadData()
        
    }
    
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

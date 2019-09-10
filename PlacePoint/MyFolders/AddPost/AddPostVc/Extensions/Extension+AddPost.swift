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
import Alamofire
//MARK: TextView Delegates
extension AddPostVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        headerView.lblPlaceholder.isHidden = true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
//            textView.resignFirstResponder()
            
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
        
        if textField == headerView.txtFieldUrl {
            
            if let getUrlString = textField.text?.contains("http"), getUrlString == true {
                
                self.deleteImage()
                self.isImageSend = false
            }
        }
        
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
        
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            
            if mediaType  == "public.image" {
                
                self.removeVideoLink()
               
                isVideoSend = false
               
                if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                   
                    let diceRoll = Int(arc4random_uniform(1000) + 1)
                    
                    self.selectedImage = image
                    
                    self.imgURl = ""
                    
                    self.editDict.removeAll()
                    
                    self.isImageSend = false
                    
                    self.isfirstYoutubeSelected = false
                    
                    headerView.vwtextUrl.isHidden = false
                    
                    headerView.txtFieldUrl.isHidden = true
                    headerView.lblVideo.isHidden = false
                    headerView.lblVideo.text = String("img\(diceRoll).jpg")
                    headerView.btnRemoveVideo.isHidden = false
                }
                
                picker.dismiss(animated: true, completion: nil)
                
                self.openEditor()
            }
            
            if mediaType == "public.movie" {
                
                if headerView.txtFieldUrl.text == "" {
                    
                    self.deleteImage()
                    self.isImageSend = false
                    
                    let urlSelectedVideo = info[UIImagePickerControllerMediaURL] as? URL
                    
                    let data = try! Data.init(contentsOf: urlSelectedVideo!)
                    
                    let Size = Float(Double(data.count)/1024/1024)
                    
                    if Size <= 100.00 {
                        
                        isVideoSend = true
                        
                        self.postVideoUrl = urlSelectedVideo
                        
                        let fileName = urlSelectedVideo!.lastPathComponent
                        
                        self.isfirstYoutubeSelected = false
                        
                        headerView.vwtextUrl.isHidden = false
                        
                        headerView.txtFieldUrl.isHidden = true
                        headerView.lblVideo.isHidden = false
                        headerView.lblVideo.text = fileName
                        headerView.btnRemoveVideo.isHidden = false
                        picker.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        
                         picker.dismiss(animated: true, completion: nil)
                        let alert = UIAlertController(title: "", message: "Unable to upload video more than 100 MB", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            
                        }))
                        
                        self.present(alert, animated: true, completion: {
                           
                        })
                    }
                    
                    
                   
                    
                } else {
                    
                     picker.dismiss(animated: true, completion: nil)
                    
                    let alert = UIAlertController(title: "", message: "Please remove url first", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        print("User click Approve button")
                    }))
                    
                    self.present(alert, animated: true, completion: {
                        print("completion block")
                    })
                    
      
                }
              
                
            }
        }
        
        
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
        
        let getImgViewHeight = 573
        
        let getImgViewWidth = 277
        
        let image = self.resizeImage(image: self.croppedImage, targetSize: CGSize(width: getImgViewWidth, height: getImgViewHeight))
        
        let ratio = image.size.width / image.size.height
        
        let newHeight = 377 / ratio
        
        self.imageHeight = newHeight
        
        tblViewAddPost.reloadData()
        
    }
    
    
    func cropViewControllerDidCancel(_ controller: CropViewController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}

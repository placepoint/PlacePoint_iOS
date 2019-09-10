//
//  FeedManager.swift
//  PlacePoint
//
//  Created by Mac on 08/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Alamofire

class FeedManager: NSObject {
    
    static let sharedInstance : FeedManager = {
        
        let instance = FeedManager()
        
        return instance
    }()
    
    private override init() {}
    
    var arrFeed = [AnyObject]()
    
    var arrSingleBusiness = [AnyObject]()
    
    var dictParams = [String: Any]()
    
    var imgPost = UIImage()
    
    var url  = String()
    
    var arrSelectedBusiness = [AnyObject]()
    
    var arrImages = [UIImage]()
    
    var arrSchedulePost = [AnyObject]()
    
    
    //MARK:- Get Feed Details
    func getFeedDetails(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
    
        WebService.sharedInstance.postMethodWithParams(strURL: "getFeeds", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
   
    
    //MARK:- Get Feed Details
    func getPackageDetails(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getPackageDetails", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    func upgardePackage(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "upgrade", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    // MARK: Add Post
    func addPostWithImage(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParamsAndImage(strURL: "addPost", dictParams: dictParams as NSDictionary, image: imgPost, imagesKey: "images", imageName: "image1", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        } , failue:  { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func addPostWithoutImage(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "addPost", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        } , failure:  { (strError :String) in
            
            failure(strError)
        })
        
    }
    

    func deleteSchedulePost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "delete", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        } , failure:  { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func editSchedulePostWithImage(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParamsAndImage(strURL: "editSchedulePost", dictParams: dictParams as NSDictionary, image: imgPost, imagesKey: "images", imageName: "image1", completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        } , failue:  { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func editScheduleWithoutImage(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "editSchedulePost", dict: dictParams as NSDictionary, completionHandler: { (dictResponse) in
            
            completionHandler(dictResponse)
            
        } , failure:  { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    func getBusinessDetails(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getBusinessDetails", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            let strStatus = dictResponse["status"] as? String
            
            
            
            if strStatus == "true" {
                
                let arrData = dictResponse["data"] as? [AnyObject]
                
                self.arrSelectedBusiness = arrData!
            }
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
    }
    
    
    
    //MARK: Get Single Business
    func getScheduledPost(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getSchedulePost", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                let arrData = dictResponse["data"] as? [AnyObject]
                
                self.arrSchedulePost = (arrData as? [AnyObject])!
                
            }
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    //MARK: Get Single Business
    func getSingleBusinessDetails(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        WebService.sharedInstance.postMethodWithParams(strURL: "getSingleBusiness", dict: dictParams as NSDictionary, completionHandler: { (dictResponse: NSDictionary) in
            
            let strStatus = dictResponse["status"] as? String
            
            if strStatus == "true" {
                
                let arrData = dictResponse["data"] as? [AnyObject]
                
                self.arrSingleBusiness = arrData as! [AnyObject]
            }
            
            completionHandler(dictResponse)
            
        }, failure: { (strError :String) in
            
            failure(strError)
        })
        
    }
    
    
    //MARK: Update BusinessPage
    func postBusinessDetails(completionHandler:@escaping (_ dict :NSDictionary) -> Void, failure:@escaping (_ error :String) -> Void) -> Void {
        
        let params = dictParams
        
        url = baseURL+"updateBusinessPage"
        
        Alamofire.upload(multipartFormData:
            {
                (multipartFormData) in
                
                for  i in 0..<self.arrImages.count {
                    
                    let filePathKey = "images_\(i)"
                    
                    if let img = self.arrImages[i] as? UIImage {
                        
                        if let jpegImage = UIImageJPEGRepresentation(img, 0.4){
                            
                            multipartFormData.append(jpegImage, withName: filePathKey, fileName: "file.jpeg", mimeType: "image/jpeg")
                        }
                    }
                }
                
                for (key, value) in params {
                    
                    if key as! String == "cover_image" {
                        
                        if let jpegImage = UIImageJPEGRepresentation(self.imgPost, 0.4){
                            
                            multipartFormData.append(jpegImage, withName: "cover_image", fileName: "file.jpeg", mimeType: "image/jpeg")
                        }
                    }
                    else {
                        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                    }
                }
        }, to:baseURL+"updateBusinessPage",headers:nil)
        { (result) in
            switch result {
                
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    
                })
                upload.responseJSON
                    { response in
                        
                        if response.result.value != nil {
                            
                            completionHandler(response.result.value as! NSDictionary)
                        }
                }
            case .failure( _):
                
                
                break
            }
        }
    }
}

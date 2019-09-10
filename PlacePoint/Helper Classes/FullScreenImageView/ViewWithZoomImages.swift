//
//  ViewWithZoomImages.swift
//  PocketBrokerConsumer
//
//   Technologies on 21/02/17.
//  Copyright © 2017  Technologies. All rights reserved.
//


import UIKit
import Photos


class ViewWithZoomImages: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionViewForZoomImages: UICollectionView!
    
    var arrImageWithContents = [AnyObject]()
    
    var image = UIImage()
    var imageUrl = String()
    static let albumName = "Album Name"
    
//    static let sharedInstance = CustomPhotoAlbum()
    
    var assetCollection: PHAssetCollection!
    
    func createUI(arrImageWithContents: [AnyObject], index: Int) -> Void {
        
        self.frame = CGRect(x: 0, y: 0, width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
        
        self.arrImageWithContents = arrImageWithContents
        
        self.collectionViewForZoomImages!.register(UINib(nibName: "ZoomImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "zoomImagesCollectionViewCell")
        
        self.collectionViewForZoomImages.delegate = self

        self.collectionViewForZoomImages.dataSource =  self
        
        self.collectionViewForZoomImages.reloadData()
        
        self.collectionViewForZoomImages.contentOffset = CGPoint(x: DeviceInfo.TheCurrentDeviceWidth * CGFloat(index), y: 0)
        
//        if let assetCollection = fetchAssetCollectionForAlbum() {
//            self.assetCollection = assetCollection
//            return
//        }
//        
//        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
//            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
//                ()
//            })
//        }
//        
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            self.createAlbum()
//        } else {
//            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
//        }
        
        
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        
        while((topVC!.presentedViewController) != nil) {
            
            topVC = topVC!.presentedViewController
        }
        
        if let error = error {
            
             self.isUserInteractionEnabled = true
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
             self.isUserInteractionEnabled = true
            topVC?.present(ac, animated: true, completion: nil)
            
           
        } else {
            
             self.isUserInteractionEnabled = true
            
//            self.makeToast("Image Saved.", duration: 2.0, position: .bottom)
//            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .default))
//              topVC?.present(ac, animated: true, completion: nil)
            
        }
    }
    
    
    
    @IBAction func btnSaveAction(_ sender: UIButton) {
        
         self.isUserInteractionEnabled = false
        
         UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
//        if assetCollection == nil {
//
//            return
//
//        }
//
//        PHPhotoLibrary.shared().performChanges({
//            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
//            let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset
//            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
//            let enumeration: NSArray = [assetPlaceHolder!]
//            albumChangeRequest!.addAssets(enumeration)
//
//        }, completionHandler: nil)
        
        
    }
//
//    func createAlbum() {
//        PHPhotoLibrary.shared().performChanges({
//            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: ViewWithZoomImages.albumName)   // create an asset collection with the album name
//        }) { success, error in
//            if success {
//                self.assetCollection = self.fetchAssetCollectionForAlbum()
//            } else {
//                print("error \(error)")
//            }
//        }
//    }
    
    
//    func fetchAssetCollectionForAlbum() -> PHAssetCollection? {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "title = %@", ViewWithZoomImages.albumName)
//        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
//
//        if let _: AnyObject = collection.firstObject {
//            return collection.firstObject
//        }
//        return nil
//    }
    
    
//    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
//        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
//            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
//            print("trying again to create the album")
//            self.createAlbum()
//        } else {
//            print("should really prompt the user to let them know it's failed")
//        }
//    }
//
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        // choose a name for your image
//        let fileName = "image.jpg"
//        // create the destination file url to save your image
//        let fileURL = documentsDirectory.appendingPathComponent(fileName)
//        // get your UIImage jpeg data representation and check if the destination file url already exists
//        if let data = UIImageJPEGRepresentation(image, 1.0),
//            !FileManager.default.fileExists(atPath: fileURL.path) {
//            do {
//                // writes the image data to disk
//                try data.write(to: fileURL)
//                print("file saved")
//            } catch {
//                print("error saving file:", error)
//            }
//        }
//        let newImage = UIImage(contentsOfFile: imageURL.path)!
        //aftersave.image = newImage
//        aftersave.image = newImage
        
//        let documentsPath1 = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//
//        let logsPath = documentsPath1.appendingPathComponent("data")
//
//        print(logsPath!)
//
//        do {
//
//            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
//
//        } catch let error as NSError {
//
//            NSLog("Unable to create directory \(error.debugDescription)")
//
//        }
        
        
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
       
   
    
    @IBAction func btnCrossAction(_ sender: UIButton) {
        
        self.removeFromSuperview()
    }
    
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "zoomImagesCollectionViewCell", for: indexPath as IndexPath) as! ZoomImagesCollectionViewCell
      
        cell.setCellInfo(imgReady: "", strImageUrl: imageUrl, strImageTitle: "", image:image)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: DeviceInfo.TheCurrentDeviceWidth, height: DeviceInfo.TheCurrentDeviceHeight)
    }
    
}

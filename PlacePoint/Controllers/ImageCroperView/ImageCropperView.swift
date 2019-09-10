//
//  ImageCropperView.swift
//  PlacePoint
//
//  Created by Mac on 06/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Photos

class ImageCropperView: UIViewController {
    
    @IBOutlet weak var collectionImages: UICollectionView!
    
    @IBOutlet weak var scrollView: FAScrollView!
    
    @IBOutlet weak var scrollContainerView: UIView!
    
    
    var imageViewToDrag: UIImageView!
    
    var indexPathOfImageViewToDrag: IndexPath!
    
    var selectedImages: [UIImage] = []
    
    var arrCroppedImage: [UIImage] = []
    
    var index: Int?
    
    var currentIndex: Int?
    
    lazy var albumView  = FSAlbumView.instance()
    
    fileprivate var imageManager: PHCachingImageManager?
    
    var phAsset: PHAsset!
    
    var selectedAssets: [PHAsset] = []
    
    let cellWidth = ((UIScreen.main.bounds.size.width)/3)-1
    
    var croppedImg = UIImage()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.frame.size.width = self.scrollContainerView.frame.size.width
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        let nib = UINib(nibName: "ViewImageCollectionCell", bundle: nil)
        
        self.collectionImages.register(nib, forCellWithReuseIdentifier: "ViewImageCollectionCell")
        
        self.displayImageInScrollView(image:selectedImages[0])
        
        currentIndex = 0
        
        collectionImages.delegate = self
        
        collectionImages.dataSource = self
    }
    
    
    private func captureVisibleRect() -> UIImage{
        
        var croprect = CGRect.zero
        
        let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
        
        let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
        
        croprect.origin.x = scrollView.contentOffset.x * xOffset;
        
        croprect.origin.y = scrollView.contentOffset.y * yOffset;
        
        let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
        
        let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
        
        croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
        
        croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
        
        let toCropImage = scrollView.imageView.image?.fixImageOrientation()
        
        let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
        
        croppedImg = UIImage(cgImage: cr!)
        
        selectedImages[currentIndex!] = croppedImg
        
        collectionImages.reloadData()
        
        return croppedImg
        
    }
    
    
    private func isSquareImage() -> Bool {
        
        let image = scrollView.imageToDisplay
        
        if image?.size.width == image?.size.height { return true }
            
        else { return false }
    }
    
    
    func replicate(_ image:UIImage) -> UIImage? {
        
        guard let cgImage = image.cgImage?.copy() else {
            
            return nil
        }
        
        return UIImage(cgImage: cgImage,
                       scale: image.scale,
                       orientation: image.imageOrientation)
    }
    
    
    func handleLongPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.location(in: view)
        
        if recognizer.state == .began {
            
            let cell: FAImageCell = (recognizer.view as? FAImageCell)!
            
            indexPathOfImageViewToDrag = collectionImages.indexPath(for: cell)
            
            imageViewToDrag = UIImageView(image: replicate(cell.imageView.image!))
            
            imageViewToDrag.frame = CGRect(x: location.x - cellWidth/2, y: location.y - cellWidth/2, width: cellWidth, height: cellWidth)
            
            view.addSubview(imageViewToDrag!)
            
            view.bringSubview(toFront: imageViewToDrag!)
            
        }
        else if recognizer.state == .ended {
            
            if scrollView.frame.contains(location) {
                
                collectionImages.selectItem(at: indexPathOfImageViewToDrag, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredVertically)
                
                                selectImageFromAssetAtIndex(index: indexPathOfImageViewToDrag.item)
            }
            
            imageViewToDrag.removeFromSuperview()
            
            imageViewToDrag = nil
            
            indexPathOfImageViewToDrag = nil
        }
        else {
            
            imageViewToDrag.center = location
        }
    }
    
    
        func selectImageFromAssetAtIndex(index:NSInteger){
    
        }
    
    //MARK: UIActions
    
    @IBAction func btnCancel(_ sender: Any) {
        
        if savedImages.count == 0 {
            
            noImage = true
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        self.captureVisibleRect()
        
        arrCheckMaxImages.removeAll()
        
        
        for i in 0..<selectedImages.count {
            
            arrCheckMaxImages.append(selectedImages[i])
        }
        
        for i in 0..<arrCheckMaxImages.count {
            
            savedImages.append(arrCheckMaxImages[i])
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setImageData"), object: nil)
        
        
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - CollectionView Delegate and Data Source
extension ImageCropperView: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if selectedImages.isEmpty == true {
            
            return 1
        }
        else{
            return selectedImages.count
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewImageCollectionCell", for: indexPath) as? ViewImageCollectionCell else {
            fatalError()
        }
        
        cell.delegate = self
        
        cell.btnDelete.tag = indexPath.row
        
        if selectedImages.isEmpty == false {
            
            cell.imgCollection.image = selectedImages[indexPath.row]
            
        }
        
        return cell
    }
    
    
    func displayImageInScrollView(image:UIImage) {
        
        self.scrollView.imageToDisplay = image
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.captureVisibleRect()
        
        self.index = indexPath.row
        
        currentIndex = indexPath.row
        
        self.displayImageInScrollView(image:selectedImages[indexPath.row])
        
    }
}


//MARK: Adopt Protocol
extension ImageCropperView: DeleteCell {
    
    func selectedImage(selectedIndex: Int) {
        
        print(selectedIndex)
        
    }
    
    
    func deleteSavedImage(selectedIndex: Int) {
        
        selectedImages.remove(at: selectedIndex)
        
        collectionImages.reloadData()
        
        if selectedImages.isEmpty == false {
            
            self.displayImageInScrollView(image:selectedImages[0])
        }
            
        else if arrCheckMaxImages.isEmpty == true {
            
            self.dismiss(animated: true, completion: nil)
            
            noImage = true
        }
    }
}

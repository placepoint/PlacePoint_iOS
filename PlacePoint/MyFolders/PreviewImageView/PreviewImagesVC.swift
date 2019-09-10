//
//  PreviewImagesVC.swift
//  PlacePoint
//
//  Created by Mac on 20/06/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import Kingfisher

class PreviewImagesVC: UIViewController {
    
    @IBOutlet weak var previewImageCollection: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var cellIndex: Int?
    
    var isFirstLoad: Bool? = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpNavigation()
        
        let nib = UINib(nibName: "PreviewImagesCollectionViewCell", bundle: nil)
        
        self.previewImageCollection.register(nib, forCellWithReuseIdentifier: "PreviewImagesCollectionViewCell")
        
        previewImageCollection.dataSource = self
        
        previewImageCollection.delegate = self
    }
    
    
    //MARK: SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
    // MARK: - Back Button Click
    @objc func backButtonTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UICollectionView DataSource and Delegate
extension PreviewImagesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrBusinessImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviewImagesCollectionViewCell", for: indexPath) as? PreviewImagesCollectionViewCell else {
            fatalError()
        }
        
        pageControl.numberOfPages = arrBusinessImages.count
        
        cell.setData(arr: arrBusinessImages, index: indexPath.row)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
        pageControl.currentPage = cellIndex!
        
        if isFirstLoad == false {
            
            let index:IndexPath? = IndexPath(item: cellIndex!, section: 0)
            
            previewImageCollection.scrollToItem(at: index!, at: .right, animated: true)
            
            isFirstLoad = true
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}

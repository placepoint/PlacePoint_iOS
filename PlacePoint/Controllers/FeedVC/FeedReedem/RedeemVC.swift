
//
//  RedeemVC.swift
//  PlacePoint
//
//  Created by Mind Root on 28/11/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

class RedeemVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpNavigation()
    }

    
    //MARK: - SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        self.navigationItem.navTitle(title: "Payment Details")
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
    }
    
    
    // backButton Tapped
    @objc func backButtonTapped() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    

}

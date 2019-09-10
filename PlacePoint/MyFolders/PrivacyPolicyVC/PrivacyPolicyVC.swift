//
//  PrivacyPolicyVC.swift
//  PlacePoint
//
//  Created by Mac on 08/08/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var myWebBrowserOutlet: WKWebView!
    
    @IBOutlet weak var loaderForWebView: UIActivityIndicatorView!
    
    var isTermsAndCondition = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setUpNavigation()
        
        if isTermsAndCondition == "yes"{
            
            let url = NSURL (string: "https://www.placepoint.ie/termsandcondition")
            
            let requestObj = URLRequest(url: url! as URL)
            
            self.myWebBrowserOutlet.load(requestObj)
            
        } else {
            let url = NSURL (string: "https://www.placepoint.ie/privacypolicy")
            
            let requestObj = URLRequest(url: url! as URL)
            
            self.myWebBrowserOutlet.load(requestObj)
        }
        
        self.loaderForWebView.isHidden = true
        
    }
    
    
    //MARK: SetUp Navigation
    func setUpNavigation() {
        
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.makeColorNavigationBar(titleName: "")
        
        if isTermsAndCondition == "yes"{
            
           self.navigationItem.navTitle(title: "Terms and Conditions")
            
        } else {
            
            self.navigationItem.navTitle(title: "Privacy Policy")
        }
        
        
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(backButtonTapped))
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    
    @objc func backButtonTapped() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.loaderForWebView.isHidden = false
        
        self.loaderForWebView.startAnimating()
        
        return true
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        self.loaderForWebView.isHidden = true
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.loaderForWebView.isHidden = true
    }
    
}

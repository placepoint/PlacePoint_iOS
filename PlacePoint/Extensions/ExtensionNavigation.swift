

import Foundation
import UIKit

extension UINavigationController {
    
    func makeNavigationbar (title: String) {
        
        self.navigationItem.title = title
        
        navigationController?.isNavigationBarHidden = false
    }
}


extension UINavigationBar {
    
    func makeColorNavigationBar (titleName: String) {
        
        isTranslucent = false
        
        barTintColor = UIColor.themeColor()
        
        let font = UIFont(name: CustomFont.ubuntuMedium.rawValue, size: 18)
        
        tintColor = UIColor.white
        
        topItem?.title = titleName
        
        titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: font as Any]
        
    }
    
    func makeColorNavigationBarForFDeal (titleName: String) {
        
        isTranslucent = false
        
        barTintColor = UIColor.themeColor()
        
        let font = UIFont(name: CustomFont.ubuntuMedium.rawValue, size: 15)
        
        tintColor = UIColor.white
        
        topItem?.title = titleName
        
        titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: font as Any]
        
    }
    
    
    func getCentre(imgView: UIImageView) {
        
        imgView.center = self.center
    }
}


extension UINavigationItem {
    
    func navTitle(title: String) {
        
        self.title = title
        
    }
    
    
    func makeNavWithImage(strImageName: String) {
        
        let viewNav = UIView()
        
        let imgView = UIImageView(image: UIImage(named: "strImageName"))
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        
        imgView.center = viewNav.center
        
        viewNav.addSubview(imgView)
        
        self.titleView = viewNav
    }
    
    
    func hideDefaultBackButton() {
        hidesBackButton = true
    }
    
    
    func leftButton(btn: UIBarButtonItem) {
        
        let font = UIFont(name: CustomFont.ubuntuMedium.rawValue, size: 18)
        
        btn.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: font ?? ""], for: UIControlState.normal)
        
        leftBarButtonItem = btn
    }
    
    
    func rightButton(btn: UIBarButtonItem, string: String) {
        
        rightBarButtonItem = btn
    }
    
}

//
//  GradientButton.swift
//  PlacePoint
//
//  "" on 14/12/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class GradientButton: UIButton {
    
    @IBInspectable var startColor:  UIColor = UIColor(red: 45/255, green: 189/255, blue: 220/255, alpha: 1.0)
    
    @IBInspectable var endColor: UIColor = UIColor(red: 53/255, green: 93/255, blue: 254/255, alpha: 1.0)
    
    @IBInspectable var startLocation: Double = 0.05
    
    @IBInspectable var endLocation:   Double = 0.95
    
    @IBInspectable var horizontalMode: Bool = true
    
    @IBInspectable var diagonalMode: Bool = false
    
    // add border color, width and corner radius properties to your GradientView
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    override func layoutSubviews() {
    super.layoutSubviews()
    
    if horizontalMode {
    
    gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
    
    gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
    
    }
    else {
    
    gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
    
    gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
    }
    
    gradientLayer.locations = [startLocation as NSNumber,  endLocation  as NSNumber]
    
    gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    

    

}

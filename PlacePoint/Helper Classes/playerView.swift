//
//  playerView.swift
//  Demo
//
//  "" on 12/02/19.
//  Copyright © 2019 "". All rights reserved.
//

import UIKit
import AVFoundation

class playerView: UIView {

   
   override static var layerClass: AnyClass {
        
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        
        get {
        return playerLayer.player
    }
        set {
            
            return playerLayer.player = newValue
        }
    }
}

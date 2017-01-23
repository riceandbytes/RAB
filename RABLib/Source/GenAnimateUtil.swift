//
//  GenAnimateUtil.swift
//  RAB
//
//  Created by RAB on 3/27/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

open class GenAnimateUtil {
    
    /**
     Usage:
        Remember that you stil need to set the image
        let fade = newCrossfade(..., ...)
        myButton.imageView?.layer.add(fade, forKey: "animateContents")
     
        // still need to set this image afterwards
        myButton.setImage(UIImage(named: "nameOfMyToImage"), forState: .Normal)
     */
    open class func newCrossfade(_ fromImage: UIImage?, toImage: UIImage?) -> CABasicAnimation {
        let fade = CABasicAnimation(keyPath: "contents")
        fade.duration = 0.7
        fade.fromValue = fromImage
        fade.toValue = toImage
        fade.isRemovedOnCompletion = false
        fade.fillMode = kCAFillModeForwards
        return fade
    }
}

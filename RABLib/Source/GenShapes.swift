//
//  RabShapes.swift
//  RAB
//
//  Created by RAB on 5/14/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

open class GenShapes {

    /**
        Creates a solid fill rectangle
    */
    open class func drawRect(_ rect: CGRect, color: CGColor) {
        let rectangle = rect
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color)
        context?.fill(rectangle)
    }
    
    /**
        Creates a rectangle with a outline and clear fill
    */
    open class func drawRectClearFill(_ rect: CGRect, borderColor: CGColor) {
        let rectangle = rect
        let context = UIGraphicsGetCurrentContext()
        
        //this is the transparent color
        context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 0)
        context?.fill(rectangle)
        
        //this will draw the border
        context?.setStrokeColor(borderColor)
        context?.stroke(rectangle)
    }
}

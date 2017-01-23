//
//  File.swift
//
//  Created by vince on 3/8/15.
//  Copyright (c) 2015 RAB LLC. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class GenRoundRectButton: UIButton {
    
//    override open var isHighlighted: Bool {
//        didSet {
//            switch isHighlighted {
//            case true:
//                self.roundRectLayer?.fillColor = UIColor.clear.cgColor
//                self.roundRectLayer?.strokeColor = UIColor.clear.cgColor
//            case false:
//                self.roundRectLayer?.fillColor = self.bkgColor.cgColor
//                self.roundRectLayer?.strokeColor = self.strokeColor.cgColor
//            }
//        }
//    }
    
    /// Corner radius of the background rectangle
    @IBInspectable open var cornerRadius: CGFloat = 2 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// Color of the background rectangle
    @IBInspectable open var bkgColor: UIColor = UIColor.white {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var strokeColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable open var lineWidth: Float = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides

    override open func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    // MARK: Private
    
    fileprivate var roundRectLayer: CAShapeLayer?
    
    fileprivate func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        shapeLayer.fillColor = self.bkgColor.cgColor
        
        shapeLayer.strokeColor = self.strokeColor.cgColor
        shapeLayer.lineWidth = CGFloat(self.lineWidth)
        
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundRectLayer = shapeLayer
    }
    
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isHighlighted = true
//        super.touchesBegan(touches, with: event)
//    }
//    
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isHighlighted = false
//        super.touchesEnded(touches, with: event)
//    }
//    
//    open override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
//        self.isHighlighted = false
//        if let t = touches {
//            super.touchesCancelled(t, with: event)
//        }
//    }
}

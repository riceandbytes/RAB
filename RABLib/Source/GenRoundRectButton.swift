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

    // Slow touch delays the touch of the button
    @IBInspectable open var isFastTouch: Bool = false
    
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
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard isFastTouch == false else {
            return
        }
        
        // To keep the button highlighted for a extra second after you touch it
        self.isHighlighted = true
        doOnMainAfterTime(1.0) {
            [weak self] in
            guard let sSelf = self else { return }
            sSelf.isHighlighted = false
        }
    }
}

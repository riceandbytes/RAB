//
//  UIView+AutoLayout.swift
//  RAB
//
//  Created by visvavince on 6/13/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

extension UIView {
    
    public func centerInSuperview() {
        self.centerHorizontallyInSuperview()
        self.centerVerticallyInSuperview()
    }
    
    public func centerHorizontallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: self.superview, attribute: .centerX, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }
    
    public func centerVerticallyInSuperview(){
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: self.superview, attribute: .centerY, multiplier: 1, constant: 0)
        self.superview?.addConstraint(c)
    }

    /**
     Sets full Width and Height constraints
     
     - goes from edge to edge
     */
    public func addSubview_fullWidthHeightLayoutConstraints(_ v: UIView) {
        self.addSubview_fullWidthHeightLayoutConstraints(v, 0)
    }
    public func addSubview_fullWidthHeightLayoutConstraints(_ v: UIView, _ border: Int) {
        self.addSubview(v)
        v.translatesAutoresizingMaskIntoConstraints = false
        let bindings: [String: UIView] = ["myView": v]
        
        let horizontalConstraints =
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-\(border)-[myView]-\(border)-|",
                metrics: nil,
                views: bindings)
        self.addConstraints(horizontalConstraints)
        
        let verticalConstraints =
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-\(border)-[myView]-\(border)-|",
                metrics: nil,
                views: bindings)
        self.addConstraints(verticalConstraints)
    }
    
    public func addOnlyFullWidthHeightLayoutConstraints(_ v: UIView) {
        v.translatesAutoresizingMaskIntoConstraints = false
        let bindings: [String: UIView] = ["myView": v]
        
        let horizontalConstraints =
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[myView]-0-|",
                metrics: nil,
                views: bindings)
        self.addConstraints(horizontalConstraints)
        
        let verticalConstraints =
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[myView]-0-|",
                metrics: nil,
                views: bindings)
        self.addConstraints(verticalConstraints)
    }
}

//
//  NSLayoutConstraint+Utility.swift
//  RABLib
//
//  Created by skylinefighterx on 2/25/18.
//  Copyright © 2018 Rab LLC. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     
     - Remember to use layoutIfNeeded
     
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    public func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

//
//  NSLayoutConstraint+Utility.swift
//  RABLib
//
//  Created by skylinefighterx on 2/25/18.
//  Copyright © 2018 Rab LLC. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    
//    var newConstraint = self.constraintToChange.constraintWithMultiplier(0.75)
//    self.view!.removeConstraint(self.constraintToChange)
//    self.view!.addConstraint(self.constraintToChange = newConstraint)
//    self.view!.layoutIfNeeded()
    public func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

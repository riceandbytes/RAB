//
//  UINavigationController+Utility.swift
//  RAB
//
//  Created by visvavince on 12/20/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

extension UINavigationController {
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping (Void) -> Void)
    {
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    /// Smart Push Viewcontroller so we can avoid pushing multiple views
    /// due to button spamming
    var didSmartPush: NSNumber? {
        get {
            return objc_getAssociatedObject(self, &smartPushAssociationKey) as? NSNumber
        }
        set(newValue) {
            objc_setAssociatedObject(self, &smartPushAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    public func smartPushViewController(_ viewController: UIViewController,
                                        animated: Bool = true) {
        if self.didSmartPush == nil || self.didSmartPush?.boolValue == false {
            self.didSmartPush = NSNumber(booleanLiteral: true)
            self.pushViewController(viewController, animated: animated) {
                (Void) in
                self.didSmartPush = NSNumber(booleanLiteral: false)
                
            }
        }
    }
}

private var smartPushAssociationKey: UInt8 = 0


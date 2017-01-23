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
}

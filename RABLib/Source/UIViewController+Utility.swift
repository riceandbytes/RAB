//
//  RabUIViewController.swift
//  RAB
//
//  Created by RAB on 6/4/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import Foundation

// MARK: - Find Top Most View Controller

public extension UIViewController {
    public class func topMostViewController() -> UIViewController? {
        return UIViewController.topViewControllerForRoot(UIApplication.shared.keyWindow?.rootViewController)
    }
    
    public class func topViewControllerForRoot(_ rootViewController:UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case is UINavigationController:
            let navigationController:UINavigationController = presented as! UINavigationController
            return UIViewController.topViewControllerForRoot(navigationController.viewControllers.last)
            
        case is UITabBarController:
            let tabBarController:UITabBarController = presented as! UITabBarController
            return UIViewController.topViewControllerForRoot(tabBarController.selectedViewController)
            
        default:
            return UIViewController.topViewControllerForRoot(presented)
        }
    }
    
    public func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        }
        if self.presentingViewController?.presentedViewController == self {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        }
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    /**
     This method well either dismiss or pop the current vc
     */
    public func popOrDismiss(_ animated: Bool = true) {
        if self.isModal() {
            self.dismissSelf()
        } else {
            _ = self.navigationController?.popViewController(animated: animated)
        }
    }
}

public extension UIViewController {
    
    public var nav: UINavigationController? { return navigationController }
    
    public class func fromStoryboard() -> UIViewController {
        let name = NSStringFromClass(self)
        let fullname = name.pathExtension
        let board = UIStoryboard(name: fullname, bundle: nil)
        return board.instantiateInitialViewController()!
    }
    
    public func dismissPresented(_ animated: Bool = true, completion: Action? = nil) {
        dismiss(animated: animated, completion: completion)
    }
    
    public func dismissSelf(_ animated: Bool = true, completion: Action? = nil) {
        if let c = presentingViewController {
            c.dismissPresented(animated, completion: completion)
        } else {
            print("dismissSelf: no presenting controller: \(self)", terminator: "\n")
        }
    }
    
    /// Find, pop to and return the viewcontroller of the given type
    public func popTo<T:UIViewController>(_ type: T.Type, animated: Bool) -> T? {
        let controllers = self.navigationController!.viewControllers as [UIViewController]
        for view in controllers {
            pln("1 - \(view.dynamicTypeFullName)")
            pln("2 - \(String(describing: type))")
            
            if view.dynamicTypeName == String(describing: type) {
                pln("return - \(view)")
                self.navigationController!.popToViewController(view, animated: animated)
                return view as? T
            }
        }
        pln("ERROR: no viewController of type \(type) in nav stack")
        return nil
    }
    
    public func captureSnapshot() -> UIImage {
        let view = self.view
        UIGraphicsBeginImageContextWithOptions((view?.frame.size)!, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()
        view?.drawHierarchy(in: (view?.frame)!, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func swipeToDismiss(_ enable: Bool) {
        if enable {
            let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UIViewController.panAction(_:)))
            gesture.edges = UIRectEdge.left
            gesture.isEnabled = true
            self.view.addGestureRecognizer(gesture)
            
            var image: UIImage? = nil
            let blank = CALayer()
            blank.frame.size = self.view.layer.frame.size
            blank.frame.origin = CGPoint(x: -blank.frame.width, y: 0)
            blank.backgroundColor = UIColor.red.cgColor
            
            if let presenting = self.presentingViewController as? UINavigationController {
                if let top = presenting.topViewController {
                    image = top.captureSnapshot()
                    blank.backgroundColor = top.view.backgroundColor?.cgColor
                }
            }
            
            if let image = image {
                blank.contents = image.cgImage
            } else {
                pErr("UNABLE TO DETERMINE PREVIOUS VIEW FOR SWIPE BACK TO DISMISS, WILL SEE BLANK SCREEN\r\nMAKE SURE YOU CALL THIS FUNCITON IN OR AFTER VIEWDIDLOAD")
            }
            
            blank.masksToBounds = false
            blank.shadowColor = UIColor.black.cgColor
            blank.shadowOffset = CGSize(width: 0.5, height: 0.5)
            blank.shadowOpacity = 0.5
            blank.shadowPath = UIBezierPath(rect: blank.bounds).cgPath
            
            objc_setAssociatedObject(self, &STDTransitionLayer, blank, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            
        } else {
            if let gestures = self.view.gestureRecognizers {
                for gesture in gestures {
                    if gesture is UIPanGestureRecognizer {
                        self.view.removeGestureRecognizer(gesture)
                        break
                    }
                }
            }
        }
    }
    
    func panAction(_ r: UIScreenEdgePanGestureRecognizer) {
        // peek the other controller through the back
        var transitionLayer: CALayer!
        if let temp = objc_getAssociatedObject(self, &STDTransitionLayer) as? CALayer {
            transitionLayer = temp
        } else {
            pErr("Unable to locate transition layer, cannot respond to SwipeToDismiss action")
            return
        }
        
        
        let v = r.view!
        _ = self.presentingViewController
        switch r.state {
        case .began:
            self.view.layer.addSublayer(transitionLayer)
            break
        case .changed:
            let tx = r.translation(in: v.superview!).x
            if (tx < 0) {
                v.alpha = 1
                v.frame.origin.x = 0
            } else {
                v.frame.origin.x = tx
            }
        case .ended:
            let tx = r.translation(in: v.superview!).x
            let dismissMe = (tx >= (0.3 * view.bounds.width))
            
            let x = v.frame.origin.x
            let dest = (dismissMe ? view.bounds.width : 0)
            let t = (dismissMe ? x : (view.bounds.width - x)) / view.bounds.width // the fractional progress to dest.
            UIView.animate(withDuration: TimeInterval(0.3 * (1 - t)),
                animations: {
                    v.frame.origin.x = dest
                },
                completion: {
                    (completed) in
                    if dismissMe {
                        var done = false
                        // if we have our own nav, use that
                        if let controllers = self.nav?.viewControllers {
                            // top one is self, check if there is one before
                            if controllers.count > 1 {
                                done = true
                                self.navigationController!.popViewController(animated: false)
                            }
                        }
                        
                        if !done {
                            self.dismissSelf(false)
                        }
                    } else {
                        transitionLayer.removeFromSuperlayer()
                    }
            })
        case .cancelled:
            // back to normal
            let t = (view.bounds.width - v.frame.x) / view.bounds.w
            UIView.animate(withDuration: TimeInterval(0.3 * (1 - t)),
                animations: {
                    v.frame.origin.x = 0
                },
                completion: { (completed) in
                    transitionLayer.removeFromSuperlayer()
                    
            })
        default:
            break
        }
    }
}

// MARK: - Handle UIAlertViewController for iPad

extension UIViewController {
    
    // Special function to help present a popover controller when using
    // UIAlertControllers on a iPad
    //
    public func presentAlert(_ alert: UIAlertController, animated: Bool = true, sender: AnyObject? = nil) {
        if let presenter = alert.popoverPresentationController {
            if let s = sender as? UIView {
                presenter.sourceView = s
                presenter.sourceRect = s.bounds
            } else {
                if let rightButton = self.navigationItem.rightBarButtonItem {
                    presenter.barButtonItem = rightButton
                } else {
                    presenter.sourceView = self.view
                    presenter.sourceRect = self.view.bounds
                }
            }
        }
        self.present(alert, animated: animated, completion: nil)
    }
}

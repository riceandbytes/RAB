//
//  UIView+Keyboard.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

/// MARK: UIView - Keyboard Reactions
public extension UIView {
    
    public func makeKeyboardAware() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "keyboardShow:"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "keyboardHide:"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.addSubview(NotificationRemover())
    }
    
    @objc func keyboardShow(_ notification : Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        let val = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        // animation info for the keyboard
        let animDuration: TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // only care to show kb if we are the active field
        var move = self.isFirstResponder
        
        if self is UIButton {
            // if a button is keyboard aware, then always move the screen
            move = true
        }
        
        if move  {
            moveView(true, animDuration: animDuration, kbRect: val.cgRectValue)
        }
        
    }
    
    @objc func keyboardHide(_ notification : Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        let val = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let kbRect = val.cgRectValue
        
        // animation info for the keyboard
        let animDuration: TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        moveView(false, animDuration: animDuration, kbRect: kbRect)
        
    }
    
    fileprivate func moveView(_ up: Bool, animDuration animDurationInit: TimeInterval, kbRect: CGRect, extraSpace: CGFloat = 15) {
        var animDuration = animDurationInit
        let posInWindow = self.superview!.convert(self.frame.origin, to: window)
        
        // Determine how much overlap exists between tableView and the keyboard
        let bottomOfTopView = posInWindow.y + self.frame.size.height
        
        var keyboardOverlap = bottomOfTopView - kbRect.origin.y
        
        
        if keyboardOverlap < 0 { keyboardOverlap = 0 }
        
        var delay: TimeInterval = 0;
        if kbRect.size.height != 0 && up {
            delay = (1.0 - TimeInterval(keyboardOverlap/kbRect.size.height)) * animDuration
            animDuration = animDuration * TimeInterval(keyboardOverlap / kbRect.size.height)
        }
        
        if animDuration <= 0.1 {
            animDuration = 0.3
        }
        
        UIView.animate(withDuration: animDuration, delay: delay, options: UIViewAnimationOptions.beginFromCurrentState, animations: { () -> Void in
            if let window = self.window {
                let orig = window.frame
                var newY: CGFloat = 0
                if up {
                    newY -= (keyboardOverlap + extraSpace)
                    
                    // check if the view is cut off at all
                    let hiddenArea = bottomOfTopView - (window.bounds.origin.y + window.bounds.height)
                    if hiddenArea > 0 {
                        // we're cut off, gonna have to pull back the Y a bit
                        newY += hiddenArea
                    }
                }
                
                
                
                let frame = CGRect(x: orig.origin.x, y: newY, width: orig.width, height: orig.height)
                window.frame = frame
            }
            }, completion:  { (finished) in
        })
    }
}

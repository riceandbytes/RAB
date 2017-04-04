//
//  CircleGestureRecognizer.swift
//  RAB
//
//  Created by visvavince on 7/6/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


 /**
    Usage: 
 
 let recognizer = CircleGestureRecognizer(midPoint: self.view.center, innerRadius:10, outerRadius:200, target: self, action: #selector(handleRotate(_:)))
 recognizer.delegate = self
 view.addGestureRecognizer(recognizer)

func handleRotate(recognizer:CircleGestureRecognizer) {
    if let rotation = recognizer.rotation {
        // rotation is the relative rotation for the current gesture in radians
        currentDebugRotateValue += rotation.degrees / 360 * 100
        pln(currentDebugRotateValue)
        if currentDebugRotateValue >= 100 {
            currentDebugRotateValue = 0.0
            let ss = DebugModeController.fromStoryboard()
            nav?.pushViewController(ss, animated: true)
        }
        
    }
}
 
 */

let π = CGFloat(Double.pi)

extension CGFloat {
    public var degrees:CGFloat {
        return self * 180 / π;
    }
    public var radians:CGFloat {
        return self * π / 180;
    }
    public var rad2deg:CGFloat {
        return self.degrees
    }
    public var deg2rad:CGFloat {
        return self.radians
    }
}

open class CircleGestureRecognizer: UIGestureRecognizer {
    
        /* PUBLIC VARS */
        
        // midpoint for gesture recognizer
        var midPoint = CGPoint.zero
        
        // minimal distance from midpoint
        var innerRadius:CGFloat?
        
        // maximal distance to midpoint
        var outerRadius:CGFloat?
        
        // relative rotation for current gesture (in radians)
        open var rotation:CGFloat? {
            if let currentPoint = self.currentPoint {
                if let previousPoint = self.previousPoint {
                    var rotation = angleBetween(currentPoint, andPointB: previousPoint)
                    
                    if (rotation > π) {
                        rotation -= π*2
                    } else if (rotation < -π) {
                        rotation += π*2
                    }
                    
                    return rotation
                }
            }
            
            return nil
        }
        
        // absolute angle for current gesture (in radians)
        open var angle:CGFloat? {
            if let nowPoint = self.currentPoint {
                return self.angleForPoint(nowPoint)
            }
            
            return nil
        }
        
        // distance from midpoint
        open var distance:CGFloat? {
            if let nowPoint = self.currentPoint {
                return self.distanceBetween(self.midPoint, andPointB: nowPoint)
            }
            
            return nil
        }
        
        /* PRIVATE VARS */
        
        // internal usage for calculations. (Please give us Access Modifiers, Apple!)
        var currentPoint:CGPoint?
        var previousPoint:CGPoint?
        
        /* PUBLIC METHODS */
        
        // designated initializer
        public init(midPoint:CGPoint, innerRadius:CGFloat?, outerRadius:CGFloat?, target:AnyObject?, action:Selector) {
            super.init(target: target, action: action)
            
            self.midPoint = midPoint
            self.innerRadius = innerRadius
            self.outerRadius = outerRadius
        }
        
        // convinience initializer if innerRadius and OuterRadius are not necessary
        convenience public init(midPoint:CGPoint, target:AnyObject?, action:Selector) {
            self.init(midPoint:midPoint, innerRadius:nil, outerRadius:nil, target:target, action:action)
        }
        
        
        /* PRIVATE METHODS */
        
        func distanceBetween(_ pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
            let dx = Float(pointA.x - pointB.x)
            let dy = Float(pointA.y - pointB.y)
            return CGFloat(sqrtf(dx*dx + dy*dy))
        }
        
        func angleForPoint(_ point:CGPoint) -> CGFloat {
            var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + π/2
            
            
            if (angle < 0) {
                angle += π*2;
            }
            
            
            return angle
        }
        
        func angleBetween(_ pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
            return angleForPoint(pointA) - angleForPoint(pointB)
        }
        
        /* SUBCLASSED METHODS */
        
        override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            
            if let firstTouch = touches.first {
                
                currentPoint = firstTouch.location(in: self.view)
                
                var newState:UIGestureRecognizerState = .began
                
                if let innerRadius = self.innerRadius {
                    if distance < innerRadius {
                        newState = .failed
                    }
                }
                
                if let outerRadius = self.outerRadius {
                    if distance > outerRadius {
                        newState = .failed
                    }
                }
                
                state = newState
                
            }
            
        }
        
        override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
            
            super.touchesMoved(touches, with: event)
            
            if state == .failed {
                return
            }
            
            if let firstTouch = touches.first {
                
                currentPoint = firstTouch.location(in: self.view)
                previousPoint = firstTouch.previousLocation(in: self.view)
                
                state = .changed
                
            }
        }
        
        override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesEnded(touches, with: event)
            state = .ended
            
            currentPoint = nil
            previousPoint = nil
        }
        
}

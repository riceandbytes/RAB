//
//  TickleGestureRecognizer.swift
//  RAB
//
//  Created by visvavince on 7/6/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

open class TickleGestureRecognizer: UIGestureRecognizer {
    
    let requiredTickles = 3
    let distanceForTickleGesture:CGFloat = 25.0
    
    enum Direction:Int {
        case directionUnknown = 0
        case directionLeft
        case directionRight
    }
    
    var tickleCount:Int = 0
    var curTickleStart:CGPoint = CGPoint.zero
    var lastDirection:Direction = .directionUnknown
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            self.curTickleStart = touch.location(in: self.view)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let ticklePoint = touch.location(in: self.view)
            
            let moveAmt = ticklePoint.x - curTickleStart.x
            var curDirection:Direction
            if moveAmt < 0 {
                curDirection = .directionLeft
            } else {
                curDirection = .directionRight
            }
            
            //moveAmt is a Float, so self.distanceForTickleGesture needs to be a Float also
            if abs(moveAmt) < self.distanceForTickleGesture {
                pln("moveAmt: \(moveAmt)")
                return
            }
            
            if self.lastDirection == .directionUnknown ||
                (self.lastDirection == .directionLeft && curDirection == .directionRight) ||
                (self.lastDirection == .directionRight && curDirection == .directionLeft) {
                self.tickleCount += 1
                self.curTickleStart = ticklePoint
                self.lastDirection = curDirection
                pln("tickleCount: \(tickleCount)")
                if self.state == .possible && self.tickleCount > self.requiredTickles {
                    self.state = .ended
                }
            }
        }
    }
    
    override open func reset() {
        self.tickleCount = 0
        self.curTickleStart = CGPoint.zero
        self.lastDirection = .directionUnknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }
}

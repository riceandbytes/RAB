//
//  CoreGraphicsExt.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import CoreGraphics


public typealias Flt = CGFloat
public typealias V2 = CGPoint

public extension CGSize {
    
    init(_ w: Flt, _ h: Flt) { self.init(width: w, height: h) }
    
    static let zeroSize = CGSize.zero
    
    var w: Flt {
        get { return width }
        set(w) { width = w }
    }
    
    var h: Flt {
        get { return height }
        set(h) { height = h }
    }
}


public extension CGRect {
    
    init(_ x: Flt, _ y: Flt, _ w: Flt, _ h: Flt) { self.init(x: x, y: y, width: w, height: h) }
    
    init(x: Flt, y: Flt, r: Flt, b: Flt) { self.init(x, y, r - x, b - y) }
    
    init(_ w: Flt, _ h: Flt) { self.init(0, 0, w, h) }
    
    init(_ o: CGPoint, _ s: CGSize) { self.init(o.x, o.y, s.w, s.h) }
    
    init(c: CGPoint, s: CGSize) { self.init(c.x - s.w * 0.5, c.y - s.h * 0.5, s.w, s.h) }
    
    init(_ s: CGSize) { self.init(0, 0, s.w, s.h) }
    
    init(p0: CGPoint, p1: CGPoint) {
        var x, y, w, h: Flt
        if p0.x < p1.x {
            x = p0.x
            w = p1.x - p0.x
        } else {
            x = p1.x
            w = p0.x - p1.x
        }
        if p0.y < p1.y {
            y = p0.y
            h = p1.y - p0.y
        } else {
            y = p1.y
            h = p0.y - p1.y
        }
        self.init(x, y, w, h)
    }
    
    static let zeroRect = CGRect.zero
    
    var o: CGPoint {
        get { return origin }
        set(o) { origin = o }
    }
    
    var s: CGSize {
        get { return size }
        set(s) { size = s }
    }
    
    var x: Flt {
        get { return o.x }
        set(x) { o = CGPoint(x: x,y: o.y) }
    }
    
    var y: Flt {
        get { return o.y }
        set(y) { o = CGPoint(x: o.x, y: y) }
    }
    
    var w: Flt {
        get { return s.w }
        set(w) { s = CGSize(w, s.h) }
    }
    
    var h: Flt {
        get { return s.h }
        set(h) { s = CGSize(s.w, h) }
    }
    
    var r: Flt {
        get { return x + w }
        set { x = newValue - w }
    }
    
    var b: Flt {
        get { return y + h }
        set { y = newValue - h }
    }
    
    func inset(dx: Flt, dy: Flt) -> CGRect {
        return self.insetBy(dx: dx, dy: dy)
    }
}

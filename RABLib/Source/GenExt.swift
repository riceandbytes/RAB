//
//  RabExt.swift
//  RAB
//
//  Created by RAB on 4/26/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

var STDTransitionLayer: UnsafePointer<UIViewController>? = nil

public enum FontStyle: String {
    case Light = "Light"
    case Bold = "Bold"
    case Regular = ""
}

extension UIScreen {
    class func getFrameMain() -> CGRect {
        return UIScreen.main.bounds
    }
}

/// Added to a view to remove all notifications from it upon deinitialization.
///
/// This is for the case when notifications are added in such a manner that removal inside a deinit block is impossible.
///
class NotificationRemover: UIView {
    
    override func removeFromSuperview() {
        if let view = self.superview {
            NotificationCenter.default.removeObserver(view)
        }
        super.removeFromSuperview()
    }
    
    deinit {
        if let view = self.superview {
            NotificationCenter.default.removeObserver(view)
        }
    }
}

//MARK: - UIButton Extensions
//
public extension UIButton
{
    public func highlight() {
        backgroundColor = Const.GrayLight
        setTitleColor(Const.White, for: .selected)
        isSelected = true
    }
    
    public func unhighlight() {
        backgroundColor = Const.GrayLight
        setTitleColor(Const.White, for: UIControlState())
        isSelected = false
    }
}

//MARK: - Array
//
public extension Array {
    // Example Usage
    //var myA = [10,20,30]
    //if let val = myA.ref(index) {
    //     Use 'val' if index is < 3
    //}
    //else {
    //     Do this if the index is too high
    //}
    func ref (_ i:Int) -> Element? {
        return 0 <= i && i < count ? self[i] : nil
    }
    
    var lastIndex: Int? { return count > 0 ? count - 1 : nil }
    
    init(capacity: Int) {
        self = []
        self.reserveCapacity(capacity)
    }
    
    func mapEnum<U>(_ transform: (Int, Element) -> U) -> [U] {
        var a = [U](capacity:self.count)
        for (i, e) in self.enumerated() {
            a.append(transform(i, e))
        }
        return a
    }
}

//MARK: - NSObject
//
public extension NSObject {
    
    //
    // Retrieves an array of property names found on the current object
    // using Objective-C runtime functions for introspection:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
    //
    // Usage:
    // var properties = someObj.propertyNames();
    //
    //    for property in properties {
    //    var value: AnyObject? = someObj.valueForKey(property);
    //    self.setValue(value, forKey: property)
    //    }
    //
    public func propertyNames() -> Array<String> {
        var results: Array<String> = []
        
        // retrieve the properties via the class_copyPropertyList function
        var count: UInt32 = 0
        let myClass: AnyClass = type(of: self)
        let properties = class_copyPropertyList(myClass, &count)
        
        // iterate each objc_property_t struct
        for i in 0..<count {
            let property = properties?[Int(i)]
            
            // retrieve the property name by calling property_getName function
            let cname = property_getName(property!)
            
            // covert the c string into a Swift string
            let name = String(cString: cname)
            results.append(name)
        }
        
        // release objc_property_t structs
        free(properties)
        
        return results
    }
    
    // MARK: - Get class names
    /// http://stackoverflow.com/questions/24494784/get-class-name-of-object-as-string-in-swift
    /// Usage: 
    /// print(self.className)
    /// print(ViewController.className)
    ///
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

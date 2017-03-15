//
//  RabNSObject.swift
//  RAB
//
//  Created by RAB on 6/4/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Associated Object
public extension NSObject {
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}

// MARK: - Path Names
public extension NSObject {
    
    public class var dynamicClassFullName: String { return NSStringFromClass(self) }
    
    public class var dynamicClassName: String {
        return dynamicClassFullName.pathExtension
    }
    
    public var dynamicTypeFullName: String { return NSStringFromClass(type(of: self)) }
    
    public var dynamicTypeName: String {
        return dynamicTypeFullName.pathExtension
    }
}

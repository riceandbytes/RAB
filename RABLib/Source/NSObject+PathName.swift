//
//  RabNSObject.swift
//  RAB
//
//  Created by RAB on 6/4/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

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

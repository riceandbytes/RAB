//
//  CoreData+Utility.swift
//  RAB
//
//  Created by visvavince on 3/1/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation
import CoreData

public extension NSManagedObject {
    
    /**
     Helper for nsset
     
     Usage:
     employees is variable name of set
     department.addObject(section, forKey: "employees")

     // sets store unique values
     
     - parameter value:  Object you like to set
     - parameter forKey: Name of NSSet Variable
     */
    public func addObject(_ value: NSManagedObject, forKey: String) {
        let items = self.mutableSetValue(forKey: forKey)
        items.add(value)
    }
}

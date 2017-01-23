//
//  Array+Utility.swift
//  RAB
//
//  Created by visvavince on 6/28/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func safeRemoveAtIndex(_ index: Int) -> Bool {
        if self.indices.contains(index) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    public func containsIndex(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
}

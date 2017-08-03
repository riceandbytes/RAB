//
//  Float+Utility.swift
//  RAB
//
//  Created by visvavince on 8/3/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation

/**
 Only show decimal if number has a decimal
 
 ex:
 1.0 will be 1
 3.2 will be 3.2
 */
extension Float {
    
    public var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

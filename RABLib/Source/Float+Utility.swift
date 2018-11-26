//
//  Float+Utility.swift
//  RAB
//
//  Created by visvavince on 8/3/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation


extension Float {

    /**
     Only show decimal if number has a decimal
     
     ex:
     1.0 will be 1
     3.2 will be 3.2
     */
    public var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    //    let myVelocity:Float = 12.32982342034
    //    println("The velocity is \(myVelocity.string(2))")
    //    println("The velocity is \(myVelocity.string(1))")
    //    The velocity is 12.33
    //    The velocity is 12.3
    public func string(_ fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

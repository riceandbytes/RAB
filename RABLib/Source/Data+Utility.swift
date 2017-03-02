//
//  Data+Utility.swift
//  RAB
//
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation

extension Data {
    
    /// Used to convert device token to string
    /// - return: get a base-16 encoded hex string
    ///
    public var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}

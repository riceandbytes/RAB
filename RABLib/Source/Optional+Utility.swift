//
//  Optional+Utility.swift
//  RAB
//
//  Created by visvavince on 9/18/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation
 
/**
 Checks to see if string is nil or empty
 
 Usage:
 guard let title = textField.text.nilIfEmpty else {
 // Alert: textField is empty!
 return
 }
 // title String is now unwrapped, non-empty, and ready for use
 
 OR
 
 let stuff = ["nate", "", nil, "loves", nil, "swift", ""]
 let a = stuff.map { $0.nilIfEmpty }
 print(a) // [Optional("nate"), nil, nil, Optional("loves"), nil, Optional("swift"), nil]
 let b = stuff.flatMap { $0.nilIfEmpty }
 print(b) // ["nate", "loves", "swift"]
 */
extension Optional where Wrapped == String {
    var nilIfEmpty: String? {
        guard let strongSelf = self else {
            return nil
        }
        return strongSelf.isEmpty ? nil : strongSelf
    }
}

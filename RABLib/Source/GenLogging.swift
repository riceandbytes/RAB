//
//  GenLogging.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

func pln(_ object: Any = "called.", file:String = #file, function:String = #function, line:Int = #line) {
    print(file, "[\(Date().toString(.debug, timeZone: nil))][\(NSString(string: file).lastPathComponent)][\(function)][\(line)] -> \(object)")
}

func pErr(_ object: Any, file:String = #file, function:String = #function,
    line:Int = #line) {
       print("[ERROR][\(NSString(string: file).lastPathComponent)][\(function)][\(line)] -> \(object)")
}

func pWarn(_ object: Any, file:String = #file, function:String = #function,
    line:Int = #line) {
        print("[WARN][\(NSString(string: file).lastPathComponent)][\(function)][\(line)] -> \(object)")
}

func pAssert(_ exp: Bool, _ object: Any, file:String = #file, function:String = #function, line:Int = #line) {
    #if DEBUG
        assert(exp, "[ERROR][\(file.lastPathComponent)][\(function)][\(line)] -> \(object)")
    #else
        if !exp { pErr("[ERROR][\(NSString(string: file).lastPathComponent)][\(function)][\(line)] -> \(object)") }
    #endif
}

func pFail(_ object: Any,
           file: String = #file,
           function:String = #function,
           line:Int = #line) {
    pAssert(false, object, file: file, function: function, line: line)
}

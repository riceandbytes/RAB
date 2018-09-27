//
//  RABLibTests.swift
//  RABLibTests
//
//  Created by visvavince on 3/12/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import UIKit
import XCTest
import RABLib

class RABLibTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testJoinArrayWithSeparator() {
        let str = GenUtil.joinArrayWithSeparator(["dog", "cat", "fish"], ", ")
        XCTAssertEqual(str, "dog, cat, fish")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDateSetExact() {
        let today = Date()
        let x = today.setTimeExact(hour: 11, min: 50, sec: 25)
        XCTAssertEqual(x?.getHour(), 11)
        XCTAssertEqual(x?.getMinute(), 50)
        XCTAssertEqual(x?.getSecond(), 25)
    }
    
}

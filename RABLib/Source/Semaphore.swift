//
//  Semaphore.swift
//  RAB
//
//  Created by visvavince on 7/9/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

/**
 *  Usage:
     let semaphore = Semaphore(value: 0);
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
     
     //your code
     semaphore.signal();
     }
     
     semaphore.wait();
 */
public struct Semaphore {
    
    let semaphore: DispatchSemaphore
    
    public init(value: Int = 0) {
        semaphore = DispatchSemaphore(value: value)
    }
    
    // Blocks the thread until the semaphore is free and returns true
    // or until the timeout passes and returns false
    public func wait(_ nanosecondTimeout: Int64) -> Bool {
        return semaphore.wait(timeout: DispatchTime.now() + Double(nanosecondTimeout) / Double(NSEC_PER_SEC)) == .success
    }
    
    // Blocks the thread until the semaphore is free
    public func wait() {
        _ = semaphore.wait(timeout: .distantFuture)
    }
    
    // Alerts the semaphore that it is no longer being held by the current thread
    // and returns a boolean indicating whether another thread was woken
    public func signal() -> Bool {
        return semaphore.signal() != 0
    }
}

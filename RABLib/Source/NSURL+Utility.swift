//
//  NSUrl+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public extension URL {
    
    init?(string: String, parameters: Dictionary<String, AnyObject>) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var queryItems: Array<URLQueryItem> = []
        for (key, value) in parameters {
            var stringValue: String! = nil
            
            if let str = value as? String {
                stringValue = str
            } else if let num = value as? NSNumber {
                stringValue = num.stringValue
            } else if let decimal = value as? NSDecimalNumber {
                stringValue = decimal.stringValue
            } else if let date = value as? Date {
                stringValue = dateFormatter.string(from: date)
            } else if let _ = value as? [Dictionary<String, AnyObject>] {
                pAssert(false, "This is not supported")
            }
            
            if stringValue != nil {
                let queryItem = URLQueryItem(name: key, value: stringValue)
                queryItems.append(queryItem)
            } else {
                pln("Cannot convert \(value) to string!")
            }
        }
        var urlComponents: URLComponents = URLComponents(string: string)!
        urlComponents.queryItems = queryItems
        self.init(string: urlComponents.string!)
    }
    
    /**
     This init is specific to item query, it will take a array of Int and will create a request that
     looks like ?id=2&id=44
     
     - parameter string:
     - parameter parametersIdList: Array of numbers of ids
     
     */
    init?(string: String, parametersIdList: Array<AnyObject>) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var queryItems: Array<URLQueryItem> = []
        for value in parametersIdList {
            var stringValue: String! = nil
            
            if let str = value as? String {
                stringValue = str
            } else if let num = value as? NSNumber {
                stringValue = num.stringValue
            } else if let decimal = value as? NSDecimalNumber {
                stringValue = decimal.stringValue
            } else if let date = value as? Date {
                stringValue = dateFormatter.string(from: date)
            } else {
                pAssert(false, "This is not supported")
            }
            
            if stringValue != nil {
                let queryItem = URLQueryItem(name: "id", value: stringValue)
                queryItems.append(queryItem)
            } else {
                pln("Cannot convert \(value) to string!")
            }
        }
        var urlComponents: URLComponents = URLComponents(string: string)!
        urlComponents.queryItems = queryItems
        self.init(string: urlComponents.string!)
    }
}

////
////  OrderedDictionary.swift
////  RAB
////
////  Created by RAB on 12/20/15.
////  Copyright © 2015 Rab LLC. All rights reserved.
////
//
//
////Example Usage
////
////Initialization:
////
////var orderedDictionary: OrderedDictionary<String, Int> = [
////    ("A", 1),
////    ("B", 2),
////    ("C", 3),
////    ("D", 4)
////]
////
////print(orderedDictionary) // => [A: 1, B: 2, C: 3, D: 4]
////Looping through the contents:
////    
////    for (index, (key, value)) in orderedDictionary.enumerate() {
////        print("\(index): (\(key): \(value))")
////}
////
////// => 0: (A: 1)
////// => 1: (B: 2)
////// => 2: (C: 3)
////// => 3: (D: 4)
////Modifying the values by setting the value for key:
////    
////    orderedDictionary["A"] = 100
////orderedDictionary["E"] = 5
////orderedDictionary["B"] = nil
////orderedDictionary.updateValue(42, forKey: "D")
////
////print(orderedDictionary) // => [A: 100, C: 3, D: 42, E: 5]
////
////print(orderedDictionary["A"]) // => Optional(100)
////print(orderedDictionary["B"]) // => nil
////print(orderedDictionary["C"]) // => Optional(3)
////print(orderedDictionary["D"]) // => Optional(42)
////print(orderedDictionary["E"]) // => Optional(5)
////Modifying the values by setting the element for index:
////    
////    orderedDictionary[2] = ("F", 235)
////orderedDictionary.updateElement(("K", 12), atIndex: 1)
////orderedDictionary.removeAtIndex(0)
////
////print(orderedDictionary) // => [K: 12, F: 235, E: 5]
////
////print(orderedDictionary[0]) // => ("K", 12)
////print(orderedDictionary[1]) // => ("F", 235)
////print(orderedDictionary[2]) // => ("E", 5)
////// print(orderedDictionary[3]) // => fatal error
////
////print(orderedDictionary.indexForKey("K")) // => Optional(0)
////print(orderedDictionary.indexForKey("F")) // => Optional(1)
////print(orderedDictionary.indexForKey("E")) // => Optional(2)
////print(orderedDictionary.indexForKey("A")) // => nil
////print(orderedDictionary.indexForKey("C")) // => nil
////Sorting:
////
////var sortingOrderedDictionary: OrderedDictionary<String, Int> = [
////    ("E", 4),
////    ("G", 3),
////    ("A", 3),
////    ("D", 1),
////    ("B", 4)
////]
////
////sortingOrderedDictionary.sortInPlace { (item1, item2) in
////    if item1.1 == item2.1 {
////        return item1.0 < item2.0
////    } else {
////        return item1.1 < item2.1
////    }
////}
////
////print(sortingOrderedDictionary) // => [D: 1, A: 3, G: 3, B: 4, E: 4]
//
//
//
//import Foundation
//
//public struct OrderedDictionary<Key: Hashable, Value>: MutableCollection, ExpressibleByArrayLiteral, CustomStringConvertible {
//    
//    // ======================================================= //
//    // MARK: - Type Aliases
//    // ======================================================= //
//    
//    public typealias Element = (Key, Value)
//    
//    public typealias Index = Int
//    
//    // ======================================================= //
//    // MARK: - Initialization
//    // ======================================================= //
//    
//    public init() {}
//    
//    public init(elements: [Element]) {
//        for element in elements {
//            self[element.0] = element.1
//        }
//    }
//    
//    public init(arrayLiteral elements: Element...) {
//        self.init(elements: elements)
//    }
//    
//    // ======================================================= //
//    // MARK: - Accessing Keys & Values
//    // ======================================================= //
//    
//    public var orderedKeys: [Key] {
//        return _orderedKeys
//    }
//    
//    public var orderedValues: [Value] {
//        return _orderedKeys.flatMap { _keysToValues[$0] }
//    }
//    
//    // ======================================================= //
//    // MARK: - Managing Content Using Keys
//    // ======================================================= //
//    
//    public subscript(key: Key) -> Value? {
//        get {
//            return _keysToValues[key]
//        }
//        set(newValue) {
//            if let newValue = newValue {
//                _ = updateValue(newValue, forKey: key)
//            } else {
//                _ = removeValueForKey(key)
//            }
//        }
//    }
//    
//    public func containsKey(_ key: Key) -> Bool {
//        return _orderedKeys.contains(key)
//    }
//    
//    public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
//        if _orderedKeys.contains(key) {
//            guard let currentValue = _keysToValues[key] else {
//                fatalError("Inconsistency error occured in OrderedDictionary")
//            }
//            
//            _keysToValues[key] = value
//            
//            return currentValue
//        } else {
//            _orderedKeys.append(key)
//            _keysToValues[key] = value
//            
//            return nil
//        }
//    }
//    
//    public mutating func removeValueForKey(_ key: Key) -> Value? {
//        if let index = _orderedKeys.index(of: key) {
//            guard let currentValue = _keysToValues[key] else {
//                fatalError("Inconsistency error occured in OrderedDictionary")
//            }
//            
//            _orderedKeys.remove(at: index)
//            _keysToValues[key] = nil
//            
//            return currentValue
//        } else {
//            return nil
//        }
//    }
//    
//    public mutating func removeAll(keepCapacity: Bool = true) {
//        _orderedKeys.removeAll(keepingCapacity: keepCapacity)
//        _keysToValues.removeAll(keepingCapacity: keepCapacity)
//    }
//    
//    // ======================================================= //
//    // MARK: - Managing Content Using Indexes
//    // ======================================================= //
//    
//    public subscript(index: Index) -> Element {
//        get {
//            guard let element = elementAtIndex(index) else {
//                fatalError("OrderedDictionary index out of range")
//            }
//            
//            return element
//        }
//        set(newValue) {
//            _ = updateElement(newValue, atIndex: index)
//        }
//    }
//    
//    public func indexForKey(_ key: Key) -> Index? {
//        return _orderedKeys.index(of: key)
//    }
//    
//    public func elementAtIndex(_ index: Index) -> Element? {
//        guard _orderedKeys.indices.contains(index) else { return nil }
//        
//        let key = _orderedKeys[index]
//        
//        guard let value = self._keysToValues[key] else {
//            fatalError("Inconsistency error occured in OrderedDictionary")
//        }
//        
//        return (key, value)
//    }
//    
//    public mutating func insertElementWithKey(_ key: Key, value: Value, atIndex index: Index) -> Value? {
//        return insertElement((key, value), atIndex: index)
//    }
//    
//    public mutating func insertElement(_ newElement: Element, atIndex index: Index) -> Value? {
//        guard index >= 0 else {
//            fatalError("Negative OrderedDictionary index is out of range")
//        }
//        
//        guard index <= count else {
//            fatalError("OrderedDictionary index out of range")
//        }
//        
//        let (key, value) = (newElement.0, newElement.1)
//        
//        let adjustedIndex: Int
//        let currentValue: Value?
//        
//        if let currentIndex = _orderedKeys.index(of: key) {
//            currentValue = _keysToValues[key]
//            adjustedIndex = (currentIndex < index - 1) ? index - 1 : index
//            
//            _orderedKeys.remove(at: currentIndex)
//            _keysToValues[key] = nil
//        } else {
//            currentValue = nil
//            adjustedIndex = index
//        }
//        
//        _orderedKeys.insert(key, at: adjustedIndex)
//        _keysToValues[key] = value
//        
//        return currentValue
//    }
//    
//    public mutating func updateElement(_ element: Element, atIndex index: Index) -> Element? {
//        guard let currentElement = elementAtIndex(index) else {
//            fatalError("OrderedDictionary index out of range")
//        }
//        
//        let (newKey, newValue) = (element.0, element.1)
//        
//        _orderedKeys[index] = newKey
//        _keysToValues[newKey] = newValue
//        
//        return currentElement
//    }
//    
//    public mutating func removeAtIndex(_ index: Index) -> Element? {
//        if let element = elementAtIndex(index) {
//            _orderedKeys.remove(at: index)
//            _keysToValues.removeValue(forKey: element.0)
//            
//            return element
//        } else {
//            return nil
//        }
//    }
//    
//    // ======================================================= //
//    // MARK: - Description
//    // ======================================================= //
//    
//    public var description: String {
//        let content = map({ "\($0.0): \($0.1)" }).joined(separator: ", ")
//        return "[\(content)]"
//    }
//    
//    // ======================================================= //
//    // MARK: - Backing Store
//    // ======================================================= //
//    
//    /// The backing store for the ordered keys.
//    fileprivate var _orderedKeys = [Key]()
//    
//    /// The backing store for the mapping of keys to values.
//    fileprivate var _keysToValues = [Key: Value]()
//    
//    // ======================================================= //
//    // MARK: - SequenceType & Indexable Conformance
//    // ======================================================= //
//    
//    public func makeIterator() -> AnyIterator<Element> {
//        var nextIndex = 0
//        let lastIndex = self.count
//        
//        return AnyIterator {
//            guard nextIndex < lastIndex else { return nil }
//            
//            let nextKey = self._orderedKeys[nextIndex]
//            
//            guard let nextValue = self._keysToValues[nextKey] else {
//                fatalError("Inconsistency error occured in OrderedDictionary")
//            }
//            
//            let element = (nextKey, nextValue)
//            
//            nextIndex += 1
//            
//            return element
//        }
//    }
//    
//    public var startIndex: Index {
//        return _orderedKeys.startIndex
//    }
//    
//    public var endIndex: Index {
//        return _orderedKeys.endIndex
//    }
//    
//}
//
//public func == <Key: Equatable, Value: Equatable>(lhs: OrderedDictionary<Key, Value>, rhs: OrderedDictionary<Key, Value>) -> Bool {
//    return lhs._orderedKeys == rhs._orderedKeys && lhs._keysToValues == rhs._keysToValues
//}

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
    
    /**
     Just gets a random item from array
     */
    public func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

// MARK: - Shuffle Array

/**
 - usage:
     let x = [1, 2, 3].shuffled()
     // x == [2, 3, 1]
     
     let fiveStrings = stride(from: 0, through: 100, by: 5).map(String.init).shuffled()
     // fiveStrings == ["20", "45", "70", "30", ...]
     
     var numbers = [1, 2, 3, 4]
     numbers.shuffle()
     // numbers == [3, 2, 1, 4]
 */
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    public mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    public func shuffledArray() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

/**
 *
 * Remove Duplicates https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array
 *let numbers = [1, 5, 3, 4, 5, 1, 3]
 *  let unique = numbers.removingDuplicates()
 */
extension Array where Element: Hashable {
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

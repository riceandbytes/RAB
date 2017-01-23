//
//  CollectionType+Utility.swift
//  RAB
//

extension Collection {
    
    // Usage:
    /// let array = [1, 2, 3]
    //
    //    for index in -20...20 {
    //    if let item = array[safe: index] {
    //    print(item)
    //    }
    //    }
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex
            ? self[index]
            : nil
    }
}

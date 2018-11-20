//
//  UITableView+Utility.swift
//  RAB
//


import Foundation

extension UITableView {
    
    /**
     Use this when you have a custom cell that you need to get subview
     frame width or height value, but when you print the value
     its not giving the correct frame it shows the frame size from
     autolayout
     */
    public func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
}

public extension UITableViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

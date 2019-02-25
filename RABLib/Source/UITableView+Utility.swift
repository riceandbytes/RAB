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
    
    /// Check to see if table view is visible need to check last index
    /// https://stackoverflow.com/questions/9831485/best-way-to-check-if-uitableviewcell-is-completely-visible
    public func isTableViewVisible(needLastIndex: IndexPath) -> Bool {
        let completelyVisible = self.bounds.contains(self.rectForRow(at: needLastIndex))
        return completelyVisible
    }
}

public extension UITableViewCell {
    /// Generated cell identifier derived from class name
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

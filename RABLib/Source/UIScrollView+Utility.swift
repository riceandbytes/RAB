//
//  UIScrollView+Utility.swift
//  RAB


import Foundation

extension UIScrollView {
    
    /**
     Animates scroll to top
     */
    public func scrollToTop(animated: Bool = true) {
        let p = CGPoint(x: 0, y: -self.contentInset.top)
        self.setContentOffset(p, animated: animated)
    }

    public func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: max(contentSize.height, 0))
        setContentOffset(bottomOffset, animated: animated)
    }

    public var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    public var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    public var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    public var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

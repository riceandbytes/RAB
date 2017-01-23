//
//  UICollectionView+Utility.swift
//  RAB
//
//  Created by visvavince on 9/7/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    // remove cell at index and update
    //
    public func removeAtIndex(_ i: Int) {
        let indexPath: IndexPath = IndexPath(row: i, section: 0)
        self.performBatchUpdates({
            self.deleteItems(at: [indexPath])
            }, completion: {
                (finished: Bool) in
                self.reloadItems(at: self.indexPathsForVisibleItems)
        })
    }
}

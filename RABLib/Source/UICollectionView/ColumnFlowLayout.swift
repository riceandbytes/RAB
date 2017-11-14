//
//  ColumnFlowLayout.swift
//  RABLib
//
//  Created by visvavince on 11/13/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

/**
 Usage:
 
   let columnLayout = ColumnFlowLayout(
        cellsPerRow: 5,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    collectionView?.collectionViewLayout = columnLayout
 */

public class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    override public var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return super.itemSize }
            let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            return CGSize(width: itemWidth, height: itemWidth)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    public init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
        return context
    }
    
}

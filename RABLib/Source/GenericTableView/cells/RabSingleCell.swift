//
//  SingleCell.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public struct RabSingleCellModel {
    var title: String
    var alignment: NSTextAlignment
    var font: UIFont
    var textColor: UIColor
    var rowHeight: CGFloat
    
    public init(title: String, alignment: NSTextAlignment, font: UIFont, textColor: UIColor) {
        self.title = title
        self.alignment = alignment
        self.font = font
        self.textColor = textColor
        self.rowHeight = 88
    }
}

open class RabSingleCell: UITableViewCell {
    @IBOutlet weak var titleLabel_height: NSLayoutConstraint!  // default 88
    @IBOutlet weak var titleLabel: UILabel!
    open func configure(_ dataRow: DataRow) {
        guard let model = dataRow.model as? RabSingleCellModel else {
            pAssert(false, "Invalid Model Type")
            return
        }
        
        titleLabel_height.constant = model.rowHeight
        titleLabel.text = model.title
        titleLabel.textAlignment = model.alignment
        titleLabel.font = model.font
        titleLabel.textColor = model.textColor
    }
}

extension RabSingleCell: DataSourceProtocol {
    public static func type() -> String {
        return RabSingleCell.className
    }
}

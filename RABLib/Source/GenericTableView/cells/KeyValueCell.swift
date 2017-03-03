//
//  KeyValueCell.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit

open class KeyValueCell: UITableViewCell {
    static let kValue = "value"
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    open func configure(_ dataRow: DataRow) {
        keyLabel.text = dataRow.title
        valueLabel.text = (dataRow[KeyValueCell.kValue] as? String) ?? ""
    }
}

extension KeyValueCell: DataSourceProtocol {
    public static func type() -> String {
        return KeyValueCell.className
    }
}

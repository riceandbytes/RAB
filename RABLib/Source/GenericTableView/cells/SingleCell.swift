//
//  SingleCell.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

open class SingleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    func configure(_ dataRow: DataRow) {
        titleLabel.text = dataRow.title
    }
}

//
//  PicWithInfoCell.swift
//  RAB
//
//  Created by visvavince on 12/20/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

// Remember if you adjust you need update the calculation for cell height
//
class PicWithInfoCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!

    func configure(_ dataRow: DataRow) {
        self.selectionStyle = .none
        
        if let data = dataRow.get("userInfo") as? String {
            self.userInfoLabel.text = data
        } else {
            self.userInfoLabel.text = ""
        }
        
        if let data = dataRow.get("info") as? String {
            self.infoLabel.text = data
        } else {
            self.infoLabel.text = ""
        }
    }
}

extension PicWithInfoCell: DataSourceProtocol {
    static func type() -> String {
        return PicWithInfoCell.className
    }
}

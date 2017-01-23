//
//  TitleWithPicCell.swift
//  RAB
//
//  Created by visvavince on 12/9/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
//import Kingfisher

class TitleWithPicCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pic: UIImageView!
    
    func configure(_ dataRow: DataRow) {
//        self.selectionStyle = .None

//        titleLabel.text = dataRow.title
//        
//        if let data = dataRow.get("url") as? String {
//            if let url = NSURL(string: data) {
//                pic.kf_setImage(with:url, placeholder: nil)
//            }
//        }
    }
}

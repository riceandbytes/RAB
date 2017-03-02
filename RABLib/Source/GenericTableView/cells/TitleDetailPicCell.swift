//
//  TitleDetailPicCell.swift
//  RAB
//
//  Created by visvavince on 12/10/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

class TitleDetailPicCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var picView: UIImageView!
    
    func configure(_ dataRow: DataRow) {
//        titleLabel.text = dataRow.title
//        
//        if let data = dataRow.get("url") as? String {
//            if let url = NSURL(string: data) {
//                picView.kf_setImage(with:url, placeholder: nil)
//            }
//            
//        }
//        
//        if let data = dataRow.get("detail") as? String {
//            detailLabel.text = data
//        }
    }
}

extension TitleDetailPicCell: DataSourceProtocol {
    static func type() -> String {
        return TitleDetailPicCell.className
    }
}

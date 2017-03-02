//
//  SinglePicCell.swift
//  RAB
//
//  Created by visvavince on 12/6/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

open class SinglePicCell: UITableViewCell {
    @IBOutlet weak var singlePic: UIImageView!
    func configure(_ dataRow: DataRow) {
//        if let data = dataRow.get("url") as? String {
//            if let refererUrl = dataRow.get("referer") as? String {
//                let downloader = KingfisherManager.sharedManager.downloader
//                // Download process will timeout after 5 seconds. Default is 15.
//                // downloader.downloadTimeout = 5
//                // requestModifier will be called before image download request made.
//                downloader.requestModifier = {
//                    (request: NSMutableURLRequest) in
//                    request.addValue(refererUrl, forHTTPHeaderField: "referer")
//                }
//                if let url = NSURL(string: data) {
//                    singlePic.kf_setImage(with:url,
//                        placeholder: nil, options: [KingfisherOptionsInfoItem.Downloader(downloader)])
//                }
//            } else {
//                if let url = NSURL(string: data) {
//                    singlePic.kf_setImage(with:url,
//                        placeholder: nil,
//                        options: [.ForceRefresh])
//                }
//            }
//        }
    }
}

extension SinglePicCell: DataSourceProtocol {
    public static func type() -> String {
        return SinglePicCell.className
    }
}

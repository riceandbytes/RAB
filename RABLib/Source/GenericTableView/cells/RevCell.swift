//
//  RevCell.swift
//  RAB
//
//  Created by visvavince on 12/27/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation
//import Kingfisher

open class RevCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeSincePost: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    open func configure(_ dataRow: DataRow) {
//        self.selectionStyle = .None
//        
//        if let data = dataRow.get("userUrl") as? String {
//            if let url = NSURL(string: data) {
//                userImage.kf_setImage(with:url,
//                    placeholder: UIImage(named: "anonymous-user-pic"))
//            }
//        }
//        
//        if let data = dataRow.get("userName") as? String {
//            userName.text = data
//        }
//        
//        if let data = dataRow.get("comment") as? String {
//            comment.text = data
//        }
    }
    
    @IBAction func actionButton1(_ sender: AnyObject) {
    }
    @IBAction func actionButton2(_ sender: AnyObject) {
    }
    @IBAction func actionButton3(_ sender: AnyObject) {
    }
    @IBAction func actionButton4(_ sender: AnyObject) {
    }
}

extension RevCell: DataSourceProtocol {
    public static func type() -> String {
        return RevCell.className
    }
}

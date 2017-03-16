//
//  UIImageView+Utility.swift
//  RAB
//
//  Created by visvavince on 3/15/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation

extension UIImageView {
    
    // MARK: Setup image view with a image and color
    // - will set a image with a tint color
    //
    public func setupImage(withName: String, withColor: UIColor) {
        let img = UIImage(named: withName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = img
        self.tintColor = withColor
    }
}

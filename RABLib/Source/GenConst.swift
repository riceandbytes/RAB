//
//  GenConst.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public struct Const {

    public static let White = UIColor(hex: "#ffffff")

    public static let GrayLight = UIColor(red:0xe6/255.0, green:0xe7/255.0, blue:0xe8/255.0, alpha:0.8 )

    public static let FontName = "HelveticaNeue"

    public static func makeFont(_ style: FontStyle, _ size: Float) -> UIFont? {
        var fontName = FontName
        if style.rawValue.characters.count > 0 {
            fontName += ("-" + style.rawValue)
        }
        return UIFont(name: fontName, size: CGFloat(size))
    }
}

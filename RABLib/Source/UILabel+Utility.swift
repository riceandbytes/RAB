//
//  UILabel+Utility.swift
//  RAB
//
//  Created by visvavince on 9/29/16.
//  Copyright © 2016 Rab LLC. All rights reserved.
//

import Foundation

extension UILabel {
    
    /**
     Helper set text, font, and color
     */
    public func setup(_ text: String,
                      _ font: UIFont,
                      _ textColor: UIColor) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    /**
     Stop clipping of letters like y or g
     */
    public func dontClipBottom() {
        // Must add this code to prevent clipping on lower part like
        // letters like g or y, even if its a single line
        self.lineBreakMode = .byClipping
        self.numberOfLines = 2
        self.minimumScaleFactor = 0.7
        self.adjustsFontSizeToFitWidth = true
    }
    
    /**
     Set HTML String
     */
    public func setHTML(_ html: String,
                        _ font: UIFont,
                        _ color: UIColor) {
        do {
            let at = try NSAttributedString(HTMLString: html,
                                            font: font,
                                            color: color)
            self.attributedText = at
        } catch {
            self.text = html
        }
    }
    
    public func setHTML(_ html: String) {
        do {
            let at = try NSAttributedString(HTMLString: html,
                                            font: nil,
                                            color: nil)
            self.attributedText = at
        } catch {
            self.text = html
        }
    }
}

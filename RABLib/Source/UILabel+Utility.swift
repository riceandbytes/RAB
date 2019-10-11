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
     Helper font, and color
     */
    public func setup(_ font: UIFont,
                      _ textColor: UIColor) {
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
    
    // MARK: - Attributed String
    
    public func attStr(_ text: String, _ font: UIFont, _ color: UIColor) {
        let att1 = [NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: color]
        let st1 = NSMutableAttributedString(string: text, attributes: att1)
        self.attributedText = st1
    }
    
    public func attStrWithSpace(_ text1: String,
                       _ font1: UIFont,
                       _ color1: UIColor,
                       _ text2: String,
                       _ font2: UIFont,
                       _ color2: UIColor) {
        let att1 = [NSAttributedString.Key.font: font1,
                    NSAttributedString.Key.foregroundColor: color1]
        let st1 = NSMutableAttributedString(string: "\(text1) ", attributes: att1)
        let att2 = [NSAttributedString.Key.font: font2,
                    NSAttributedString.Key.foregroundColor: color2]
        let st2 = NSMutableAttributedString(string: text2, attributes: att2)
        st1.append(st2)
        self.attributedText = st1
    }
}

//
//  NSAttributedString+Utility.swift
//  RAB
//
//  Created by visvavince on 9/19/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    public convenience init?(HTMLString html: String,
                             font: UIFont? = nil,
                             color: UIColor? = nil) throws {
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)
        ]
        
        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
        }
        
        
        if font != nil || color != nil {
            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
            }
            var attrs = attr.attributes(at: 0, effectiveRange: nil)
            if let font = font {
                attrs[NSAttributedStringKey.font] = font
            }
            if let color = color {
                attrs[NSAttributedStringKey.foregroundColor] = color
            }
            attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
            self.init(attributedString: attr)
        } else {
            try? self.init(data: data, options: options, documentAttributes: nil)
        }
        
    }
    
}

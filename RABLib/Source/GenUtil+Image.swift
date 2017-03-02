//
//  GenImageHelper.swift
//  RAB
//
//  Created by visvavince on 2/23/17.
//  Copyright © 2017 Rab LLC. All rights reserved.
//

import Foundation

// MARK: - Image

extension GenUtil {
    
    public class func x() {
        
    }
    
    
    //    public class func contentTypeForImageData(data: NSData) -> String? {
    //        var c: Int = 0
    //        data.getBytes(&c, length: 1)
    //
    //        switch c {
    //        case 0xFF:
    //            return "image/jpeg"
    //        case 0x89:
    //            return "image/png"
    //        case 0x47:
    //            return "image/gif"
    //        case 0x49:
    //            fallthrough
    //        case 0x4D:
    //            return "image/tiff"
    //        default:
    //            return nil
    //        }
    //    }
    
    // MARK: Find image type from NSData
    /// http://stackoverflow.com/questions/29644168/get-image-file-type-programmatically-in-swift
    public class func contentTypeForImageData(_ imgData : Data) -> String? {
        var c = [UInt8](repeating: 0, count: 1)
        (imgData as NSData).getBytes(&c, length: 1)
        let ext : String
        switch (c[0]) {
        case 0xFF:
            ext = "jpg"
        case 0x89:
            ext = "png"
        case 0x47:
            ext = "gif"
        case 0x49, 0x4D :
            ext = "tiff"
        default:
            return nil
        }
        return ext
    }
}

//
//  File.swift
//
//  Created by vince on 3/8/15.
//  Copyright (c) 2015 RAB LLC. All rights reserved.
//

import Foundation
import UIKit
import CoreImage.CIImage

extension UIImage {
    public func isPortrait() -> Bool {
        return self.size.height > self.size.width
    }
    public func isLandscape() -> Bool {
        return self.size.height < self.size.width
    }
    
    // create blank uiimage
    public func blankImage(_ _size: CGSize, _color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(_size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(_color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: _size.width, height: _size.height))
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    public func blankImage(_ _size: CGSize) -> UIImage {
        return self.blankImage(_size, _color: .white)
    }
    
    // MARK: - rotate image
    /**
     Usage: rotatedPhoto = rotatedPhoto?.imageRotatedByDegrees(90, flip: false)
     */
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        //        let radiansToDegrees: (CGFloat) -> CGFloat = {
        //            return $0 * (180.0 / CGFloat(M_PI))
        //        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap?.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap?.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap?.scaleBy(x: yFlip, y: -1.0)
        bitmap?.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension UIImage {
    
    // Change the color of the UIImage
    // Usage: theImageView.image = theImageView.image.imageWithColor(UIColor.redColor())
    
    // http://stackoverflow.com/questions/19274789/how-can-i-change-image-tintcolor-in-ios-and-watchkit
    //
    public func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(0, 0, self.size.width, self.size.height) as CGRect
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImage {
    
    public func normalize(_ newWidth: CGFloat? = nil) -> UIImage {
        
        if self.imageOrientation == UIImageOrientation.up && newWidth == self.size.width {
            return self
        }
        
        var size = self.size
        
        if let width = newWidth {
            let height = width * self.size.height / self.size.width
            size = CGSize(width: width, height: height)
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalized!
    }
    
    public func normalize(_ qual: ImageQuality) -> UIImage {
        if qual == .original {
            return normalize()
        } else {
            return normalize(qual.width)
        }
    }
}

public enum ImageQuality: Int {
    case low
    case lowMedium
    case medium
    case high
    case original
    case tiny
    case tinyLow
    
    public var width: CGFloat {
        get {
            switch self {
            case .tiny:
                return 50
            case .tinyLow:
                return 240
            case .low:
                return 480
            case .lowMedium:
                return 800
            case .medium:
                return 1024
            case .high:
                return 1920
            case .original:
                return 0
            }
        }
    }
}

// MARK: - Blur Image
extension UIImage {
    
    /**
     Add a Gussian Blur, but very SlOW, about 3 seconds
     Use UIBlurEffect, for a quicker solution but looks a bit different
     */
    public func blur(image: UIImage) -> UIImage {
        
        var returnImage: UIImage!
        
        GenUtil.timeTaken { () -> Void in
            let radius: CGFloat = 20
            let context = CIContext(options: nil)
            let inputImage = UIKit.CIImage(cgImage: image.cgImage!)
            let filter = CIFilter(name: "CIGaussianBlur");
            filter?.setValue(inputImage, forKey: kCIInputImageKey);
            filter?.setValue("\(radius)", forKey:kCIInputRadiusKey);
            let result = filter?.value(forKey: kCIOutputImageKey) as! UIKit.CIImage;
            let rect = CGRect(x: radius * 2, y: radius * 2, width: image.size.width - radius * 4, height: image.size.height - radius * 4)
            let cgImage = context.createCGImage(result, from: rect);
            returnImage = UIImage(cgImage: cgImage!);
        }
        
        return returnImage;
    }
}

// MARK: - Selfie - Face Detection

extension UIImage {
    
    /// Checks UIImage if it has a face in it
    /// - if any feature of a face is present then its a selfie
    ///
    public func isSelfie() -> Bool {
        guard let myCIImage = self.ciImage ?? CIImage(image: self) else { return false }
        let context = CIContext(options: nil)
        let detectionOptions = [ CIDetectorAccuracy: CIDetectorAccuracyHigh ]
        guard let detector = CIDetector(ofType: CIDetectorTypeFace,
                                        context: context,
                                        options: detectionOptions) else {
                                            return false
        }
        let features = detector.features(in: myCIImage)
        return features.count > 0
        // return features.count == 1 && features.first!.type == CIFeatureTypeFace
    }
}

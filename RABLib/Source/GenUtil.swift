//
//  GenUtil.swift
//  RAB
//
//  Created by RAB on 3/12/15.
//  Copyright (c) 2015 Rab LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

open class GenUtil {
    // Checks to see if current device is iphone simulator
    //
    open class func isSim() -> Bool {
        #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
            return true
        #else
            return false
        #endif
        
    }
    
    open class func generateRandomNumber() -> Int {
        let maxInt32: Int32 = 2147483647
        let val: Int32 = Int32(arc4random_uniform(UInt32(maxInt32 - 1)))
        return Int(val)
    }

    // if maxInt32 is 4, then possible values are 0, 1, 2, 3
    open class func getRandomNumber(_ maxInt32: Int32) -> Int {
        let val: Int32 = Int32(arc4random_uniform(UInt32(maxInt32)))
        return Int(val)
    }
    
    open class func joinArrayWithSeparator(_ strArray: [String], separator: String) -> String {
        return strArray.joined(separator: separator)
    }
    
    /**
     This will resign the first responder (and dismiss the keyboard) every time, without you needing to send resignFirstResponder to the proper view. No matter what, this will dismiss the keyboard. It’s by far the best way to do it: no worrying about who the first responder is.
     */
    open class func hideKeyboardAnywhere() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

// MARK: - Text Helper
extension GenUtil {
    
    public class func attStr(_ text: String, _ font: UIFont, _ color: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: font,
                                                                    NSAttributedStringKey.foregroundColor: color])
    }
}

// MARK: - Other

extension GenUtil {

    // will return string 1x or 2x or 3x
    //
    public class func findDeviceScale() -> String {
        let scale = UIScreen.main.scale
        if scale == 1 {
            return "1x"
        } else if scale == 2 {
            return "2x"
        } else if scale == 3 {
            return "3x"
        } else {
            return "2x"  // default
        }
    }
    
    // iphone 5 is 320 points width
    //
    public class func isSmallScreenWidth() -> Bool {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        if width < 380 {
            return true
        }
        
        return false
    }
    
    // MARK: Verify URL
    //
    public class func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url  = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
}

// MARK: - Check Longitutde and Latitude

extension GenUtil {
    
    // The latitude must be a number between -90 and 90 and the longitude between -180 and 180
    public class func checkLatitude(_ val: Double) -> Bool {
        if val >= -90 && val <= 90 {
            return true
        } else {
            return false
        }
    }
    
    public class func checkLongitude(_ val: Double) -> Bool {
        if val >= -180 && val <= 180 {
            return true
        } else {
            return false
        }
    }
}

// MARK: - Conversion
extension GenUtil {
    
    /**
     Converts a Month number to a Month String
     ex:
     1 -> Janurary
     
     - parameter monthIntMaybe: Month Number
     
     - returns: Month String
     */
    public class func convertNumberToMonthName(_ monthIntMaybe: Int?) -> String? {
        if let monthNumber = monthIntMaybe {
            let monthName = DateFormatter().monthSymbols[monthNumber - 1]
            return monthName
        }
        return nil
    }
    
    /**
     Converts Month name to Int
     */
    public class func convertMonthNameToNumber(_ monthName: String?) -> Int? {
        guard let mn = monthName else {
            return nil
        }
        let df = DateFormatter()
        df.dateFormat = "MMM"
        if let date = df.date(from: mn) {
            let month  = (Calendar.current as NSCalendar).component(NSCalendar.Unit.month,
                                                                from: date)
            return month
        }
        return nil
    }
}

// MARK: - NSUserDefaults Helper

extension GenUtil {
    
    public class func removeUserDefault(key: String) {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: key)
    }
    
    public class func setUserDefault(_ key: String, value: AnyObject) {
        let prefs = UserDefaults.standard
        prefs.setValue(value, forKey: key)
    }
    
    public class func getUserDefault(_ key: String) -> AnyObject? {
        let prefs = UserDefaults.standard
        return prefs.value(forKey: key) as AnyObject?
    }
    
    public class func setUserDefaultBool(_ key: String, value: Bool) {
        let prefs = UserDefaults.standard
        prefs.setValue(NSNumber(value: value), forKey: key)
    }
    
    public class func getUserDefaultBool(_ key: String) -> Bool {
        let prefs = UserDefaults.standard
        if let val = prefs.value(forKey: key) as? Bool {
            return val
        } else {
            // not a bool
            pln("not a boolean")
        }
        return false
    }
}

// MARK: - Time and Date, for more look at NSDate+Utility

extension GenUtil {
    
    public class func getUTCInSeconds() -> Int64 {
        // UNIX time format is with milliseconds
        let x = Int64(floor(Date().timeIntervalSince1970 * 1000))
        return x
    }
}

// MARK: - Time Elapsed for Testing

extension GenUtil {
    
    /**
     Usage:
     GenUtil.timeTaken("Photos") { () -> Void in
     self.setupTablePhotos()
     }
     
     - parameter label:      Name used in comments
     - parameter completion: callback
     */
    public class func timeTaken(_ label: String = "Taken", completion: () -> Void) {
        let startDate: Date = Date()

        completion()
        
        let endDate: Date = Date()
        let timeInterval: Double = endDate.timeIntervalSince(startDate)
        pWarn("-----> TIME \(label): \(timeInterval)")
    }
}

// MARK: - Numbers

//EX
//let someInt = 4, someIntFormat = "03"
//println("The integer number \(someInt) formatted with \"\(someIntFormat)\" looks like \(someInt.format(someIntFormat))")
//// The integer number 4 formatted with "03" looks like 004
//
//let someDouble = 3.14159265359, someDoubleFormat = ".3"
//println("The floating point number \(someDouble) formatted with \"\(someDoubleFormat)\" looks like \(someDouble.format(someDoubleFormat))")
//// The floating point number 3.14159265359 formatted with ".3" looks like 3.142

extension Int {
    public func format(_ f: String) -> String {
        return NSString(format: "%\(f)d" as NSString, self) as String
    }
}

extension Float {
    public func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}

extension Double {
    public func format(_ f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
}


// MARK: - Math
//
extension GenUtil {
    public class func degreesToRadians(_ degrees: Double) -> Double {
        return (Double.pi * degrees) / 180.0
    }
    
    public class func RadiansToDegrees(_ radians: Double) -> Double {
        return (radians * 180) / Double.pi
    }
    
}

// MARK: - Alerts

extension GenUtil {
    
    public class func showSimpleAlert(_ message: String, title: String = "Alert", cancelCallback: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                if let callback = cancelCallback {
                    callback()
                }
            case .destructive:
                print("destructive")
            }
        }))
        return alert
    }
    
    // usage: 
    // let vc = GenUtil.showCustomAlert(...
    // Utility.root.presentViewController(vc, ...
    //
    public class func showCustomAlert(_ message: String, title: String = "",
        okTitle: String = "Yes",
        cancelTitle: String = "Cancel",
        okCallback: (() -> Void)? = nil,
        cancelCallback: (() -> Void)? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: cancelTitle, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        
        let add = UIAlertAction(title: okTitle, style: .default) { (action: UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
            if let callback = okCallback {
                callback()
            }
        }
        alert.addAction(add)
            
        return alert
    }
}

// MARK: - Screen

extension GenUtil {
    
    public class func getHalfWidthScreen() -> CGFloat {
        return UIScreen.main.bounds.size.width/2
    }
    
    public class func getHalfHeightScreen() -> CGFloat {
        return UIScreen.main.bounds.size.height/2
    }
    
    public class func getWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public class func getHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
}

// MARK: - Video

extension GenUtil {
    
    public class func videoSize(_ url: URL) -> CGSize {
        let asset: AnyObject! = AVAsset(url: url)
        let track = asset.tracks(withMediaType: AVMediaType.video)[0]
        return track.naturalSize
    }
    
    public class func isVideoSquare(_ url: URL) -> Bool {
        let size = GenUtil.videoSize(url)
        return GenUtil.isSquare(size)
    }
    
    public class func isVideoLandscape(_ url: URL) -> Bool {
        let asset: AnyObject! = AVAsset(url: url)
        let track = asset.tracks(withMediaType: AVMediaType.video)[0]
        
        let width = track.naturalSize.width
        let height = track.naturalSize.height
        
        //check the orientation
        let txf = track.preferredTransform
        return ((width == txf.tx && height == txf.ty) || (txf.tx == 0 && txf.ty == 0))
    }
    
    /**
        Gets the actual video rect when its inside of the view
        
        :naturalSize:   natural size of the video
        :playerSize:    Rect of the view
    */
//    public class func getResizedVideoFrame(naturalSize: CGRect, playerSize: CGRect) -> CGRect {
//        let resVi: CGFloat = naturalSize.size.width / naturalSize.size.height
//        let resPl: CGFloat = playerSize.size.width / playerSize.size.height
//
//        let rect1 = CGRectMake(0, 0,
//            naturalSize.size.width * playerSize.size.height/naturalSize.size.height,
//            playerSize.size.height)
//        let rect2 =  CGRectMake(0, 0, playerSize.size.width,
//            naturalSize.size.height * playerSize.size.width/naturalSize.size.width)
//        
//        return resPl > resVi ? rect1 : rect2
//    }
     /**
     Gets the actual video rect when its inside of the view
     
     :naturalSize:   natural size of the video
     :playerSize:    Rect of the view
     */
    public class func getResizedVideoFrame(_ naturalSize: CGRect, containerSize: CGRect) -> CGRect {
        let scaleFactor = containerSize.width / naturalSize.width
        
        //        if containerSize.width > containerSize.height {
        // landscape
        return CGRect(x: 0, y: 0, width: naturalSize.width * scaleFactor, height: naturalSize.height * scaleFactor)
        //        }
        
        //        let resVi: CGFloat = naturalSize.size.width / naturalSize.size.height
        //        let resPl: CGFloat = containerSize.size.width / containerSize.size.height
        //
        //        let rect1 = CGRectMake(0, 0,
        //            naturalSize.size.width * containerSize.size.height/naturalSize.size.height,
        //            containerSize.size.height)
        //        let rect2 =  CGRectMake(0, 0, containerSize.size.width,
        //            naturalSize.size.height * containerSize.size.width/naturalSize.size.width)
        //
        //        return resPl > resVi ? rect1 : rect2
    }
}

// MARK: - CGSize

extension GenUtil {
    
    public class func isSquare(_ size: CGSize) -> Bool {
        return size.width == size.height
    }
}

// MARK: - Threading

public func doOnMain(_ block: @escaping ()->()) {
    GlobalMainQueue.async(execute: block)
}

public func doOnMainAfterTime(_ delaySeconds: Double, block: @escaping ()->()) {
    let delayTime = DispatchTime.now() + Double(Int64(delaySeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    GlobalMainQueue.asyncAfter(deadline: delayTime, execute: block)
}

public func doAsync(_ queue: DispatchQueue = GlobalUserInitiatedQueue, block: @escaping ()->()) {
    queue.async(execute: block)
}

public func doAsyncLowPri(_ block: @escaping ()->()) {
    GlobalUtilityQueue.async(execute: block)
}

public var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

/// https://developer.apple.com/library/content/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html

/// Work is virtually instantaneous.
public var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
}

/// Work is nearly instantaneous, such as a few seconds or less.
public var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated)
}

public var GlobalDefaultQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
}

/// Work takes a few seconds to a few minutes.
public var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
}

/// Work takes significant time, such as minutes or hours.
public var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
}

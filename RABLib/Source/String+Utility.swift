//
//  String+NSString.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

extension String {
    public var doubleValue: Double {
        if let number = NumberFormatter().number(from: self) {
            return number.doubleValue
        }
        return 0
    }
    
    /**
     Returns the float value of a string
     */
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    /**
     Returns the float value of a string
     */
    public var int32Value: Int32 {
        return (self as NSString).intValue
    }

    public var intValue: Int {
        return (self as NSString).integerValue
    }
    
    public var int64Value: Int64 {
        return (self as NSString).longLongValue
    }
    
    /**
     String conversion to Int
     
     self.toInt()
     */
    
    
    // MARK: - Sub Strings
    // Usage: // Now we can use integer subscripts with our extension
    //    let ch: Character = aString[15] // g
    //    let subStr1 = aString[19..<23]  // Hello
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    // for convenience we should include String return
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
     /**
     Subscript to allow for quick String substrings ["Hello"][0...1] = "He"
     */
    public subscript (r: Range<Int>) -> String {
        get {
            let start = self.index(self.startIndex, offsetBy: r.lowerBound)
            let end = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[start...end])
        }
    }
    //////////////////
    
    /**
     Removes last character of string
     
     - returns: String
     */
    public func removeLastCharacter() -> String {
        let stringLength = self.count
        let substringIndex = stringLength - 1
        let i = self.index(self.startIndex, offsetBy: substringIndex)
        return String(self[..<i])
    }
    
    /// Expose integer access to a character in a string
//    subscript(integerIndex: Int) -> Character
//        {
//            let index = characters.index(startIndex, offsetBy: integerIndex)
//            return self[index]
//    }
    
    var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    func stringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func stringByAppendingPathExtension(_ ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    // MARK: - Date Helpers
    
    public func toDate(_ format: NSDateStringStyle) -> Date? {        
        let dateFormatter = DateFormatter(style: format)
        return dateFormatter.date(from: self)
    }
    
    /**
     Converts a String of a date in ios8601 format and converts
     to a NSDate
     
     - returns: NSDate
     */
    public func toDateISO8601Format() -> Date? {
        let iso8601String = Date.dateFromISOString(self)        
        return iso8601String
    }

    /**
    This function takes care of cases when the string provided has no timezone,
    as a normal iso string from server, (notice it doesn't have ZZZZ)
    
    Note: String format should match "2013-02-19 03:50:05"
     
    This means if you pass in the string above, you will get a NSDate with the
     exact date representation.
     
     NSTimeZone(forSecondsFromGMT: 0) - this code makes sure that NSDateformatter
     does not automatically readjust by adding timezone differences
    */
    public func toDateCustomFormat_NoTimeZone() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let iso8601String = dateFormatter.date(from: self)
        return iso8601String
    }
    
    /// Convert New York date string thats passed in to a nsdate
    ///
    public func toDateCustomFormat_toNewYorkTimeZone() -> Date? {
        
        // Lets get timezone sec difference betweeen 2 locs
        guard let sourceTimeZone = TimeZone(abbreviation: "GMT") else {
            return nil
        }
        guard let destinationTimeZone = TimeZone(abbreviation: "EST") else {
            return nil
        }
        let sourceSeconds = sourceTimeZone.secondsFromGMT(for: Date())
        let destinationSeconds = destinationTimeZone.secondsFromGMT(for: Date())
        
        let interval = destinationSeconds - sourceSeconds
        
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: interval)
        let iso8601String = dateFormatter.date(from: self)
        return iso8601String
    }
    
    public func toDateCustomFormatYYYYMMDD() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let x = dateFormatter.date(from: self)
        return x
    }
    
    // MARK: - Utility

    /**
     Check for whitespaces, newlines, and tabs
     */
    public var isEmptyField: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public func contains(_ other: String) -> Bool{
        if self.range(of: other) != nil {
            return true
        } else {
            return false
        }
    }
    
    public func containsIgnoreCase(_ other: String) -> Bool{
        if self.lowercased().range(of: other) != nil {
            return true
        } else {
            return false
        }
    }
    
    public var isHasSpace: Bool {
        let whitespace = CharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        
        if let _ = range {
            return true
        } else {
            return false
        }
    }

    //    "".isAlphanumeric        // false
    //    "abc123".isAlphanumeric  // true
    //    "iOS 9".isAlphanumeric   // false
    //    
    public var isAlphanumeric: Bool {
        return range(of: "^[a-zA-Z0-9]+$", options: .regularExpression) != nil
    }
    
    // only continas numbers
    // 231312 true
    //
    public var isNumeric: Bool {
        return range(of: "^[0-9]+$", options: .regularExpression) != nil
    }
    
    public var isContainUppercase: Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
     Takes in a string that contains valid html
     
     - returns: a converted html string
     */
    public func convertHTMLtoAttributedStr(_ font: UIFont, color: UIColor = UIColor.black) -> NSMutableAttributedString? {
        do {
            guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: true
                ) else {
                    return nil
            }
            let opt: [NSAttributedString.DocumentReadingOptionKey : Any] = [.documentType: NSAttributedString.DocumentType.html,
                        NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]

            let result = try NSAttributedString(data: data, options: opt, documentAttributes: nil)
            
            // need to convert to mutable to add the font
            let final = NSMutableAttributedString(attributedString: result)
            final.addAttribute(NSAttributedStringKey.font,
                value: font,
                range: NSRange(
                    location: 0,
                    length: result.length))
            final.addAttribute(NSAttributedStringKey.foregroundColor,
                value: color,
                range: NSRange(
                    location: 0,
                    length: result.length))
            return final
        } catch _ {
            return nil
        }
    }
    
    // Clean the string of all HTML characters
    //
    public func cleanHtml() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
//    - (NSString *)truncateByWordWithLimit:(NSInteger)limit {
//    NSRange r = NSMakeRange(0, self.length);
//    while (r.length > limit) {
//    NSRange r0 = [self rangeOfString:@" " options:NSBackwardsSearch range:r];
//    if (!r0.length) break;
//    r = NSMakeRange(0, r0.location);
//    }
//    if (r.length == self.length) return self;
//    return [[self substringWithRange:r] stringByAppendingString:@"..."];
//    }
    public func truncateByWordWithLimit(_ limit: Int, trailing: String? = "...") -> String {
        if self.count > limit {
            let x = String(self[..<self.index(self.startIndex, offsetBy: limit)])
            if let r = x.range(of: " ", options: .backwards) {
                return String(x[x.startIndex..<r.lowerBound]) + (trailing ?? "")
            } else {
                return self
            }
            
        } else {
            return self
        }
    }
    
    /// Remove all non numbers from string
    ///
    public func removeAllNonNumeric() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    // Capitalize frist letter
    public func capitalizingFirstLetter() -> String {
        let first = String(self.prefix(1)).capitalized
        let other = String(self.dropFirst())
        return first + other
    }
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - URLEncoding - UrlEscape
//
public extension String {
    
    public func URLEncoded() -> String {
        
//        let characters = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
//        
//        characters.removeCharacters(in: "&")
//        
//        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: characters as CharacterSet) else {
//            return self
//        }

        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            pAssert(false, "URLEncoding failed")
            return self
        }
        return encodedString
    }
    
}

extension Character {
    
    func toInt() -> Int? {
        return Int(String(self))
    }
    
}

// MARK: - Phone Number - Website
//
public extension String {
    
    /*
        takes in the current string and formats it to a number
        
        Example:
             let number = "1234567890"
             let phone = number.toPhoneNumber()
             print(phone)
             // (123) 456-7890
    */
    public func toPhoneNumber() -> String {
        return replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    /**
     Calls phone number
     */
    public func openPhoneNumber() {
        if let url = URL(string: "tel://\(self)"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /**
     Opens a website
     */
    public func openWebsite() -> Bool {
        guard let url = URL(string: self) else {
            return false
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        return true
    }
}

// MARK: - Currency

extension String {
    
    // Ex: 20.345 -> $20
    public var currencyNoDecimal: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 0
        styler.maximumFractionDigits = 0
        styler.currencySymbol = "$"
        styler.numberStyle = .currency
        
        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }
        
        return self
    }
    
    public var currencyClean: NSNumber? {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        return NumberFormatter().number(from: stringWithoutComma)
    }
    
    // Ex: 20.34 -> $20.34
    public var currencyHasDecimal: String {
        // removing all characters from string before formatting
        let stringWithoutSymbol = self.replacingOccurrences(of: "$", with: "")
        let stringWithoutComma = stringWithoutSymbol.replacingOccurrences(of: ",", with: "")
        
        let styler = NumberFormatter()
        styler.minimumFractionDigits = 2
        styler.maximumFractionDigits = 2
        styler.currencySymbol = "$"
        styler.numberStyle = .currency
        
        if let result = NumberFormatter().number(from: stringWithoutComma) {
            return styler.string(from: result)!
        }
        
        return self
    }
}

// MARK: - More String Helpers
/* USAGE
"Awesome".contains("me") == true
"Awesome".contains("Aw") == true
"Awesome".contains("so") == true
"Awesome".contains("Dude") == false

"ReplaceMe".replace("Me", withString: "You") == "ReplaceYou"
"MeReplace".replace("Me", withString: "You") == "YouReplace"
"ReplaceMeNow".replace("Me", withString: "You") == "ReplaceYouNow"

"0123456789"[0] == "0"
"0123456789"[5] == "5"
"0123456789"[9] == "9"

"0123456789"[5...6] == "5"
"0123456789"[0...1] == "0"
"0123456789"[8...9] == "8"
"0123456789"[1...5] == "1234"
"Reply"[0...4] == "Repl"
"Hello, playground"[0...5] == "Hello"
"Coolness"[4...7] == "nes"

"Awesome".indexOf("nothin") == -1
"Awesome".indexOf("Awe") == 0
"Awesome".indexOf("some") == 3
"Awesome".indexOf("e", startIndex: 3) == 6
"Awesome".lastIndexOf("e") == 6
"Cool".lastIndexOf("o") == 2

var emailRegex = "[a-z_\\-\\.]+@[a-z_\\-\\.]{3,}"
"email@test.com".isMatch(emailRegex, options: NSRegularExpressionOptions.CaseInsensitive) == true
"email-test.com".isMatch(emailRegex, options: NSRegularExpressionOptions.CaseInsensitive) == false

var testText = "email@test.com, other@test.com, yet-another@test.com"
var matches = testText.getMatches(emailRegex, options: NSRegularExpressionOptions.CaseInsensitive)
matches.count == 3
testText.subString(matches[0].range.location, length: matches[0].range.length) == "email@test.com"
testText.subString(matches[1].range.location, length: matches[1].range.length) == "other@test.com"
testText.subString(matches[2].range.location, length: matches[2].range.length) == "yet-another@test.com"

"Reply".pluralize(0) == "Replies"
"Reply".pluralize(1) == "Reply"
"Reply".pluralize(2) == "Replies"
"REPLY".pluralize(3) == "REPLIES"
"Horse".pluralize(2) == "Horses"
"Boy".pluralize(2) == "Boys"
"Cut".pluralize(2) == "Cuts"
"Boss".pluralize(2) == "Bosses"
"Domino".pluralize(2) == "Dominoes"
*/
/*
public extension String
{
    public var length: Int {
        get {
            return countElements(self)
        }
    }
    
    public func contains(s: String) -> Bool
    {
        return self.rangeOfString(s) ? true : false
    }
    
    public func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    public subscript (i: Int) -> Character
        {
        get {
            let index = advance(startIndex, i)
            return self[index]
        }
    }
    
    public subscript (r: Range<Int>) -> String
        {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(self.startIndex, r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    public func subString(startIndex: Int, length: Int) -> String
    {
        var start = advance(self.startIndex, startIndex)
        var end = advance(self.startIndex, startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    public func indexOf(target: String) -> Int
    {
        var range = self.rangeOfString(target)
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    public func indexOf(target: String, startIndex: Int) -> Int
    {
        var startRange = advance(self.startIndex, startIndex)
        
        var range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    public func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    public func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)
        
        if let error = error {
            println(error.description)
        }
        var matchCount = exp.numberOfMatchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    public func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)
        
        if let error = error {
            println(error.description)
        }
        var matches = exp.matchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matches as [NSTextCheckingResult]
    }
    
    private var vowels: [String]
        {
        get
        {
            return ["a", "e", "i", "o", "u"]
        }
    }
    
    private var consonants: [String]
        {
        get
        {
            return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
        }
    }
    
    public func pluralize(count: Int) -> String
    {
        if count == 1 {
            return self
        } else {
            var lastChar = self.subString(self.length - 1, length: 1)
            var secondToLastChar = self.subString(self.length - 2, length: 1)
            var prefix = "", suffix = ""
            
            if lastChar.lowercaseString == "y" && vowels.filter({x in x == secondToLastChar}).count == 0 {
                prefix = self[0...self.length - 1]
                suffix = "ies"
            } else if lastChar.lowercaseString == "s" || (lastChar.lowercaseString == "o" && consonants.filter({x in x == secondToLastChar}).count > 0) {
                prefix = self[0...self.length]
                suffix = "es"
            } else {
                prefix = self[0...self.length]
                suffix = "s"
            }
            
            return prefix + (lastChar != lastChar.uppercaseString ? suffix : suffix.uppercaseString)
        }
    }
}
*/

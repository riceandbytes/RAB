//
//  NSDate+Utility.swift
//  RAB
//
//  Created by RAB on 11/8/15.
//  Copyright © 2015 Rab LLC. All rights reserved.
//

import Foundation

public struct Duration {
    public var years: Int = 0
    public var days: Int = 0
    public var hours: Int = 0
    public var minutes: Int = 0
    public var seconds: Int = 0
    
    public init(_ duration: String) {
        var vals = duration.split { $0 == ":" }.map{ String($0) }
        
        if vals.count == 3 {
            if let hr = Int(vals[0]) {
                if let min = Int(vals[1]) {
                    if let sec = Int(vals[2]) {
                        self.hours = hr
                        self.minutes = min
                        self.seconds = sec
                    }
                }
            }
        }
    }
    
    public init(seconds: Int) {
        self.days = Int(seconds / 3600 / 24)
        self.hours = Int(seconds / 3600)
        self.minutes = (seconds / 60) % 60
        self.seconds = seconds % 60
    }
    
    public init(years: Int) {
        self.years = years
    }
    public var inMinutes: Double {
        get {
            return Double(inSeconds) / 60.0
        }
    }
    
    /// Get the duration in seconds
    public var inSeconds: Int {
        get {
            let totalDays = years * 365 + self.days
            let totalHours = totalDays * 24 + hours
            let totalMins = totalHours * 60 + minutes
            return totalMins * 60 + seconds
        }
    }
    
    public func stringValue() -> String {
        return String(format:"%02d:%02d:%02d", self.hours, self.minutes, self.seconds)
    }
    
    public func elapsedString() -> String {
        var string = ""
        var suffix = "min"
        if hours > 0 {
            string += "\(hours):"
            suffix = "hr"
        }
        
        return string + String(format:"%02d:%02d %@", self.minutes, self.seconds, suffix)
    }
}

//http://nsdateformatter.com/

public enum NSDateStringStyle {

    /// ex: 2016-11-28
    case yearMonDay

    /// ex: Sep 30, 2016
    case shortMonDayYear
    
    /// Birthday Style
    /// example: May 30, 1999
    case monthDayYear
    
    /// Time only like: 9:00 pm
    case time
    
    /// Year only
    case year
    
    /// Used for displaying milliseconds .. useful for printing date/time for debugging
    /// format: yyyy-MM-dd'T'HH:mm:ss.SSS
    case debug
    
    /// ISO Formatted string, timezone GMT
    /// format: yyyy-MM-dd'T'HH:mm:ss.SSSZ
    case isoDateTimeUTC
    
    
    /// ISO Formatted string, year month day only
    /// format: yyyy-MM-dd
    case isoMonthDayYear
    
    /// 02/12/17 08:48:48 PM
    case full
    
    /// 02/12/17 08:48 PM
    case fullNoSec
    
    /// ex: 2016-11-28 -> 11/28
    case veryShortDayMon
    
    /// 11/28/18
    case shortDayMonYr
}

extension DateFormatter {
    convenience init(style: NSDateStringStyle) {
        self.init()
        switch style {
        // hh is for 12 hour and HH is for 24 hour
        case .time:
            self.dateFormat = "hh:mm a"
        case .yearMonDay:
            self.dateFormat = "yyyy-MM-dd"
        case .shortMonDayYear:
            self.dateFormat = "MMM d, yyyy"
        case .monthDayYear:
            self.doesRelativeDateFormatting = false
            self.dateStyle = DateFormatter.Style.medium
            self.timeStyle = DateFormatter.Style.none
//            self.timeZone = TimeZone(abbreviation: "GMT")
        case .year:
            self.dateStyle = DateFormatter.Style.short
            self.timeStyle = DateFormatter.Style.none
        case .full:
            self.dateFormat = "MM/dd/yy hh:mm:ss a"
        case .debug:
            self.dateFormat = "MM/dd/yy HH:mm:ss:SSS"
        case .isoDateTimeUTC:
            self.locale = Locale(identifier: "en_US_POSIX")
//            self.timeZone = TimeZone(abbreviation: "GMT")
            self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .isoMonthDayYear:
            self.dateFormat = "yyyy-MM-dd"
        case .fullNoSec:
            self.dateFormat = "MM/dd/yy hh:mm a"
        case .veryShortDayMon:
            self.dateFormat = "d/M"
        case .shortDayMonYr:
            self.dateFormat = "d/M/yy"
        }
    }
}

public extension Date {
    
    // Calculates age based on date to todays date
    public func getAge() -> String {
        let birthdate = self
        let todaydate = Date()
        let time = todaydate.timeIntervalSince(birthdate)
        let allDays = (((time/60)/60)/24)
        let days = allDays.truncatingRemainder(dividingBy: 365)
        let years = (allDays-days)/365
        print("You lived since \(years) years and \(days).")
        return "\(Int(years))"
    }
    
    // MARK: toString - CONVERTS DATE TO ALL TYPES OF STRING FORMATS
    // Use this to convert Date to Different String Styles
    // look at the enum type for more description on what styles it can
    // produce
    //
    public func toString(_ format: NSDateStringStyle, timeZone: String? = nil) -> String {
        let dateFormatter = DateFormatter(style: format)

        if let tz = timeZone {
            dateFormatter.timeZone = TimeZone(abbreviation: tz)
        }
        return dateFormatter.string(from: self)
    }
    
    public func toShortString() -> String {
        let dateFormatter = DateFormatter()
        let theDateFormat = DateFormatter.Style.short
        let theTimeFormat = DateFormatter.Style.short
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        return dateFormatter.string(from: self)
    }
    
    // Convert UTC (or GMT) to local time
    public func toLocalTime() -> Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    public func toGlobalTime() -> Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    public func ISOStringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self) + "Z"
    }

//    public class func dateFromISOString(string: String) -> NSDate {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        
//        return dateFormatter.dateFromString(string)
//    }
    
    /**
     Used when a string looks like this "yyyy-MM-dd HH:mm:ss"
     */
    public static func dateFromISOStringSpecial1(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.date(from: string)
    }
    
    /**
     Used when a string looks like this yyyy-MM-dd'T'HH:mm:ss.SSSZ
     */
//    public class func dateFromISOString(string: String) -> NSDate? {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
//        dateFormatter.timeZone = NSTimeZone.localTimeZone()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        
//        return dateFormatter.dateFromString(string)
//    }

    /**
     Use when matching 2016-06-10T18:42:49Z US Eastern Standard Time
     http://www.iso.org/iso/home/standards/iso8601.htm
     http://stackoverflow.com/questions/28016578/swift-how-to-create-a-date-time-stamp-and-format-as-iso-8601-rfc-3339-utc-tim
     */
    public static func dateFromISOString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"        
        return dateFormatter.date(from: string)
    }
    
    /**
     Use when string looks like this yyyy-MM-dd
     */
    public static func dateFromISODateString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: string)
    }
    
    public func plus(_ duration: Duration) -> Date {
        return plus(days: duration.days, hr: duration.hours, min: duration.minutes, sec: duration.seconds)
    }
    
    public func minus(_ duration: Duration) -> Date {
        return minus(days: duration.days, hr: duration.hours, min: duration.minutes, sec: duration.seconds)
    }
    
    public func plus(days: Int = 0, hr: Int = 0, min: Int = 0, sec: Int = 0) -> Date {
        var comps = DateComponents()
        comps.hour = hr
        comps.minute = min
        comps.second = sec
        comps.day = days
        return (Calendar.current as NSCalendar).date(byAdding: comps, to: self, options: [])!
    }
    
    public func minus(days: Int = 0, hr: Int = 0, min: Int = 0, sec: Int = 0) -> Date {
        return plus(days: -days, hr: -hr, min: -min, sec: -sec)
    }
    
    public func isYesterday() -> Bool {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        
        let enteredDate = self
        let today = Date()
        
        let result = today.compare(enteredDate)
        
        switch (result) {
        case .orderedAscending:
            break
        case .orderedDescending:
            return true
        case .orderedSame:
            break
        }
        return false
    }
    
    public func getYear() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: self)
        return components.year!
    }
    
    public func getMonth() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: self)
        return components.month!
    }
    
    public func getDay() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.day , .month , .year], from: self)
        
//        let year =  components.year
//        let month = components.month
        return components.day!
        
//        print(year)
//        print(month)
//        print(day)
    }
    
    // example:
    // true when ex: today date is 10/30 and self date is 10/29
    // so true when 10/29 <= (10/30)
    public func dateHasPassedToday() -> Bool {
        if self <= Date() {
            return true
        } else {
            return false
        }
    }
    
    // check if this date is between these dates
    //
    public func isBetweenDates(startDate: Date, endDate: Date) -> Bool {
        let fallsBetween = (startDate...endDate).contains(self)
        return fallsBetween
    }
}

public extension Date {

    // Add 1 year to current nsdate
    //
    public func addYears(_ year: Int) -> Date? {
        let startDate = self
        var dateComponent = DateComponents()
        dateComponent.year = year
        let cal = Calendar.current
        return (cal as NSCalendar).date(byAdding: dateComponent, to: startDate, options: NSCalendar.Options(rawValue: 0))
    }

    // - param Float because you can have .5 hour offset
    public func addHours(_ hours: Int) -> Date? {
        let startDate = self
        var dateComponent = DateComponents()
        dateComponent.hour = hours
        let cal = Calendar.current
        return (cal as NSCalendar).date(byAdding: dateComponent, to: startDate, options: NSCalendar.Options(rawValue: 0))
    }

    // use this when you have a time that is a local port and you have
    // the offset
    public func addHoursInverse(_ hoursOffset: Float) -> Date? {
        // need to convert hours to seconds becuase date component for hours
        // is only Int
        let secs: Int = Int(hoursOffset * 60 * 60) * -1
        return self.addSeconds(secs)
    }
    
    public func addHours(_ hours: Float) -> Date? {
        // need to convert hours to seconds becuase date component for hours
        // is only Int
        let secs: Int = Int(hours * 60 * 60)
        return self.addSeconds(secs)
    }

    public func addSecondsInverse(_ sec: Int) -> Date? {
        return addSeconds(sec * -1)
    }
    
    public func addSeconds(_ sec: Int) -> Date? {
        let startDate = self
        var dateComponent = DateComponents()
        dateComponent.second = sec
        let cal = Calendar.current
        return (cal as NSCalendar).date(byAdding: dateComponent, to: startDate, options: NSCalendar.Options(rawValue: 0))
    }
    
    /**
     Self is date in the past
     
     - param: timezone: should be in format "America/New_York"
     - returns: Date String
     */
    public func timeFromDateTillNow(_ currentDate: Date) -> String? {
        // http://nshipster.com/nscalendar-additions/
        //
        let gregorianCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        if let comp = (gregorianCalendar as NSCalendar?)?.components([.hour, .minute, .second, .day, .month, .year], from: self, to: currentDate, options: NSCalendar.Options.searchBackwards) {
         
            if comp.year != 0 {
                return "\(comp.year! < 0 ? 0 : comp.year!)yr"
            } else if comp.month != 0 {
                return "\(comp.month! < 0 ? 0 : comp.month!)mo"
            } else if comp.day != 0 {
                return "\(comp.day! < 0 ? 0 : comp.day!)d"
            } else if comp.hour != 0 {
                let hour = comp.hour! < 0 ? 0 : comp.hour!
                if hour <= 0 {
                    return "now"
                } else {
                    return "\(hour)h"
                }
            } else if comp.minute != 0 {
                let x = comp.minute! < 0 ? 0 : comp.minute!
                if x <= 0 {
                    return "now"
                } else {
                    return "\(x)m"
                }
            } else {
                let x = comp.second! < 0 ? 0 : comp.second!
                if x <= 0 {
                    return "now"
                } else {
                    return "\(x)s"
                }
            }
        } else {
            return nil
        }
    }
    
//    public func getYear() -> Int {
//        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
//        return gregorianCalendar?.component([.Year], fromDate: self) ?? 0
//    }
    
    public func getCurrentDateInSystemTimezone() -> Date? {
        let sourceDate = Date()
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = TimeZone.current
        
        let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let interval: Double = Double(destinationGMTOffset - sourceGMTOffset!)
        
        let destinationDate = Date(timeInterval: interval, since: sourceDate)
        return destinationDate
    }
    
    
    public func getCurrentDateForTimezone(_ timeZoneStr: String) -> Date? {
        let sourceDate = self
        let sourceTimeZone = TimeZone(abbreviation: "GMT")
        let destinationTimeZone = TimeZone(identifier: timeZoneStr)!
        
        let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: sourceDate)
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: sourceDate)
        let interval: Double = Double(destinationGMTOffset - sourceGMTOffset!)
        
        let destinationDate = Date(timeInterval: interval, since: sourceDate)
        return destinationDate
    }
}

extension Date {

//    public func dateWithOutTime() -> Date {
//        let x: Set<Calendar.Component> = [.year, .month, .day]
//        let comps = Calendar.current.dateComponents(x, from: self)
//        return Calendar.current.date(from: comps)!
//    }
    
    /// MARK: - Find number of days between 2 NSDates
    /// https://www.timeanddate.com/date/duration.html
    /// Usage: Date().numberOfDaysUntilDateTimeAdjusted(sd, inTimeZone: TimeZone(abbreviation: "UTC"))
    ///
    public func numberOfDaysUntilDateTimeAdjusted(_ toDateTimeUTC: Date, inTimeZone timeZone: TimeZone? = nil) -> Int {
        var calendar = Calendar.current
        let adjustedDate = toDateTimeUTC
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let comps: Set<Calendar.Component> = [Calendar.Component.day]
        let components = calendar.dateComponents(comps, from: Date(), to: adjustedDate)
        return components.day ?? 0  // This will return the number of day(s) between dates
    }
    
    // Better use of days inbetween
    // - Value can be negative
    //
    public func daysBetween(_ endDate: Date) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: .day, in: .era, for: self) else {
            return 0
        }
        
        // need to pad 12 hours to endDate to adjust for UTC
        guard let endDateAdj = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: endDate) else {
            return 0
        }

        guard let end = calendar.ordinality(of: .day, in: .era, for: endDateAdj) else {
            return 0
        }
        
        let val = abs(end - start)
        return val
    }
    
    public func daysBetweenIncludingStartDay(_ endDate: Date) -> Int {
        return self.daysBetween(endDate) + 1
    }
}

extension Date {
    
    // usage let today = Date() // date is then today for this example
    //    let tomorrow = today.add(days: 1)
    
    /// Returns a Date with the specified days added to the one it is called with
    public func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    public func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }

    // MARK: Zero out time - removes the time from the date
    // http://stackoverflow.com/questions/4187478/truncate-nsdate-zero-out-time
    //
    public func trimTime() -> Date {
        let x: Set<Calendar.Component> = [.year, .month, .day]
        
        var comps =  Calendar.current.dateComponents(x, from: self)
        comps.timeZone = TimeZone(abbreviation: "GMT")
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        return Calendar.current.date(from: comps)!
    }
    
    /// MARK: Sets the exact time
    ///
    /// ex:
    /// pass 9, 30, 0  -> time will be 9:30:00 in your locale
    ///
    public func setTimeExact(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)

        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        // Change the time to 9:30:00 in your locale
        components.hour = hour
        components.minute = min
        components.second = sec

        return cal.date(from: components)
    }
}

// MARK: - Find Time Between Two Dates
// 
// ex:
//let date1 = Calendar.current.date(era: 1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//let date2 = Calendar.current.date(era: 1, year: 2015, month: 8, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//
//let years = date2.years(from: date1)     // 0
//let months = date2.months(from: date1)   // 9
//let weeks = date2.weeks(from: date1)     // 39
//let days = date2.days(from: date1)       // 273
//let hours = date2.hours(from: date1)     // 6,553
//let minutes = date2.minutes(from: date1) // 393,180
//let seconds = date2.seconds(from: date1) // 23,590,800
//
//let timeOffset = date2.offset(from: date1) // "9M"
//
//let date3 = Calendar.current.date(era: 1, year: 2014, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//let date4 = Calendar.current.date(era: 1, year: 2015, month: 11, day: 28, hour: 5, minute: 9, second: 0, nanosecond: 0)!
//
//let timeOffset2 = date4.offset(from: date3) // "1y"
//
// Using Date Formatter:
//let dateComponentsFormatter = DateComponentsFormatter()
//dateComponentsFormatter.allowedUnits = [.year,.month,.weekOfYear,.day,.hour,.minute,.second]
//dateComponentsFormatter.maximumUnitCount = 1
//dateComponentsFormatter.unitsStyle = .full
//dateComponentsFormatter.string(from: Date(), to: Date(timeIntervalSinceNow: 4000000))  // "1 month"
//
extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

// MARK: - Date Helpers

extension Date {

    // MARK: Shows extact time difference between two dates like "1h 59m 20s" ago

    public func offsetFrom(date: Date) -> (months: Int, days: Int, hours: Int) {
        let adjustedDate = date
        let unitFlags = Set<Calendar.Component>([.month, .day, .hour])
        var diff = NSCalendar.current.dateComponents(unitFlags, from: self, to: adjustedDate)
        return (abs(diff.month ?? 0), abs(diff.day ?? 0), abs(diff.hour ?? 0))
    }
    
    // MARK: Get Start and End of Day
    
    // usage: 
    // let pred = NSPredicate(format: "(createdAt => %@) AND (createdAt <= %@)", Date().startOfDay() as NSDate, Date().endOfDay() as NSDate)

    public func startOfDay() -> Date {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlags: NSCalendar.Unit = [.minute, .hour, .day, .month, .year]
        var todayComponents = gregorian!.components(unitFlags, from: self)
        todayComponents.hour = 0
        todayComponents.minute = 0
        return (gregorian?.date(from: todayComponents))!
    }
    
    public func endOfDay() -> Date {
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlags: NSCalendar.Unit = [.minute, .hour, .day, .month, .year]
        var todayComponents = gregorian!.components(unitFlags, from: self)
        todayComponents.hour = 23
        todayComponents.minute = 59
        return (gregorian?.date(from: todayComponents))!
    }
    
    /**
     Uses Date() object and check to see how
     many days are in this month
     */
    public func howManyDaysInMonth() -> Int {
        let cal = Calendar(identifier: .gregorian)
        let monthRange = cal.range(of: .day, in: .month, for: self)!
        let daysInMonth = monthRange.count
        return daysInMonth
    }
    
    /**
     Creates date object using day, month, year
     
     - Usage:
        let monthCheck = Date.make(day: 1, month: monthInt, year: yearInt)
     */
    public static func make(day: Int, month: Int, year: Int) -> Date? {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        // Get NSDate given the above date components
        return NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: c)
    }
}

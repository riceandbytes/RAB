
import Foundation

/**
 Usage:
 let stringFromDate = Date().iso8601    // "2017-03-22T13:22:13.933Z"
 
 if let dateFromString = stringFromDate.dateFromISO8601 {
 print(dateFromString.iso8601)      // "2017-03-22T13:22:13.933Z"
 }
 */
extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    public var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    public var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

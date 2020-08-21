//
//  Date.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/11/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

let firebasePostDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
let firebaseGetDateFormat = "yyyy-MM-dd'T'HHmmssZ"

public extension Date {

    /// SwifterSwift: Day name format.
    ///
    /// - threeLetters: 3 letter day abbreviation of day name.
    /// - oneLetter: 1 letter day abbreviation of day name.
    /// - full: Full day name.
    enum DayNameStyle {
        case threeLetters
        case oneLetter
        case full
    }

    /// SwifterSwift: Month name format.
    ///
    /// - threeLetters: 3 letter month abbreviation of month name.
    /// - oneLetter: 1 letter month abbreviation of month name.
    /// - full: Full month name.
    enum MonthNameStyle {
        case threeLetters
        case oneLetter
        case full
    }

    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

// MARK: - Properties
public extension Date {

    /// SwifterSwift: User’s current calendar.
    var calendar: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        return calendar
    }

    /// SwifterSwift: Era.
    var era: Int {
        return calendar.component(.era, from: self)
    }

    /// SwifterSwift: Quarter.
    var quarter: Int {
        return calendar.component(.quarter, from: self)
    }

    /// SwifterSwift: Week of year.
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }

    /// SwifterSwift: Week of month.
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }

    /// SwifterSwift: Year.
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.year = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Month.
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.month = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Day.
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.day = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Weekday.
    var weekday: Int {
        get {
            return calendar.component(.weekday, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: self)
            component.weekday = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Hour.
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.hour = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Minutes.
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.minute = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Seconds.
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            var component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
            component.second = newValue
            if let date = calendar.date(from: component) {
                self = date
            }
        }
    }

    /// SwifterSwift: Nanoseconds.
    var nanosecond: Int {
        get {
            return calendar.component(.nanosecond, from: self)
        }
        set {
            if let date = calendar.date(bySetting: .nanosecond, value: newValue, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Milliseconds.
    var millisecond: Int {
        get {
            return calendar.component(.nanosecond, from: self) / 1000000
        }
        set {
            let ns = newValue * 1000000
            if let date = calendar.date(bySetting: .nanosecond, value: ns, of: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Check if date is in future.
    var isInFuture: Bool {
        return self > Date()
    }

    /// SwifterSwift: Check if date is in past.
    var isInPast: Bool {
        return self < Date()
    }

    /// SwifterSwift: Check if date is in today.
    var isInToday: Bool {
        return calendar.isDateInToday(self)
    }

    /// SwifterSwift: Check if date is within yesterday.
    var isInYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }

    /// SwifterSwift: Check if date is within tomorrow.
    var isInTomorrow: Bool {
        return calendar.isDateInTomorrow(self)
    }

    /// SwifterSwift: Check if date is within a weekend period.
    var isInWeekend: Bool {
        return calendar.isDateInWeekend(self)
    }

    /// SwifterSwift: Check if date is within a weekday period.
    var isInWeekday: Bool {
        return !calendar.isDateInWeekend(self)
    }


    /// SwifterSwift: Nearest five minutes to date.
    var nearestFiveMinutes: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 5 < 3 ? min - min % 5 : min + 5 - (min % 5)
        components.second = 0
        return calendar.date(from: components)!
    }

    /// SwifterSwift: Nearest ten minutes to date.
    var nearestTenMinutes: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute? = min % 10 < 6 ? min - min % 10 : min + 10 - (min % 10)
        components.second = 0
        return calendar.date(from: components)!
    }

    /// SwifterSwift: Nearest quarter hour to date.
    var nearestQuarterHour: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 15 < 8 ? min - min % 15 : min + 15 - (min % 15)
        components.second = 0
        return calendar.date(from: components)!
    }

    /// SwifterSwift: Nearest half hour to date.
    var nearestHalfHour: Date {
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let min = components.minute!
        components.minute! = min % 30 < 15 ? min - min % 30 : min + 30 - (min % 30)
        components.second = 0
        return calendar.date(from: components)!
    }

    /// SwifterSwift: Nearest hour to date.
    var nearestHour: Date {
        if minute >= 30 {
            return beginning(of: .hour)!.adding(.hour, value: 1)
        }
        return beginning(of: .hour)!
    }

    /// SwifterSwift: Time zone used by system.
    var timeZone: TimeZone {
        return calendar.timeZone
    }

    /// SwifterSwift: UNIX timestamp from date.
    var unixTimestamp: Double {
        return timeIntervalSince1970
    }

    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }

    init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

// MARK: - Methods
public extension Date {

    /// SwifterSwift: Date by adding multiples of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of components to add.
    /// - Returns: original date + multiples of component added.
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return calendar.date(byAdding: component, value: value, to: self)!
    }

    /// SwifterSwift: Add calendar component to date.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: multiples of compnenet to add.
    mutating func add(_ component: Calendar.Component, value: Int) {
        self = adding(component, value: value)
    }

    /// SwifterSwift: Date by changing value of calendar component.
    ///
    /// - Parameters:
    ///   - component: component type.
    ///   - value: new value of compnenet to change.
    /// - Returns: original date after changing given component to given value.
    func changing(_ component: Calendar.Component, value: Int) -> Date? {
        return calendar.date(bySetting: component, value: value, of: self)
    }

    /// SwifterSwift: Data at the beginning of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the beginning of.
    /// - Returns: date at the beginning of calendar component (if applicable).
    func beginning(of component: Calendar.Component) -> Date? {
        switch component {
            case .second:
                return calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))

            case .minute:
                return calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self))

            case .hour:
                return calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour], from: self))

            case .day:
                return calendar.startOfDay(for: self)

            case .weekOfYear, .weekOfMonth:
                return calendar.date(from:
                    calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))

            case .month:
                return calendar.date(from:
                    calendar.dateComponents([.year, .month], from: self))

            case .year:
                return calendar.date(from:
                    calendar.dateComponents([.year], from: self))

            default:
                return nil
        }
    }

    /// SwifterSwift: Date at the end of calendar component.
    ///
    /// - Parameter component: calendar component to get date at the end of.
    /// - Returns: date at the end of calendar component (if applicable).
    func end(of component: Calendar.Component) -> Date? {
        switch component {
            case .second:
                var date = adding(.second, value: 1)
                date = calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date))!
                date.add(.second, value: -1)
                return date

            case .minute:
                var date = adding(.minute, value: 1)
                let after = calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date))!
                date = after.adding(.second, value: -1)
                return date

            case .hour:
                var date = adding(.hour, value: 1)
                let after = calendar.date(from:
                    calendar.dateComponents([.year, .month, .day, .hour], from: date))!
                date = after.adding(.second, value: -1)
                return date

            case .day:
                var date = adding(.day, value: 1)
                date = calendar.startOfDay(for: date)
                date.add(.second, value: -1)
                return date

            case .weekOfYear, .weekOfMonth:
                var date = self
                let beginningOfWeek = calendar.date(from:
                    calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
                date = beginningOfWeek.adding(.day, value: 7).adding(.second, value: -1)
                return date

            case .month:
                var date = adding(.month, value: 1)
                let after = calendar.date(from:
                    calendar.dateComponents([.year, .month], from: date))!
                date = after.adding(.second, value: -1)
                return date

            case .year:
                var date = adding(.year, value: 1)
                let after = calendar.date(from:
                    calendar.dateComponents([.year], from: date))!
                date = after.adding(.second, value: -1)
                return date

            default:
                return nil
        }
    }

    /// SwifterSwift: Date string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date string.
    func dateString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Date and time string from date.
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: date and time string.
    func dateTimeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Check if date is in current given calendar component.
    ///
    /// - Parameter component: calendar component to check.
    /// - Returns: true if date is in current given calendar component.
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        return calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// SwifterSwift: Time string from date
    ///
    /// - Parameter style: DateFormatter style (default is .medium).
    /// - Returns: time string.
    func timeString(ofStyle style: DateFormatter.Style = .medium) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = style
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: self)
    }
    
    func timeHourString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        return dateFormatter.string(from: self)
    }

    func toString(_ format: String = "MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Day name from date.
    ///
    /// - Parameter Style: style of day name (default is DayNameStyle.full).
    /// - Returns: day name string (example: W, Wed, Wednesday).
    func dayName(ofStyle style: DayNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
                case .oneLetter:
                    return "EEEEE"
                case .threeLetters:
                    return "EEE"
                case .full:
                    return "EEEE"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }

    /// SwifterSwift: Month name from date.
    ///
    /// - Parameter Style: style of month name (default is MonthNameStyle.full).
    /// - Returns: month name string (example: D, Dec, December).
    func monthName(ofStyle style: MonthNameStyle = .full) -> String {
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        let dateFormatter = DateFormatter()
        var format: String {
            switch style {
                case .oneLetter:
                    return "MMMMM"
                case .threeLetters:
                    return "MMM"
                case .full:
                    return "MMMM"
            }
        }
        dateFormatter.setLocalizedDateFormatFromTemplate(format)
        return dateFormatter.string(from: self)
    }
}

extension Date {

    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }

    func isInSameYear(as date: Date) -> Bool { isEqual(to: date, toGranularity: .year) }
    func isInSameMonth(as date: Date) -> Bool { isEqual(to: date, toGranularity: .month) }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }

    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }

    var isInThisYear:  Bool { isInSameYear(as: Date()) }
    var isInThisMonth: Bool { isInSameMonth(as: Date()) }
    var isInThisWeek:  Bool { isInSameWeek(as: Date()) }

    var isInTheFuture: Bool { self > Date() }
    var isInThePast:   Bool { self < Date() }
}

// MARK: - Initializers
public extension Date {

    /// SwifterSwift: Create a new date form calendar components.
    ///
    /// - Parameters:
    ///   - calendar: Calendar (default is current).
    ///   - timeZone: TimeZone (default is current).
    ///   - era: Era (default is current era).
    ///   - year: Year (default is current year).
    ///   - month: Month (default is current month).
    ///   - day: Day (default is today).
    ///   - hour: Hour (default is current hour).
    ///   - minute: Minute (default is current minute).
    ///   - second: Second (default is current second).
    ///   - nanosecond: Nanosecond (default is current nanosecond).
    init?(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {

        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond

        if let date = calendar?.date(from: components) {
            self = date
        } else {
            return nil
        }
    }

    func dayOfMonth() -> Int {
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        return dayRange?.count ?? 0
    }

    func dayNumberOfWeek() -> Int? {
        return calendar.dateComponents([.weekday], from: self).weekday
    }

    func currentOfMonth() -> Date {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self)))!

    }

    func startOfMonth() -> Date {
        return calendar.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }

    func currentEndOfMonth() -> Date {
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.currentOfMonth())!
    }
    func getNextMonth() -> Date? {
        return calendar.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return calendar.date(byAdding: .month, value: -1, to: self)
    }

    /// SwifterSwift: Create new date object from Firebase timestamp.
    ///
    /// - Parameter firTimestamp: Firebase timestamp.
    init(firTimestamp: Double) {
        self.init(timeIntervalSince1970: firTimestamp / 1000)
    }

    /// SwifterSwift: Compare date without time.
    ///
    /// - Parameter date: Date to compare with.
    func compareIgnoreTime(date: Date) -> ComparisonResult {
        let dayOffset = self.day - date.day
        let monthOffset = self.month - date.month
        let yearOffset = self.year - date.year

        if yearOffset > 0 {
            return .orderedDescending
        } else if yearOffset < 0 {
            return .orderedAscending
        } else {
            if monthOffset > 0 {
                return .orderedDescending
            } else if monthOffset < 0 {
                return .orderedAscending
            } else {
                if dayOffset > 0 {
                    return .orderedDescending
                } else if dayOffset < 0 {
                    return .orderedAscending
                } else {
                    return .orderedSame
                }
            }
        }
    }

    func isSameDay(date: Date) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }

    func compareWithTimezone(date: Date) -> ComparisonResult {
        return calendar.compare(self, to: date, toGranularity: .day)
    }

}

extension Date {
    // Calculate days between without hour (time)
    // For example if you compare the dates 2020-01-01 10:00 and 2020-01-02 09:00
    // days between those dates will return as 1 (one) because it is calculated
    // between 2020-01-01 00:00 and 2020-01-02 00:00 (24 hours as 1 day)
    func daysBetween(toDate: Date) -> Int {
        // Replace the hour (time) of both dates with 00:00
        let date1 = Calendar.current.startOfDay(for: self)
        let date2 = Calendar.current.startOfDay(for: toDate)
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
    // Calculate days between with hour (time)
    // For example if you compare the dates 2020-01-01 10:00 and 2020-01-02 09:00
    // days between those dates will return as 0 (zero) since the difference
    // between those dates is less than 24 hours (it's 23 hours)*/
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }

    func hours(sinceDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: sinceDate, to: self)
        return components.hour ?? 0
    }

    func unixTimeForRange(_ numberDay: Float) -> Double {
        return Double(numberDay * 24 * 60 * 60)
    }

    func isExpiredForRange(_ numDay: Float) -> Bool {
        return self.unixTimestamp > Date().unixTimestamp - self.unixTimeForRange(numDay)
    }
}


extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    static func dateFormatter(_ format: String = "dd/MM/yyyy") -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    static func dateFromServerSavis(_ dateStringFull: String) -> Date {
        var dateString = dateStringFull
        if dateStringFull.contains(".") {
            dateString = dateStringFull.components(separatedBy: ".")[0]
        }
        if let date = dateFormatter("yyyy-MM-dd'T'HH:mm:ss.ZZZ").date(from: dateString){
            return date
        }else if let date = dateFormatter("yyyy-MM-dd'T'HH:mm:ss.ZZ").date(from: dateString){
            return date
        }else if let date = dateFormatter("yyyy-MM-dd'T'HH:mm:ss.Z").date(from: dateString){
            return date
        }else if let date = dateFormatter("yyyy-MM-dd'T'HH:mm:ss").date(from: dateString){
            return date
        }else{
            return Date()
        }
    }
    
    static func fromString(_ string: String, format: String) -> Date? {
        return dateFormatter(format).date(from: string)
    }
    
    static func dateFromFirebase(_ dateString: String) -> Date? {
        var timeZone = ""
        var dateTime = dateString
        if dateString.contains(".") {
            timeZone = dateString.components(separatedBy: ".")[1]
            dateTime = dateString.components(separatedBy: ".")[0]
            if timeZone.contains("+") {
                timeZone = dateString.components(separatedBy: "+")[1]
            }
            
            dateTime += "+\(timeZone)"
        }
        
        let date = dateTime.replacing(":", with: "")
        return dateFormatter(firebaseGetDateFormat).date(from: date)
    }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
extension Date {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    func timestamp() -> Int64 {

        return Int64(self.timeIntervalSince1970 * 1000)
    }

    //---------------------------------------------------------------------------------------------------------------------------------------------
    static func date(timestamp: Int64) -> Date {

        let interval = TimeInterval(TimeInterval(timestamp) / 1000)
        return Date(timeIntervalSince1970: interval)
    }
}

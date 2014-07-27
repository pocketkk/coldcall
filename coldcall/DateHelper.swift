import Foundation

class Date {
    
    class func from(#year:Int, month:Int, day:Int) -> NSDate {
        var c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        var gregorian = NSCalendar(identifier:NSGregorianCalendar)
        var date = gregorian.dateFromComponents(c)
        return date
    }
    
    class func parse(dateStr:String, format:String="yyyy-MM-dd") -> NSDate {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)
    }
    
    class func beginningOfDay(date:NSDate) ->NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        var dateFormat = NSDateFormatter()
        dateFormat.timeZone = NSTimeZone.defaultTimeZone()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let dateStr = dateFormat.stringFromDate(date)
        return dateFormat.dateFromString(dateStr)
    }
    
    class func endOfDay(date:NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        components.hour=23
        components.minute=59
        let endofDate = calendar .dateFromComponents(components)
        return endofDate
    }
    
    class func toString(date:NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: date)
        return "\(components.month)-\(components.day)-\(components.year)"
    }
}
import Foundation

/// 农历、节气、节日计算引擎（1900–2100，无第三方依赖）
enum LunarCalendarEngine {
    private static let lunarInfo: [Int] = [
        0x04bd8, 0x04ae0, 0x0a570, 0x054d5, 0x0d260, 0x0d950, 0x16554, 0x056a0, 0x09ad0, 0x055d2,
        0x04ae0, 0x0a5b6, 0x0a4d0, 0x0d250, 0x1d255, 0x0b540, 0x0d6a0, 0x0ada2, 0x095b0, 0x14977,
        0x04970, 0x0a4b0, 0x0b4b5, 0x06a50, 0x06d40, 0x1ab54, 0x02b60, 0x09570, 0x052f2, 0x04970,
        0x06566, 0x0d4a0, 0x0ea50, 0x06e95, 0x05ad0, 0x02b60, 0x186e3, 0x092e0, 0x1c8d7, 0x0c950,
        0x0d4a0, 0x1d8a6, 0x0b550, 0x056a0, 0x1a5b4, 0x025d0, 0x092d0, 0x0d2b2, 0x0a950, 0x0b557,
        0x06ca0, 0x0b550, 0x15355, 0x04da0, 0x0a5b0, 0x14573, 0x052b0, 0x0a9a8, 0x0e950, 0x06aa0,
        0x0aea6, 0x0ab50, 0x04b60, 0x0aae4, 0x0a570, 0x05260, 0x0f263, 0x0d950, 0x05b57, 0x056a0,
        0x096d0, 0x04dd5, 0x04ad0, 0x0a4d0, 0x0d4d4, 0x0d250, 0x1d558, 0x0b540, 0x0b6a0, 0x195a6,
        0x095b0, 0x049b0, 0x0a974, 0x0a4b0, 0x0b27a, 0x06a50, 0x06d40, 0x0af46, 0x0ab60, 0x09570,
        0x04af5, 0x04970, 0x064b0, 0x074a3, 0x0ea50, 0x06b58, 0x05ac0, 0x0ab60, 0x096d5, 0x092e0,
        0x0c960, 0x0d954, 0x0d4a0, 0x0da50, 0x07552, 0x056a0, 0x0abb7, 0x025d0, 0x092d0, 0x0cab5,
        0x0a950, 0x0b4a0, 0x0baa4, 0x0ad50, 0x055d9, 0x04ba0, 0x0a5b0, 0x15176, 0x052b0, 0x0a930,
        0x07954, 0x06aa0, 0x0ad50, 0x05b52, 0x04b60, 0x0a6e6, 0x0a4e0, 0x0d260, 0x0ea65, 0x0d530,
        0x05aa0, 0x076a3, 0x096d0, 0x04afb, 0x04ad0, 0x0a4d0, 0x1d0b6, 0x0d250, 0x0d520, 0x0dd45,
        0x0b5a0, 0x056d0, 0x055b2, 0x049b0, 0x0a577, 0x0a4b0, 0x0aa50, 0x1b255, 0x06d20, 0x0ada0,
        0x14b63, 0x09370, 0x049f8, 0x04970, 0x064b0, 0x168a6, 0x0ea50, 0x06b20, 0x1a6c4, 0x0aae0,
        0x0a2e0, 0x0d2e3, 0x0c960, 0x0d557, 0x0d4a0, 0x0da50, 0x05d55, 0x056a0, 0x0a6d0, 0x055d4,
        0x052d0, 0x0a9b8, 0x0a950, 0x0b4a0, 0x0b6a6, 0x0ad50, 0x055a0, 0x0aba4, 0x0a5b0, 0x052b0,
        0x0b273, 0x06930, 0x07337, 0x06aa0, 0x0ad50, 0x14b55, 0x04b60, 0x0a570, 0x054e4, 0x0d160,
        0x0e968, 0x0d520, 0x0daa0, 0x16aa6, 0x056d0, 0x04ae0, 0x0a9d4, 0x0a2d0, 0x0d150, 0x0f252,
        0x0d520
    ]

    private static let heavenlyStems = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
    private static let earthlyBranches = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
    private static let zodiacAnimals = ["鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪"]
    private static let lunarMonths = ["正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊"]
    private static let lunarDays = [
        "初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
        "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
        "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"
    ]

    private static let solarTermNames = [
        "小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨",
        "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑",
        "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"
    ]

    struct LunarDate: Equatable {
        let year: Int
        let month: Int
        let day: Int
        let isLeapMonth: Bool
    }

    // MARK: - Public API

    static func lunar(for date: Date, calendar inputCalendar: Calendar = .current) -> LunarDate? {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? inputCalendar.timeZone
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let y = components.year, let m = components.month, let d = components.day else { return nil }
        guard y >= 1900, y <= 2100 else { return nil }

        let offset = daysBetween(year: 1900, month: 1, day: 31, targetYear: y, targetMonth: m, targetDay: d, calendar: calendar)
        guard offset >= 0 else { return nil }

        var lunarYear = 2100
        while lunarYear > 1900 {
            if offset >= springFestivalOffset(for: lunarYear) { break }
            lunarYear -= 1
        }

        var dayOffset = offset - springFestivalOffset(for: lunarYear)
        let leap = leapMonth(lunarYear)
        var isLeap = false
        var lunarMonth = 1

        while lunarMonth < 13 {
            var daysInMonth: Int
            if leap > 0, lunarMonth == leap + 1, !isLeap {
                lunarMonth -= 1
                isLeap = true
                daysInMonth = leapDays(lunarYear)
            } else {
                daysInMonth = monthDays(lunarYear, lunarMonth)
            }

            if dayOffset < daysInMonth { break }

            dayOffset -= daysInMonth
            if isLeap, lunarMonth == leap + 1 {
                isLeap = false
            }
            lunarMonth += 1
        }

        return LunarDate(year: lunarYear, month: lunarMonth, day: dayOffset + 1, isLeapMonth: isLeap)
    }

    /// 农历年春节对应的公历日偏移（相对 1900-01-31）
    private static func springFestivalOffset(for lunarYear: Int) -> Int {
        guard lunarYear > 1900 else { return 0 }
        var total = 0
        for year in 1900..<lunarYear {
            total += lunarYearDays(year)
        }
        return total - 1
    }

    static func lunarFullDescription(for date: Date) -> String {
        guard let lunar = lunar(for: date) else { return "" }
        let stem = heavenlyStems[(lunar.year - 4) % 10]
        let branch = earthlyBranches[(lunar.year - 4) % 12]
        let zodiac = zodiacAnimals[(lunar.year - 4) % 12]
        let monthName = (lunar.isLeapMonth ? "闰" : "") + lunarMonths[lunar.month - 1] + "月"
        let dayName = lunarDays[lunar.day - 1]
        return "\(stem)\(branch)年\(zodiac)年\(monthName)\(dayName)"
    }

    static func lunarShortLabel(for date: Date) -> String {
        if let term = solarTerm(on: date) { return term }
        if let festival = festivalLabel(for: date) { return festival }
        guard let lunar = lunar(for: date) else { return "" }
        if lunar.day == 1 {
            let monthName = (lunar.isLeapMonth ? "闰" : "") + lunarMonths[lunar.month - 1] + "月"
            return monthName
        }
        return lunarDays[lunar.day - 1]
    }

    static func zodiacYear(for date: Date) -> String {
        guard let lunar = lunar(for: date) else { return "" }
        let stem = heavenlyStems[(lunar.year - 4) % 10]
        let branch = earthlyBranches[(lunar.year - 4) % 12]
        let zodiac = zodiacAnimals[(lunar.year - 4) % 12]
        return "\(stem)\(branch)年 · \(zodiac)年"
    }

    static func solarTerm(on date: Date, calendar: Calendar = .current) -> String? {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let y = components.year, let m = components.month, let d = components.day else { return nil }
        let terms = solarTerms(in: y)
        for (index, termDate) in terms.enumerated() {
            let tc = calendar.dateComponents([.month, .day], from: termDate)
            if tc.month == m && tc.day == d {
                return solarTermNames[index]
            }
        }
        return nil
    }

    static func nextSolarTerm(from date: Date, calendar: Calendar = .current) -> CountdownInfo? {
        let year = calendar.component(.year, from: date)
        var candidates: [(String, Date)] = []
        for y in year...(year + 1) {
            let terms = solarTerms(in: y)
            for (i, termDate) in terms.enumerated() {
                if termDate > date {
                    candidates.append((solarTermNames[i], termDate))
                }
            }
        }
        guard let next = candidates.sorted(by: { $0.1 < $1.1 }).first else { return nil }
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: next.1)).day ?? 0
        return CountdownInfo(title: "距\(next.0)", daysRemaining: max(days, 0), targetDate: next.1)
    }

    static func nextFestival(from date: Date, calendar: Calendar = .current) -> CountdownInfo? {
        let year = calendar.component(.year, from: date)
        var candidates: [(String, Date)] = []
        for y in year...(year + 1) {
            for holiday in HolidayCatalog.all {
                if let d = holiday.date(in: y, engine: self, calendar: calendar), d > date {
                    candidates.append((holiday.name, d))
                }
            }
        }
        guard let next = candidates.sorted(by: { $0.1 < $1.1 }).first else { return nil }
        let days = calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: next.1)).day ?? 0
        return CountdownInfo(title: "距\(next.0)", daysRemaining: max(days, 0), targetDate: next.1)
    }

    static func festivalLabel(for date: Date, calendar: Calendar = .current) -> String? {
        let year = calendar.component(.year, from: date)
        for holiday in HolidayCatalog.all {
            if let d = holiday.date(in: year, engine: self, calendar: calendar),
               calendar.isDate(d, inSameDayAs: date) {
                return holiday.name
            }
        }
        return nil
    }

    static func isPublicHoliday(_ date: Date, calendar: Calendar = .current) -> Bool {
        festivalLabel(for: date, calendar: calendar) != nil
    }

    // MARK: - Solar terms (寿星天文历算法)

    static func solarTerms(in year: Int) -> [Date] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current

        var result: [Date] = []
        let y = Double(year % 100)
        let offsets = [6.11, 20.84, 4.15, 18.73, 5.63, 20.646, 4.81, 20.1, 5.52, 21.04, 5.678, 21.37,
                       7.108, 22.83, 7.5, 23.13, 7.646, 23.042, 8.318, 23.438, 7.438, 23.13, 7.18, 22.36]
        for index in 0..<24 {
            let month: Int
            if index < 2 { month = 1 }
            else if index < 4 { month = 2 }
            else { month = (index + 2) / 2 }

            let day: Int
            if index < 2 {
                day = Int(floor(y * 0.2422 + offsets[index] - floor((Double(year) - 1.0) / 4.0)))
            } else if index < 4 {
                day = Int(floor(y * 0.2422 + offsets[index] - floor((Double(year) - 1.0) / 4.0)))
            } else {
                day = Int(floor(y * 0.2422 + offsets[index] - floor(Double(year) / 4.0)))
            }

            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = max(1, min(31, day))
            components.hour = 12
            if let date = calendar.date(from: components) {
                result.append(date)
            }
        }
        return result
    }

    // MARK: - Internal lunar helpers

    private static func lunarYearDays(_ year: Int) -> Int {
        var sum = 348
        var bit = 0x8000
        let info = lunarInfo[year - 1900]
        while bit > 0x8 {
            if (info & bit) != 0 { sum += 1 }
            bit >>= 1
        }
        return sum + leapDays(year)
    }

    private static func leapMonth(_ year: Int) -> Int {
        lunarInfo[year - 1900] & 0xf
    }

    private static func leapDays(_ year: Int) -> Int {
        if leapMonth(year) != 0 {
            return (lunarInfo[year - 1900] & 0x10000) != 0 ? 30 : 29
        }
        return 0
    }

    private static func monthDays(_ year: Int, _ month: Int) -> Int {
        (lunarInfo[year - 1900] & (0x10000 >> month)) != 0 ? 30 : 29
    }

    private static func daysBetween(year: Int, month: Int, day: Int, targetYear: Int, targetMonth: Int, targetDay: Int, calendar: Calendar) -> Int {
        var start = DateComponents()
        start.year = year; start.month = month; start.day = day
        start.hour = 12
        var end = DateComponents()
        end.year = targetYear; end.month = targetMonth; end.day = targetDay
        end.hour = 12
        guard let s = calendar.date(from: start), let e = calendar.date(from: end) else { return 0 }
        return calendar.dateComponents([.day], from: s, to: e).day ?? 0
    }

    static func solarDate(fromLunar year: Int, month: Int, day: Int, isLeap: Bool = false, calendar inputCalendar: Calendar = .current) -> Date? {
        guard year >= 1900, year <= 2100 else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? inputCalendar.timeZone

        var offset = springFestivalOffset(for: year)
        let leap = leapMonth(year)

        for m in 1..<month {
            offset += monthDays(year, m)
            if leap > 0, m == leap { offset += leapDays(year) }
        }
        if isLeap, leap == month { offset += monthDays(year, month) }
        offset += day - 1

        var base = DateComponents()
        base.year = 1900; base.month = 1; base.day = 31; base.hour = 12
        guard let start = calendar.date(from: base) else { return nil }
        return calendar.date(byAdding: .day, value: offset, to: start)
    }
}

// MARK: - Holiday catalog

enum HolidayCatalog {
    struct Holiday {
        enum Kind { case solar(month: Int, day: Int); case lunar(month: Int, day: Int) }
        let name: String
        let kind: Kind
        let isPublicHoliday: Bool

        func date(in year: Int, engine: LunarCalendarEngine.Type, calendar: Calendar) -> Date? {
            switch kind {
            case .solar(let month, let day):
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = day
                components.hour = 12
                return calendar.date(from: components)
            case .lunar(let month, let day):
                return engine.solarDate(fromLunar: year, month: month, day: day, calendar: calendar)
            }
        }
    }

    static let all: [Holiday] = [
        Holiday(name: "元旦", kind: .solar(month: 1, day: 1), isPublicHoliday: true),
        Holiday(name: "春节", kind: .lunar(month: 1, day: 1), isPublicHoliday: true),
        Holiday(name: "元宵节", kind: .lunar(month: 1, day: 15), isPublicHoliday: false),
        Holiday(name: "清明节", kind: .solar(month: 4, day: 5), isPublicHoliday: true),
        Holiday(name: "劳动节", kind: .solar(month: 5, day: 1), isPublicHoliday: true),
        Holiday(name: "端午节", kind: .lunar(month: 5, day: 5), isPublicHoliday: true),
        Holiday(name: "中秋节", kind: .lunar(month: 8, day: 15), isPublicHoliday: true),
        Holiday(name: "国庆节", kind: .solar(month: 10, day: 1), isPublicHoliday: true),
        Holiday(name: "七夕", kind: .lunar(month: 7, day: 7), isPublicHoliday: false),
        Holiday(name: "重阳节", kind: .lunar(month: 9, day: 9), isPublicHoliday: false),
        Holiday(name: "腊八", kind: .lunar(month: 12, day: 8), isPublicHoliday: false),
        Holiday(name: "除夕", kind: .lunar(month: 12, day: 30), isPublicHoliday: true),
    ]
}

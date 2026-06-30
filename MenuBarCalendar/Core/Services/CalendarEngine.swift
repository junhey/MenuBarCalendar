import Foundation

struct CalendarEngine {
    let weekStartsOnMonday: Bool

    private var calendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "zh_CN")
        cal.firstWeekday = weekStartsOnMonday ? 2 : 1
        cal.minimumDaysInFirstWeek = 4
        return cal
    }

    func monthData(for month: Date, today: Date = .now) -> MonthCalendarData {
        let cal = calendar
        let startOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let daysInMonth = cal.range(of: .day, in: .month, for: startOfMonth)!.count

        let weekdayOfFirst = cal.component(.weekday, from: startOfMonth)
        let firstWeekday = cal.firstWeekday
        var leading = weekdayOfFirst - firstWeekday
        if leading < 0 { leading += 7 }

        var cells: [CalendarDay?] = []
        if leading > 0 {
            for i in stride(from: leading, to: 0, by: -1) {
                if let date = cal.date(byAdding: .day, value: -i, to: startOfMonth) {
                    cells.append(makeDay(date: date, isCurrentMonth: false, today: today))
                }
            }
        }

        for day in 1...daysInMonth {
            if let date = cal.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                cells.append(makeDay(date: date, isCurrentMonth: true, today: today))
            }
        }

        while cells.count % 7 != 0 {
            let offset = cells.count - leading - daysInMonth + 1
            if let date = cal.date(byAdding: .day, value: daysInMonth - 1 + offset, to: startOfMonth) {
                cells.append(makeDay(date: date, isCurrentMonth: false, today: today))
            } else {
                cells.append(nil)
            }
        }

        let weeks = stride(from: 0, to: cells.count, by: 7).map { index in
            Array(cells[index..<min(index + 7, cells.count)])
        }

        let weekNumbers = weeks.compactMap { week -> Int? in
            guard let firstDay = week.compactMap({ $0 }).first else { return nil }
            return cal.component(.weekOfYear, from: firstDay.date)
        }

        return MonthCalendarData(month: startOfMonth, weeks: weeks, weekNumbers: weekNumbers)
    }

    func dayDetail(for date: Date) -> DayDetail {
        let cal = calendar
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月d日"
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "zh_CN")
        weekdayFormatter.dateFormat = "EEEE"

        return DayDetail(
            gregorian: formatter.string(from: date),
            weekday: weekdayFormatter.string(from: date),
            weekOfYear: cal.component(.weekOfYear, from: date),
            lunarFull: LunarCalendarEngine.lunarFullDescription(for: date),
            zodiacYear: LunarCalendarEngine.zodiacYear(for: date),
            solarTerm: LunarCalendarEngine.solarTerm(on: date),
            festival: LunarCalendarEngine.festivalLabel(for: date),
            isHoliday: LunarCalendarEngine.isPublicHoliday(date)
        )
    }

    private func makeDay(date: Date, isCurrentMonth: Bool, today: Date) -> CalendarDay {
        let cal = calendar
        let dayNumber = cal.component(.day, from: date)
        let weekday = cal.component(.weekday, from: date)
        let isWeekend = weekday == 1 || weekday == 7
        let isToday = cal.isDate(date, inSameDayAs: today)
        let isHoliday = LunarCalendarEngine.isPublicHoliday(date)

        return CalendarDay(
            id: ISO8601DateFormatter().string(from: date),
            date: date,
            dayNumber: dayNumber,
            isCurrentMonth: isCurrentMonth,
            isToday: isToday,
            isWeekend: isWeekend,
            isHoliday: isHoliday,
            lunarLabel: LunarCalendarEngine.lunarShortLabel(for: date),
            festivalLabel: LunarCalendarEngine.festivalLabel(for: date),
            weekOfYear: cal.component(.weekOfYear, from: date)
        )
    }
}

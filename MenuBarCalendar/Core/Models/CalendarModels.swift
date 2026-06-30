import Foundation

struct CalendarDay: Identifiable, Equatable {
    let id: String
    let date: Date
    let dayNumber: Int
    let isCurrentMonth: Bool
    let isToday: Bool
    let isWeekend: Bool
    let isHoliday: Bool
    let lunarLabel: String
    let festivalLabel: String?
    let weekOfYear: Int
}

struct MonthCalendarData: Equatable {
    let month: Date
    let weeks: [[CalendarDay?]]
    let weekNumbers: [Int]
}

struct CountdownInfo: Equatable {
    let title: String
    let daysRemaining: Int
    let targetDate: Date
}

struct DayDetail: Equatable {
    let gregorian: String
    let weekday: String
    let weekOfYear: Int
    let lunarFull: String
    let zodiacYear: String
    let solarTerm: String?
    let festival: String?
    let isHoliday: Bool
}

struct MenuBarTimeSegment: Equatable {
    let text: String
    let isBlinkingSeparator: Bool
}

struct MenuBarFormattedText: Equatable {
    let text: String
    let timeSegments: [MenuBarTimeSegment]?
    let usesAnalogIcon: Bool

    init(text: String, timeSegments: [MenuBarTimeSegment]? = nil, usesAnalogIcon: Bool = false) {
        self.text = text
        self.timeSegments = timeSegments
        self.usesAnalogIcon = usesAnalogIcon
    }
}

import SwiftUI
import AppKit

@MainActor
final class CalendarPanelViewModel: ObservableObject {
    @Published var displayedMonth: Date = .now
    @Published var selectedDate: Date = .now
    @Published var copiedFeedback = false

    private let settings: UserSettings
    private let clock: ClockService

    init(settings: UserSettings = .shared, clock: ClockService) {
        self.settings = settings
        self.clock = clock
    }

    var now: Date { clock.now }

    var engine: CalendarEngine {
        CalendarEngine(weekStartsOnMonday: settings.weekStartsOnMonday)
    }

    var monthData: MonthCalendarData {
        engine.monthData(for: displayedMonth, today: now)
    }

    var dayDetail: DayDetail {
        engine.dayDetail(for: selectedDate)
    }

    var isSelectedToday: Bool {
        Calendar.current.isDate(selectedDate, inSameDayAs: now)
    }

    var nextSolarTerm: CountdownInfo? {
        LunarCalendarEngine.nextSolarTerm(from: now)
    }

    var nextFestival: CountdownInfo? {
        LunarCalendarEngine.nextFestival(from: now)
    }

    var upcomingFestivals: [CountdownInfo] {
        guard settings.showUpcomingFestivals else { return [] }
        return LunarCalendarEngine.upcomingFestivals(from: now, limit: 3)
    }

    func goToToday() {
        displayedMonth = now
        selectedDate = now
    }

    func previousMonth() {
        displayedMonth = Calendar.current.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
    }

    func nextMonth() {
        displayedMonth = Calendar.current.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
    }

    func select(_ date: Date) {
        selectedDate = date
        if !Calendar.current.isDate(date, equalTo: displayedMonth, toGranularity: .month) {
            displayedMonth = date
        }
    }

    func copySelectedDate() {
        let detail = dayDetail
        var lines = [detail.gregorian, detail.weekday, detail.lunarFull]
        if let festival = detail.festival { lines.append(festival) }
        if let term = detail.solarTerm { lines.append("节气：\(term)") }
        let text = lines.joined(separator: " · ")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        copiedFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.copiedFeedback = false
        }
    }
}

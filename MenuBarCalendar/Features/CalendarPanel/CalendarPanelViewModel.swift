import SwiftUI

@MainActor
final class CalendarPanelViewModel: ObservableObject {
    @Published var displayedMonth: Date = .now
    @Published var selectedDate: Date = .now

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

    var nextSolarTerm: CountdownInfo? {
        LunarCalendarEngine.nextSolarTerm(from: now)
    }

    var nextFestival: CountdownInfo? {
        LunarCalendarEngine.nextFestival(from: now)
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
}

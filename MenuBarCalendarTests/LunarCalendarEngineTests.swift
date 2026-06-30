import XCTest
@testable import MenuBarCalendar

final class LunarCalendarEngineTests: XCTestCase {
    func testLunarNewYear2025() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 29
        components.hour = 12
        let date = calendar.date(from: components)!
        let lunar = LunarCalendarEngine.lunar(for: date, calendar: calendar)
        XCTAssertNotNil(lunar)
        XCTAssertEqual(lunar?.month, 1)
        XCTAssertEqual(lunar?.day, 1)
    }

    func testSpringFestivalLabel() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")!
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 29
        components.hour = 12
        let date = calendar.date(from: components)!
        XCTAssertEqual(LunarCalendarEngine.festivalLabel(for: date, calendar: calendar), "春节")
    }

    func testNextSolarTermExists() {
        let info = LunarCalendarEngine.nextSolarTerm(from: .now)
        XCTAssertNotNil(info)
        XCTAssertGreaterThanOrEqual(info!.daysRemaining, 0)
    }
}

final class CalendarEngineTests: XCTestCase {
    func testMonthGridHasSixWeeks() {
        let engine = CalendarEngine(weekStartsOnMonday: true)
        let data = engine.monthData(for: .now)
        XCTAssertFalse(data.weeks.isEmpty)
        XCTAssertEqual(data.weeks.first?.count, 7)
    }
}

final class MenuBarFormatterTests: XCTestCase {
    func testTimeOnlyFormat() {
        let settings = UserSettings.shared
        settings.displayMode = .timeOnly
        settings.timeFormat = .hour24
        settings.showSeconds = false
        let formatter = MenuBarFormatter(settings: settings)
        let result = formatter.format(date: Date(timeIntervalSince1970: 0))
        XCTAssertFalse(result.text.isEmpty)
    }
}

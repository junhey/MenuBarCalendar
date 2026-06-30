import Foundation
import Combine

enum MenuBarDisplayMode: String, CaseIterable, Identifiable, Codable {
    case timeOnly
    case timeAndDate
    case timeAndWeekday
    case timeDateWeekday
    case dateOnly
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .timeOnly: return "仅时间"
        case .timeAndDate: return "时间 + 日期"
        case .timeAndWeekday: return "时间 + 星期"
        case .timeDateWeekday: return "时间 + 日期 + 星期"
        case .dateOnly: return "仅日期"
        case .custom: return "自定义格式"
        }
    }
}

enum TimeFormat: String, CaseIterable, Identifiable, Codable {
    case hour24
    case hour12

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hour24: return "24 小时制"
        case .hour12: return "12 小时制"
        }
    }
}

final class UserSettings: ObservableObject {
    static let shared = UserSettings()

    private enum Keys {
        static let displayMode = "displayMode"
        static let customFormat = "customFormat"
        static let timeFormat = "timeFormat"
        static let weekStartsOnMonday = "weekStartsOnMonday"
        static let showSeconds = "showSeconds"
        static let useIconOnly = "useIconOnly"
    }

    @Published var displayMode: MenuBarDisplayMode {
        didSet { UserDefaults.standard.set(displayMode.rawValue, forKey: Keys.displayMode) }
    }

    @Published var customFormat: String {
        didSet { UserDefaults.standard.set(customFormat, forKey: Keys.customFormat) }
    }

    @Published var timeFormat: TimeFormat {
        didSet { UserDefaults.standard.set(timeFormat.rawValue, forKey: Keys.timeFormat) }
    }

    @Published var weekStartsOnMonday: Bool {
        didSet { UserDefaults.standard.set(weekStartsOnMonday, forKey: Keys.weekStartsOnMonday) }
    }

    @Published var showSeconds: Bool {
        didSet { UserDefaults.standard.set(showSeconds, forKey: Keys.showSeconds) }
    }

    @Published var useIconOnly: Bool {
        didSet { UserDefaults.standard.set(useIconOnly, forKey: Keys.useIconOnly) }
    }

    private init() {
        let defaults = UserDefaults.standard
        displayMode = MenuBarDisplayMode(
            rawValue: defaults.string(forKey: Keys.displayMode) ?? MenuBarDisplayMode.timeDateWeekday.rawValue
        ) ?? .timeDateWeekday
        customFormat = defaults.string(forKey: Keys.customFormat) ?? "HH:mm EEE M/d"
        timeFormat = TimeFormat(rawValue: defaults.string(forKey: Keys.timeFormat) ?? "") ?? .hour24
        weekStartsOnMonday = defaults.object(forKey: Keys.weekStartsOnMonday) as? Bool ?? true
        showSeconds = defaults.object(forKey: Keys.showSeconds) as? Bool ?? false
        useIconOnly = defaults.object(forKey: Keys.useIconOnly) as? Bool ?? false
    }
}

import Foundation
import Combine

enum MenuBarDisplayMode: String, CaseIterable, Identifiable, Codable {
    case timeOnly
    case timeAndDate
    case timeAndWeekday
    case timeDateWeekday
    case timeDateLunar
    case dateOnly
    case dateWeekday
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .timeOnly: return "仅时间"
        case .timeAndDate: return "时间 + 日期"
        case .timeAndWeekday: return "时间 + 星期"
        case .timeDateWeekday: return "时间 + 日期 + 星期"
        case .timeDateLunar: return "时间 + 日期 + 农历"
        case .dateOnly: return "仅日期"
        case .dateWeekday: return "日期 + 星期"
        case .custom: return "自定义格式"
        }
    }

    static var presets: [MenuBarDisplayMode] {
        [.timeOnly, .timeAndDate, .timeAndWeekday, .timeDateWeekday, .timeDateLunar, .dateOnly, .dateWeekday, .custom]
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

enum MenuBarTimeStyle: String, CaseIterable, Identifiable, Codable {
    case digital
    case analog

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .digital: return "数码"
        case .analog: return "指针"
        }
    }
}

enum VoiceAnnouncementInterval: Int, CaseIterable, Identifiable, Codable {
    case hourly = 60
    case every30Minutes = 30
    case every15Minutes = 15

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .hourly: return "整点"
        case .every30Minutes: return "每 30 分钟"
        case .every15Minutes: return "每 15 分钟"
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
        static let showUpcomingFestivals = "showUpcomingFestivals"
        static let showAMPM = "showAMPM"
        static let blinkTimeSeparator = "blinkTimeSeparator"
        static let menuBarTimeStyle = "menuBarTimeStyle"
        static let voiceAnnouncementEnabled = "voiceAnnouncementEnabled"
        static let voiceAnnouncementInterval = "voiceAnnouncementInterval"
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

    @Published var showUpcomingFestivals: Bool {
        didSet { UserDefaults.standard.set(showUpcomingFestivals, forKey: Keys.showUpcomingFestivals) }
    }

    @Published var showAMPM: Bool {
        didSet { UserDefaults.standard.set(showAMPM, forKey: Keys.showAMPM) }
    }

    @Published var blinkTimeSeparator: Bool {
        didSet { UserDefaults.standard.set(blinkTimeSeparator, forKey: Keys.blinkTimeSeparator) }
    }

    @Published var menuBarTimeStyle: MenuBarTimeStyle {
        didSet { UserDefaults.standard.set(menuBarTimeStyle.rawValue, forKey: Keys.menuBarTimeStyle) }
    }

    @Published var voiceAnnouncementEnabled: Bool {
        didSet { UserDefaults.standard.set(voiceAnnouncementEnabled, forKey: Keys.voiceAnnouncementEnabled) }
    }

    @Published var voiceAnnouncementInterval: VoiceAnnouncementInterval {
        didSet { UserDefaults.standard.set(voiceAnnouncementInterval.rawValue, forKey: Keys.voiceAnnouncementInterval) }
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
        showUpcomingFestivals = defaults.object(forKey: Keys.showUpcomingFestivals) as? Bool ?? true
        showAMPM = defaults.object(forKey: Keys.showAMPM) as? Bool ?? true
        blinkTimeSeparator = defaults.object(forKey: Keys.blinkTimeSeparator) as? Bool ?? false
        menuBarTimeStyle = MenuBarTimeStyle(
            rawValue: defaults.string(forKey: Keys.menuBarTimeStyle) ?? ""
        ) ?? .digital
        voiceAnnouncementEnabled = defaults.object(forKey: Keys.voiceAnnouncementEnabled) as? Bool ?? false
        let intervalRaw = defaults.object(forKey: Keys.voiceAnnouncementInterval) as? Int ?? VoiceAnnouncementInterval.hourly.rawValue
        voiceAnnouncementInterval = VoiceAnnouncementInterval(rawValue: intervalRaw) ?? .hourly
    }
}
